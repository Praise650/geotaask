import 'dart:convert';

import 'dart:ui';
import 'dart:math';
import 'dart:typed_data';
import 'dart:developer' as dev;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../utils/helpers.dart';
import '../model/marker_entity.dart';

// Add these constants for action IDs
class NotificationActions {
  static const String showDetails = 'SHOW_DETAILS';
  static const String mute = 'MUTE_REMINDER';
  static const String markComplete = 'MARK_COMPLETE';
}

class NotificationService {
  final _localNotifications = FlutterLocalNotificationsPlugin();

  NotificationService();

  // Future<void> initNotification() async {
  //   dev.log('=== NOTIFICATION SERVICE INITIALIZING ===');
  //   // Initialize local notifications
  //   const initializationSettingsAndroid = AndroidInitializationSettings(
  //     '@mipmap/ic_launcher',
  //   );
  //
  //   const initializationSettingsIOS = DarwinInitializationSettings(
  //     requestAlertPermission: true,
  //     requestBadgePermission: true,
  //     requestSoundPermission: true,
  //   );
  //
  //   const initializationSettings = InitializationSettings(
  //     android: initializationSettingsAndroid,
  //     iOS: initializationSettingsIOS,
  //   );
  //
  //   final bool? initialized = await plugin.initialize(
  //     initializationSettings,
  //     onDidReceiveNotificationResponse: (NotificationResponse response) {
  //       dev.log('Notification clicked with payload: ${response.payload}');
  //       // Handle notification tap
  //     },
  //   );
  //
  //   if (initialized != true) {
  //     dev.log('Failed to initialize notifications plugin.');
  //     return;
  //   }
  //
  //   // Create notification channel for Android
  //   const channel = AndroidNotificationChannel(
  //     'geofence_triggers',
  //     'Geofence Triggers',
  //     description: 'Notifications for geofence events',
  //     importance: Importance.max,
  //   );
  //
  //   await plugin
  //       .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin
  //       >()
  //       ?.createNotificationChannel(channel);
  //   dev.log('=== NOTIFICATION SERVICE DONE ===');
  // }
  //
  // Future<void> showNotification(MarkerEntity notification) async {
  //   AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       const AndroidNotificationDetails(
  //         'geofence_triggers',
  //         'Geofence Triggers',
  //         importance: Importance.max,
  //         priority: Priority.high,
  //         showWhen: true,
  //       );
  //
  //   NotificationDetails platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //     iOS: DarwinNotificationDetails(
  //       interruptionLevel: InterruptionLevel.active,
  //     ),
  //   );
  //   final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  //
  //   await plugin.show(
  //     notificationId,
  //     'Geofence ${Helpers.capitalize(notification.title!)}',
  //     notification.description,
  //     platformChannelSpecifics,
  //     payload: json.encode(notification.toJson()),
  //   );
  //
  //   dev.log('Notification sent with ID: $notificationId');
  //   dev.log('Notification displayed with payload: ${notification.toJson()}');
  // }

  Future<void> initializePlatformNotifications() async {
    // Define notification categories for iOS with actions
    final List<DarwinNotificationCategory> darwinNotificationCategories = [
      DarwinNotificationCategory(
        'reminderCategory',
        actions: [
          DarwinNotificationAction.plain(
            NotificationActions.showDetails,
            'Show Details',
            options: {DarwinNotificationActionOption.foreground},
          ),
          DarwinNotificationAction.plain(
            NotificationActions.mute,
            'Mute',
            options: {DarwinNotificationActionOption.destructive},
          ),
          DarwinNotificationAction.plain(
            NotificationActions.markComplete,
            'Complete',
            options: {DarwinNotificationActionOption.foreground},
          ),
        ],
      ),
    ];

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final initializationSettingsIOS = DarwinInitializationSettings(
      notificationCategories: darwinNotificationCategories,
      requestProvisionalPermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveLocalNotification,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );
  }

  // void onDidReceiveLocalNotification(NotificationResponse? response) {
  //   var data = response?.payload.toString();
  //
  //   dev.log('$data', name: 'onDidReceiveLocalNotification');
  // }
  //
  // static void onDidReceiveBackgroundNotificationResponse(
  //     NotificationResponse? response) {
  //   var data = response?.payload.toString();
  //
  //   dev.log('$data', name: 'onDidReceiveBackgroundNotificationResponse');
  // }

  void onDidReceiveLocalNotification(NotificationResponse? response) {
    if (response == null) return;

    var data = response.payload.toString();
    var actionId = response.actionId;

    dev.log(
      'Notification tapped - Action: $actionId, Payload: $data',
      name: 'onDidReceiveLocalNotification',
    );

    // Handle different actions
    _handleNotificationAction(actionId, data);
  }

  static void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse? response) {
    if (response == null) return;

    var data = response.payload.toString();
    var actionId = response.actionId;

    dev.log(
      'Background notification - Action: $actionId, Payload:  $data',
      name: 'onDidReceiveBackgroundNotificationResponse',
    );

    // Handle different actions in background
    _handleNotificationAction(actionId, data);
  }

  static void _handleNotificationAction(String? actionId, String payload) {
    // You might want to parse the payload to get reminder ID and other data
    // Example payload format: "reminderId:123,type:medication,title:Take Pills"

    switch (actionId) {
      case NotificationActions.showDetails:
        // Navigate to reminder details screen
        // You might need to use a global navigator key or app state management
        dev.log(
          'Opening reminder details for: $payload',
          name: 'NotificationAction',
        );
        _showReminderDetails(payload);
        break;

      case NotificationActions.mute:
        // Mute the reminder (disable future notifications)
        dev.log('Muting reminder: $payload', name: 'NotificationAction');
        _muteReminder(payload);
        break;

      case NotificationActions.markComplete:
        // Mark reminder as complete
        dev.log(
          'Marking reminder complete: $payload',
          name: 'NotificationAction',
        );
        _markReminderComplete(payload);
        break;

      default:
        // Default action (notification tap without specific action)
        dev.log(
          'Default notification tap: $payload',
          name: 'NotificationAction',
        );
        _showReminderDetails(payload);
        break;
    }
  }

  // Placeholder methods - implement based on your app's architecture
  static void _showReminderDetails(String payload) {
    // Implement navigation to reminder details
    // You might need to use GetX, Provider, Bloc, or other state management
  }

  static void _muteReminder(String payload) {
    // Implement muting logic
    // Update database, cancel future notifications, etc.
  }

  static void _markReminderComplete(String payload) {
    // Implement completion logic
    // Update database, cancel notification, mark as done, etc.
  }

  Future<NotificationDetails> _notificationDetails() async {
    final details = await _localNotifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {}

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: _createAndroidNotificationDetails(),
      iOS: _createDarwinNotificationDetails(),
    );

    return platformChannelSpecifics;
  }

  AndroidNotificationDetails _createAndroidNotificationDetails() {
    return AndroidNotificationDetails(
      'dev.lttl.wyatt', // avoids: Unhandled Exception: LateInitializationError: Field 'packageName' has not been initialized.
      'Wyatt', // avoids: Unhandled Exception: LateInitializationError: Field 'appName' has not been initialized.
      groupKey: 'dev.lttl.wyatt', // groups alerts in the notification tray
      channelDescription: 'Wyatt reminders',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
      // no initial delay, vibrate for 1s, wait for 0.5, vibrate for 1s
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      playSound: false,
      // let's make each notification a different color to make them easier to distinguish
      color: Color((Random().nextDouble() * 0xFFFFFF).toInt()),
      // Add action buttons for Android
      actions: [
        AndroidNotificationAction(
          NotificationActions.showDetails,
          'Show Details',
          icon: DrawableResourceAndroidBitmap(
            '@drawable/ic_info',
          ), // optional icon
        ),
        AndroidNotificationAction(
          NotificationActions.mute,
          'Mute',
          icon: DrawableResourceAndroidBitmap(
            '@drawable/ic_volume_off',
          ), // optional icon
        ),
        AndroidNotificationAction(
          NotificationActions.markComplete,
          'Complete',
          icon: DrawableResourceAndroidBitmap(
            '@drawable/ic_check',
          ), // optional icon
        ),
      ],
    );
  }

  DarwinNotificationDetails _createDarwinNotificationDetails() {
    return DarwinNotificationDetails(
      // group notifications together
      threadIdentifier: 'dev.lttl.wyatt',
      categoryIdentifier: 'reminderCategory',
      // see https://github.com/MaikuB/flutter_local_notifications/blob/master/flutter_local_notifications/example/lib/main.dart#L62
      // This must match the category defined in initialization
    );
  }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    dev.log(
      'id: $id, title: $title, body: $body, payload: $payload',
      name: 'showLocalNotification',
    );

    final platformChannelSpecifics = await _notificationDetails();
    await _localNotifications.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // Helper method to create structured payload
  String createReminderPayload({
    required int reminderId,
    required String reminderType,
    required String title,
    Map<String, String>? additionalData,
  }) {
    Map<String, String> payloadData = {
      'reminderId': reminderId.toString(),
      'type': reminderType,
      'title': title,
    };

    if (additionalData != null) {
      payloadData.addAll(additionalData);
    }

    return payloadData.entries.map((e) => '${e.key}:${e.value}').join(',');
  }

  // Helper method to parse payload
  Map<String, String> parseReminderPayload(String payload) {
    Map<String, String> data = {};

    try {
      List<String> pairs = payload.split(',');
      for (String pair in pairs) {
        List<String> keyValue = pair.split(':');
        if (keyValue.length == 2) {
          data[keyValue[0]] = keyValue[1];
        }
      }
    } catch (e) {
      dev.log('Error parsing payload: $e', name: 'parseReminderPayload');
    }

    return data;
  }
}
