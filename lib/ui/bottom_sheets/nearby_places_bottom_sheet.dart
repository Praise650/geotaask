import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/nearby_places/nearby_place_detail.dart';
import '../widgets/nearby_places/nearby_places.dart';
import '../../core/model/places/place_entity.dart';
import '../../core/blocs/places/places_bloc.dart';
import '../../core/model/location_entity.dart';
import '../../core/model/marker_entity.dart';
import '../layout/base_bottom_sheet.dart';
import 'create_marker_bottom_sheet.dart';
import '../../core/routes/router.dart';
import '../../utils/ui_helpers.dart';

class NearbyPlacesBottomSheet extends StatefulWidget {
  const NearbyPlacesBottomSheet({
    super.key,
    this.type,
    this.keyword,
    this.currentPosition,
  });

  final String? type, keyword;
  final LocationEntity? currentPosition;

  @override
  State<NearbyPlacesBottomSheet> createState() =>
      _NearbyPlacesBottomSheetState();
}

class _NearbyPlacesBottomSheetState extends State<NearbyPlacesBottomSheet> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  // Selected place data
  PlaceEntity? selectedPlace;
  double selectedDistance = 0.0;

  @override
  void initState() {
    super.initState();
    _searchPlaces(keyword: widget.keyword);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _searchPlaces({String? keyword, String? type}) async {
    if (widget.currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location not available'),
          duration: Durations.extralong4,
        ),
      );
      return;
    }

    context.read<PlacesBloc>().add(
      FetchNearbyPlaces(
        type: type,
        keyword: keyword,
        currentPosition: widget.currentPosition!,
      ),
    );
  }

  void _showPlaceDetails(place, double distance) {
    setState(() {
      selectedPlace = place;
      selectedDistance = distance;
    });

    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onReminder() async {
    await UIHelpers.showCustomBottomSheet<MarkerEntity>(
      context,
      child: CreateMarkerBottomSheet(
        longitude: selectedPlace!.longitude,
        latitude: selectedPlace!.latitude,
      ),
    );
  }

  void _goBackToList() {
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentIndex < 1) {
          router.pop();
        } else {
          _goBackToList();
        }

        return false;
      },
      child: BaseBottomSheet(
        showHandleBar: true,
        centerTitle: true,
        hasScrollableChild: true,
        multiplier: .65,
        title: "Places Nearby",
        showCloseButton: true,
        leading: currentIndex < 1
          ? null
          : BackButton(
              style: ButtonStyle(),
              onPressed: _goBackToList
          ),
        builder: (context, size) {
          return PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            children: [
              _buildPlacesList(),
              _buildPlaceDetails(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlacesList() {
    return NearbyPlaces(
      retry: _searchPlaces,
      showPlaceDetails: _showPlaceDetails,
      currentPosition: widget.currentPosition,
    );
  }

  Widget _buildPlaceDetails() {
    if (selectedPlace == null) {
      return const Center(
        child: Text("No place selected")
      );
    }

    return NearbyPlacesDetailBottomSheet(
      place: selectedPlace!,
      distance: selectedDistance,
      onReminder: _onReminder,
    );
  }
}
