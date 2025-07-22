import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/blocs/geofence/geofence_bloc.dart';
import '../../core/blocs/location/location_bloc.dart';
import '../../core/enums/marker_status.dart';
import '../../core/model/marker_entity.dart';
import '../../utils/helpers.dart';
import '../layout/base_bottom_sheet.dart';
import '../widgets/inputs/input_field.dart';
import '../widgets/loader/circular_indicator.dart';

class CreateMarkerBottomSheet extends StatefulWidget {
  const CreateMarkerBottomSheet({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  final double latitude, longitude;

  @override
  State<CreateMarkerBottomSheet> createState() =>
      _CreateMarkerBottomSheetState();
}

class _CreateMarkerBottomSheetState extends State<CreateMarkerBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final titleCtr = TextEditingController();
  final radiusCtr = TextEditingController();
  final descCtr = TextEditingController();
  String? currentAddress;

  bool? get validateForm => formKey.currentState?.validate();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<LocationBloc>().add(
        // Use LocationBloc directly
        GetCoordinateAddress(widget.latitude, widget.longitude),
      ),
    );
  }

  void saveTag() {
    final result = MarkerEntity(
      longitude: widget.longitude,
      latitude: widget.latitude,
      title: titleCtr.text,
      markerId: Helpers.generateId(),
      description: descCtr.text,
      radius: double.parse(radiusCtr.text),
      createdAt: DateTime.now().toIso8601String(),
      isActive: true,
      status: MarkerStatus.active,
    );
    if (validateForm == true) {
      log("BottomSheet Response: ${result.toJson()}", name: "MapService.post");
      // Dispatch event to bloc
      context.read<GeofenceBloc>().add(AddMarker(tagEntity: result));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    titleCtr.dispose();
    descCtr.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeofenceBloc, GeofenceState>(
      builder: (context, state) {
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
                            labelText: "Add Title",
                            hintText: "I.e Buy burger at cosco...",
                          ),
                          InputField(
                            controller: radiusCtr,
                            labelText: "Radius(m)",
                            hintText: "I.e 50m",
                            inputType: TextInputType.number,
                          ),
                          BlocListener<LocationBloc, LocationState>(
                            listener: (context, state) {
                              if (state is LocationAddressLoaded) {
                                setState(
                                  () => currentAddress = state.address.address,
                                );
                                print("Current Address: $currentAddress");
                              }
                            },
                            child: BlocBuilder<LocationBloc, LocationState>(
                              builder: (context, state) {
                                return InputField(
                                  controller: TextEditingController(
                                    text:
                                        currentAddress ??
                                        "Latitude: ${widget.latitude.toStringAsFixed(6)}, Longitude: ${widget.longitude.toStringAsFixed(6)}",
                                  ),
                                  labelText: "Address",
                                  hintText: "29 Alaba layout, Stateline",
                                  isLoading: state is LocationLoading,
                                  readOnly: true,
                                );
                              },
                            ),
                          ),
                          InputField(
                            controller: descCtr,
                            hintText: "Write a description",
                            labelText: "Description",
                            maxLines: 2,
                          ),
                        ],
                      ),
                      state is AddMarkerLoading
                          ? CircularIndicator()
                          : TextButton(
                            onPressed: saveTag,
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
