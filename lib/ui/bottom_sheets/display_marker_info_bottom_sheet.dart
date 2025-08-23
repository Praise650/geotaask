import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/blocs/geofence/geofence_bloc.dart';
import '../../core/blocs/location/location_bloc.dart';
import '../widgets/loader/circular_indicator.dart';
import '../../core/model/marker_entity.dart';
import '../layout/base_bottom_sheet.dart';
import '../../utils/helpers.dart';

class DisplayMarkerInfoBottomSheet extends StatefulWidget {
  const DisplayMarkerInfoBottomSheet({super.key, required this.markerId});

  final String markerId;

  @override
  State<DisplayMarkerInfoBottomSheet> createState() =>
      _DisplayMarkerInfoBottomSheetState();
}

class _DisplayMarkerInfoBottomSheetState
    extends State<DisplayMarkerInfoBottomSheet> {
  MarkerEntity? marker;
  String? currentAddress;

  void fetchMarkerDetails() async {
    context.read<GeofenceBloc>().add(FetchMarker(widget.markerId));
  }

  void markComplete() {
    marker?.markComplete();
    context.read<GeofenceBloc>().add(
      MarkerActivityComplete(marker!)
    );
    Navigator.pop(context);
  }

  void deleteMarker() {
    context.read<GeofenceBloc>().add(RemoveMarker(widget.markerId));
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    fetchMarkerDetails();
    // context.read<LocationBloc>().add(
    //   GetCoordinateAddress(
    //     marker!.latitude!,
    //     marker!.longitude!,
    // ),
    // );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      showHandleBar: true,
      hasScrollableChild: true,
      multiplier: .45,
      builder:
          (context, size) => BlocListener<GeofenceBloc, GeofenceState>(
            listener: (context, state) {
              if (state is FetchGeofenceMarker) {
                setState(() => marker = state.marker);
                print("Current Address: ${marker?.toJson()}");
              }
            },
            child: BlocBuilder<GeofenceBloc, GeofenceState>(
              builder: (context, state) {
                if (state is GeofenceLoading) {
                  return CircularIndicator();
                }

                if (state is GeofenceError) {
                  return Text(state.message);
                }

                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 38,
                                color: Colors.red,
                              ),
                              SizedBox(width: 10),
                              BlocListener<LocationBloc, LocationState>(
                                listener: (context, state) {
                                  if (state is LocationAddressLoaded) {
                                    setState(() {
                                      currentAddress = state.address.address;
                                    });
                                    print(
                                      "Current LatLng Address: $currentAddress",
                                    );
                                  }
                                },
                                child: BlocBuilder<LocationBloc, LocationState>(
                                  builder:
                                      (context, state) => Text(
                                        currentAddress ??
                                            "Latitude: ${marker?.latitude?.toStringAsFixed(6)}, Longitude: ${marker?.longitude?.toStringAsFixed(6)}",
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            marker!.title ?? "No Title",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            marker!.description ?? "No description provided",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text("Latitude: ${marker!.latitude}"),
                          Text("Longitude: ${marker!.longitude}"),
                          Text("Radius: ${marker!.radius} meters"),
                          Text("Created At: ${marker!.createdAt!.toIso8601String()}"),
                          Text("Status: ${marker!.status.name}"),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: deleteMarker,
                                child: Text("Delete Marker"),
                              ),
                              TextButton(
                                onPressed: markComplete,
                                child: Text("Mark as Complete"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
    );
  }
}
