import 'package:flutter/material.dart';

import '../../../core/model/places/place_entity.dart';
import '../../../utils/call_manager.dart';
import '../../../utils/utils.dart';

class NearbyPlacesDetailBottomSheet extends StatelessWidget {
  const NearbyPlacesDetailBottomSheet({
    super.key,
    required this.place,
    required this.distance,
    required this.onReminder,
  });

  final PlaceEntity place;
  final double distance;
  final VoidCallback onReminder;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          place.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          place.address,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.location_on, size: 20, color: Colors.blue[600]),
            const SizedBox(width: 8),
            Text('${Helpers.formatDistance(distance)} away'),
            const Spacer(),
            if (place.rating > 0) ...[
              Icon(Icons.star, size: 20, color: Colors.amber[600]),
              const SizedBox(width: 4),
              Text('${place.rating}/5'),
            ],
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => makeACall(context),
                icon: const Icon(Icons.phone),
                label: const Text('Call'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onReminder,
                icon: const Icon(Icons.notifications_active),
                label: const Text('Set Alarm'),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Coming Soon"),
                    ),
                  );
                },
                icon: const Icon(Icons.directions),
                label: const Text('Directions'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void makeACall(BuildContext context){
    if(place.phoneNumber == null){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No phone number"),
        ),
      );
      return;
    }
    launchPhoneDialer(place.phoneNumber!);
  }
}
