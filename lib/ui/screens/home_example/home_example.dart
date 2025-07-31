import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/blocs/location/location_bloc.dart';
import '../../../core/model/location_entity.dart';
import '../../../core/model/marker_entity.dart';
import '../../../utils/ui_helpers.dart';
import '../../bottom_sheets/create_marker_bottom_sheet.dart';
import '../../widgets/loader/circular_indicator.dart';
import 'bloc/home_example_bloc.dart';

// Usage in HomeScreen
class HomeExample extends StatefulWidget {
  const HomeExample({super.key});

  @override
  State<HomeExample> createState() => _HomeExampleState();
}

class _HomeExampleState extends State<HomeExample> {
  // in the below line, we are initializing our controller for google maps.
  final Completer<GoogleMapController> _controller = Completer();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<HomeExampleBloc>().add(HomeExampleStarted()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<HomeExampleBloc>().add(RefreshLocation());
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeExampleBloc, HomeExampleState>(
        builder: (context, state) {
          switch (state) {
            case HomeLoading():
              return CircularIndicator();

            case HomeLoaded():
              return Center(
                child: Column(
                  children: [
                    if (state.isRefreshing) LinearProgressIndicator(),
                    if (state.currentUser != null)
                      Text(state.currentUser!.address.toString())
                    else
                      Text("data"),
                    if (state.userLocation != null)
                      LocationWidget(location: state.userLocation!)
                    else
                      Text('No location available'),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeExampleBloc>().add(
                          GetExampleCoordinateAddress(
                            state.userLocation!.latitude,
                            state.userLocation!.longitude,
                          ),
                        );
                      },
                      child: Text('Get Address'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeExampleBloc>().add(
                          HomeExampleStarted(),
                        );
                      },
                      child: Text('User Details'),
                    ),

                    // CORRECTED BlocBuilder for LocationBloc
                    BlocBuilder<LocationBloc, LocationState>(
                      builder: (context, locationState) {
                        if (locationState is LocationAddressLoaded) {
                          return Text(
                            "Address: ${locationState.address.address ?? 'N/A'}",
                          );
                        } else if (locationState is LocationLoading) {
                          return Text("Loading address...");
                        } else if (locationState is LocationError) {
                          return Text("Error: ${locationState.message}");
                        }
                        return SizedBox.shrink(); // Return empty widget for other states
                      },
                    ),

                    Expanded(
                      child: GoogleMap(
                        // in the below line, setting camera position
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            state.userLocation?.latitude ?? 0.0,
                            state.userLocation?.longitude ?? 0.0,
                          ),
                          zoom: 10.4746,
                        ),
                        // in the below line, specifying map type.
                        mapType: MapType.normal,
                        // in the below line, setting user location enabled.
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        // in the below line, setting compass enabled.
                        compassEnabled: true,
                        // in the below line, show building enabled.
                        buildingsEnabled: true,
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: true,
                        indoorViewEnabled: true,
                        mapToolbarEnabled: false,
                        // in the below line, specifying controller on map complete.
                        onMapCreated: _controller.complete,
                        onLongPress:
                            (location) async =>
                                await UIHelpers.showCustomBottomSheet<
                                  MarkerEntity
                                >(
                                  context,
                                  child: CreateMarkerBottomSheet(
                                    latitude: location.latitude,
                                    longitude: location.longitude,
                                  ),
                                ),
                        // markers: {
                        //   ...state.locationTags
                        //       .map(
                        //         (e) => Marker(
                        //           markerId: MarkerId(e.markerId!),
                        //           position: LatLng(e.latitude!, e.longitude!),
                        //           infoWindow: InfoWindow(
                        //             title: e.title,
                        //             snippet: e.description,
                        //           ),
                        //           onTap: () {
                        //             print("Marker Id: ${e.markerId}");
                        //           },
                        //         ),
                        //       )
                        //       .toSet(),
                        // },
                      ),
                    ),
                  ],
                ),
              );

            case HomeError():
              return Column(
                children: [
                  Text('Error: ${state.message}'),
                  if (state.lastKnownLocation != null)
                    LocationWidget(location: state.lastKnownLocation!),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeExampleBloc>().add(FetchUserLocation());
                    },
                    child: Text('Retry'),
                  ),
                ],
              );

            default:
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<HomeExampleBloc>().add(FetchUserLocation());
                  },
                  child: Text('Get Location'),
                ),
              );
          }
        },
      ),
    );
  }
}

class LocationWidget extends StatelessWidget {
  final LocationEntity location;

  const LocationWidget({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Latitude: ${location.latitude.toStringAsFixed(6)}'),
            Text('Longitude: ${location.longitude.toStringAsFixed(6)}'),
            Text('Accuracy: ${location.accuracy?.toStringAsFixed(2)}m'),
            // Text('Address: ${location.address}'),
            Text('Updated: ${location.timestamp.toString()}'),
          ],
        ),
      ),
    );
  }
}
