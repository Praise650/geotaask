import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/model/places/place_entity.dart';
import '../../../core/blocs/places/places_bloc.dart';
import '../../../core/model/location_entity.dart';
import '../customs/custom_error_widget.dart';
import '../loader/circular_indicator.dart';
import '../../../utils/helpers.dart';
import '../customs/empty_state.dart';

typedef ShowPlaceDetail = void Function(PlaceEntity, double);

class NearbyPlaces extends StatelessWidget {
  const NearbyPlaces({
    super.key,
    required this.retry,
    this.currentPosition,
    required this.showPlaceDetails,
  });

  final VoidCallback retry;
  final LocationEntity? currentPosition;
  final ShowPlaceDetail showPlaceDetails;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlacesBloc, PlacesState>(
      builder: (context, state) {
        switch (state) {
          case PlacesLoading():
            return const CircularIndicator();
          case PlacesError():
            return CustomErrorWidget(message: state.message, fn: retry);
          case PlacesLoaded():
            return state.places.isEmpty
                ? const EmptyStateWidget()
                : ListView.builder(
                  itemCount: state.places.length,
                  itemBuilder: (context, index) {
                    final place = state.places[index];
                    final distance = place.distanceFromUser(
                      currentPosition!.latitude,
                      currentPosition!.longitude,
                    );

                    return Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: .3),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[100],
                          child: Icon(Icons.place, color: Colors.blue[700]),
                        ),
                        title: Text(
                          place.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(place.address),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  Helpers.formatDistance(distance),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                if (place.rating > 0) ...[
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.star,
                                    size: 14,
                                    color: Colors.amber[600],
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    place.rating.toString(),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                place.isOpen
                                    ? Colors.green[100]
                                    : Colors.red[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            place.isOpen ? 'Open' : 'Closed',
                            style: TextStyle(
                              color:
                                  place.isOpen
                                      ? Colors.green[700]
                                      : Colors.red[700],
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        onTap: () => showPlaceDetails(place, distance),
                      ),
                    );
                  },
                );
          default:
            return const Text("No data available");
        }
      },
    );
  }
}
