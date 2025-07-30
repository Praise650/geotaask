import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../app/app_setup.locator.dart';
import '../../../core/services/location_service.dart';
import '../../bottom_sheets/create_marker_by_address_bottom_sheet.dart';
import '../../bottom_sheets/create_marker_bottom_sheet.dart';
import '../../bottom_sheets/display_marker_info_bottom_sheet.dart';
import '../../bottom_sheets/map_menu_bottom_sheet.dart';
import '../../../core/model/marker_entity.dart';
import '../../widgets/buttons/custom_fab_widget.dart';
import '../../widgets/loader/circular_indicator.dart';
import '../../../core/routes/router.dart';
import '../../../core/routes/routes.dart';
import '../../../utils/ui_helpers.dart';
import 'bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<HomeBloc>().add(HomeStarted()),
    );
  }

  Future<void> _refreshLocation() async {
    final GoogleMapController controller = await _controller.future;
    final location = await locator<LocationService>().getCurrentPosition();
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(location.latitude, location.longitude),
          zoom: 10.4746,
          tilt: 2.6,
        ),
      ),
    );
  }

  void _createLocationTag(LatLng position) async {
    await UIHelpers.showCustomBottomSheet<MarkerEntity>(
      context,
      child: CreateMarkerBottomSheet(
        latitude: position.latitude,
        longitude: position.longitude,
      ),
    );
  }

  void _createLocationTagByAddress() async {
    await UIHelpers.showCustomBottomSheet<MarkerEntity>(
      context,
      child: CreateMarkerByAddressBottomSheet(),
    );
  }

  Future<void> _displayMarkerInfo(String markerId) async {
    await UIHelpers.showCustomBottomSheet<MarkerEntity>(
      context,
      child: DisplayMarkerInfoBottomSheet(markerId: markerId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          //   if (state is AddMarkerSuccess) {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(content: Text('Marker added successfully')),
          //     );
          //   } else if (state is AddMarkerError) {
          //     ScaffoldMessenger.of(
          //       context,
          //     ).showSnackBar(SnackBar(content: Text(state.message)));
          //   } else if (state is RemoveMarkerSuccess) {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(content: Text('Marker removed successfully')),
          //     );
          //   } else if (state is RemoveMarkerError) {
          //     ScaffoldMessenger.of(
          //       context,
          //     ).showSnackBar(SnackBar(content: Text(state.message)));
          //   }
        },
        builder: (context, state) {
          if (state is HomeLoading) {
            return CircularIndicator();
            // } else if (state is AddMarkerLoading ||
            //     state is RemoveMarkerLoading) {
            //   return const Stack(
            //     children: [
            // Show the last known map state while loading
            // GoogleMap(
            //   initialCameraPosition: CameraPosition(
            //     target: LatLng(7.34, 3.89),
            //     zoom: 10.4746,
            //   ),
            //   myLocationEnabled: true,
            //   myLocationButtonEnabled: false,
            //   compassEnabled: true,
            //   buildingsEnabled: true,
            //   zoomControlsEnabled: false,
            //   zoomGesturesEnabled: true,
            //   indoorViewEnabled: true,
            //   mapToolbarEnabled: false,
            // ),
            // CircularIndicator(),
            // ],
            // );
          } else if (state is HomeLoaded) {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  state.userLocation?.latitude ?? 7.34,
                  state.userLocation?.longitude ?? 3.89,
                ),
                zoom: 10.4746,
              ),
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: true,
              buildingsEnabled: true,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              indoorViewEnabled: true,
              mapToolbarEnabled: false,
              onMapCreated: _controller.complete,
              onLongPress: _createLocationTag,
              circles: {
                ...state.locationTags.map(
                  (e) => Circle(
                    circleId: CircleId(e.markerId!),
                    center: LatLng(e.latitude!, e.longitude!),
                    radius: e.radius!,
                    zIndex: 10,
                    fillColor: Colors.blue.withOpacity(0.3),
                    strokeColor: Colors.blue,
                    strokeWidth: 2,
                    onTap: () => _displayMarkerInfo(e.markerId!),
                  ),
                ),
              },
              markers: {
                ...state.locationTags.map(
                  (e) => Marker(
                    markerId: MarkerId(e.markerId!),
                    position: LatLng(e.latitude!, e.longitude!),
                    zIndexInt: 10,
                    infoWindow: InfoWindow(
                      title: e.title,
                      snippet: e.description,
                    ),
                    onTap: () => _displayMarkerInfo(e.markerId!),
                  ),
                ),
              },
            );
          } else if (state is HomeError) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${state.message}', 
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(HomeStarted());
                  },
                  child: const Text('Retry'),
                ),
              ],
            );
          } else {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<HomeBloc>().add(HomeStarted());
                },
                child: const Text('Get map view'),
              ),
            );
          }
        },
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomFabWidget(
            onTap: _refreshLocation,
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 8),
          CustomFabWidget(
            onTap: () async {
              await UIHelpers.showCustomBottomSheet(
                context,
                child: const MapMenuBottomSheet(),
              );
            },
            child: const Icon(Icons.keyboard_double_arrow_down_outlined),
          ),
          const SizedBox(height: 8),
          CustomFabWidget(
            onTap: _createLocationTagByAddress,
            child: const Icon(Icons.add_location_alt_outlined),
          ),
          const SizedBox(height: 8),
          CustomFabWidget(
            onTap: () => router.push(Paths.HOMEEXAMPLE),
            child: const Icon(Icons.support_agent),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
