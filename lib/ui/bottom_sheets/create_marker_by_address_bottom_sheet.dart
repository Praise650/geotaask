import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../core/blocs/geofence/geofence_bloc.dart';
import '../../core/blocs/location/location_bloc.dart';
import '../../core/enums/marker_status.dart';
import '../../core/model/marker_entity.dart';
import '../../core/model/location_entity.dart';
import '../../utils/ui_helpers.dart';
import '../layout/base_bottom_sheet.dart';
import '../widgets/inputs/custom_date_picker.dart';
import '../widgets/inputs/input_field.dart';
import '../../utils/helpers.dart';

// Define the LocationEntity class
class LocationEntityEx {
  final String address;
  final String? name; // Optional, assuming name might be used in ListTile
  final String? country; // Optional, assuming country might be used in ListTile

  LocationEntityEx({required this.address, this.name, this.country});
}

class CreateMarkerByAddressBottomSheet extends StatefulWidget {
  const CreateMarkerByAddressBottomSheet({super.key});

  @override
  State<CreateMarkerByAddressBottomSheet> createState() =>
      _CreateLocationTagByTagBottomSheetState();
}

class _CreateLocationTagByTagBottomSheetState
    extends State<CreateMarkerByAddressBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final addressCtr = TextEditingController();
  final titleCtr = TextEditingController();
  final radiusCtr = TextEditingController();
  final descCtr = TextEditingController();
  DateTime? startDateCtr;
  DateTime? endDateCtr;
  LocationEntity? currentLocation; // Remove `late`, initialize as null

  bool? get validateForm => formKey.currentState?.validate();

  void getCoordinate(String address) {
    context.read<LocationBloc>().add(GetAddressCoordinate(address: address));
    // Update the input field with selected address
    addressCtr.text = address;
  }

  void saveTag(MarkerEntity tagEntity) {
    if (validateForm == true) {
      context.read<GeofenceBloc>().add(AddMarker(tagEntity: tagEntity));
      Navigator.pop(context);
    }
  }

  // Sample data
  final List<LocationEntityEx> list = [
    LocationEntityEx(address: "abuja", name: "Abuja", country: "Nigeria"),
    LocationEntityEx(address: "lagos", name: "Lagos", country: "Nigeria"),
    LocationEntityEx(address: "oyo", name: "Oyo", country: "Nigeria"),
    LocationEntityEx(address: "ibadan", name: "Ibadan", country: "Nigeria"),
  ];

  @override
  void dispose() {
    titleCtr.dispose();
    descCtr.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        // Update currentLocation when AddressCoordinateLoaded is emitted
        if (state is AddressCoordinateLoaded) {
          currentLocation = state.address;
        }

        return BaseBottomSheet(
          showHandleBar: true,
          hasScrollableChild: true,
          multiplier: .55,
          builder:
              (context, size) => SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Create location based tags",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          InputField(
                            controller: titleCtr,
                            labelText: "Title",
                            hintText: "I.e Buy burger at cosco...",
                          ),
                          InputField(
                            controller: radiusCtr,
                            labelText: "Radius(m)",
                            hintText: "I.e 50m",
                            inputType: TextInputType.number,
                          ),
                          TypeAheadField<LocationEntityEx>(
                            controller: addressCtr,
                            suggestionsCallback: (search) {
                              if (search.isEmpty) {
                                return list; // Return all items if search is empty
                              }
                              return list
                                  .where(
                                    (e) => e.address.toLowerCase().contains(
                                      search.toLowerCase(),
                                    ),
                                  )
                                  .toList();
                            },
                            builder: (context, controller, focusNode) {
                              return InputField(
                                controller: controller,
                                focusNode: focusNode,
                                autofocus: false,
                                labelText: "Input Address",
                                hintText: "29 Alaba layout, Stateline",
                                isLoading: state is LocationLoading,
                              );
                            },
                            itemBuilder: (context, city) {
                              return ListTile(
                                title: Text(
                                  city.name ?? city.address,
                                  style: TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(city.country ?? 'Unknown'),
                              );
                            },
                            onSelected: (val) => getCoordinate(val.address),
                            loadingBuilder:
                                (context) => const Text('Loading...'),
                            errorBuilder:
                                (context, error) => const Text('Error!'),
                            emptyBuilder:
                                (context) => const Text('No items found!'),
                          ),
                          if (state is AddressCoordinateLoaded)
                            LocationDetailsWidget(state.address),
                          InputField(
                            controller: descCtr,
                            hintText: "Write a description",
                            labelText: "Description",
                            maxLines: 2,
                          ),
                          CustomDateTimePicker(
                            initialDateTime: DateTime.now(),
                            onChanged: (newDateTime) {
                              startDateCtr = newDateTime;
                              print('DateTime 1 changed: $newDateTime');
                            },
                            hintText: 'Choose a start date and time',
                          ),
                          CustomDateTimePicker(
                            initialDateTime: DateTime.now(),
                            onChanged: (newDateTime) {
                              endDateCtr = newDateTime;
                              print('DateTime 1 changed: $newDateTime');
                            },
                            hintText: 'Choose a start date and time',
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // Validate that currentLocation is not null
                          if (currentLocation == null) {
                            UIHelpers.showSnackBar(
                              context,
                              "Please select a valid address",
                            );
                            return;
                          }

                          if (validateForm == true) {
                            final result = MarkerEntity(
                              longitude: currentLocation!.longitude,
                              latitude: currentLocation!.latitude,
                              title: titleCtr.text,
                              markerId: Helpers.generateId(),
                              description: descCtr.text,
                              radius: double.parse(radiusCtr.text),
                              createdAt: DateTime.now(),
                              status: MarkerStatus.enabled,
                              startsAt: startDateCtr,
                              endsAt: endDateCtr,
                              notified: false,
                            );
                            saveTag(result);
                          }
                        },
                        child: Text("Continue"),
                      ),
                    ],
                  ),
                ),
              ),
        );
      },
    );
  }
}

class LocationDetailsWidget extends StatelessWidget {
  const LocationDetailsWidget(this.location, {super.key});
  final LocationEntity location;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: Colors.grey.shade100,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Address Details",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text('Latitude: ${location.latitude.toStringAsFixed(6)}'),
            Text('Longitude: ${location.longitude.toStringAsFixed(6)}'),
            Text('Accuracy: ${location.accuracy?.toStringAsFixed(2)}m'),
          ],
        ),
      ),
    );
  }
}
