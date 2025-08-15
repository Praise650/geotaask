import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/customs/header_widget.dart';
import '../../../widgets/inputs/input_field.dart';
import '../cubit/onboarding_cubit.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({super.key});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final bioController = TextEditingController();
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    // Listen for text changes in the last TextFormField
    bioController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    // Cancel any existing timer
    _typingTimer?.cancel();
    // Start a new timer to detect typing pause
    _typingTimer = Timer(Duration(seconds: 1), () {
      if (_focusNode3.hasFocus) {
        // Unfocus to dismiss keyboard after 1 second of no typing
        FocusScope.of(context).unfocus();
      }
    });
  }

  Future<void> _saveAndContinue() async {
    if (_formKey.currentState!.validate()) {
      final cubit = context.read<OnboardingCubit>();
      cubit.saveUserName(
        userName: nameController.text,
        address: addressController.text,
        bio: bioController.text,
      );
      await cubit.nextStep();
    }
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    nameController.dispose();
    addressController.dispose();
    bioController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderWidget(
          title: "Make It Uniquely Yours",
        subtitle: "Your profile is your space to shine. Add a profile picture "
            "and a short bio to give GeoTaask a personal touch, so it feels like "
            "your tool for navigating your world with GeoTaask",
          subTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),

        Form(
          key: _formKey,
          child: Column(
            children: [
              InputField(
                inputAction: TextInputAction.next,
                inputType: TextInputType.text,
                controller: nameController,
                hintText: "Enter Username",
                labelText: "Username",
                focusNode: _focusNode1,
                isOnboarding: true,
                autofocus: true,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_focusNode2);
                },
              ),
              InputField(
                inputType: TextInputType.streetAddress,
                inputAction: TextInputAction.next,
                controller: addressController,
                hintText: "Enter Address",
                labelText: "Address",
                focusNode: _focusNode2,
                isOnboarding: true,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_focusNode3);
                },
              ),
              InputField(
                inputAction: TextInputAction.done,
                inputType: TextInputType.text,
                controller: bioController,
                focusNode: _focusNode3,
                isOnboarding: true,
                hintText: "Bio...",
                labelText: 'Bio',
                maxLines: 4,
                onFieldSubmitted: (_) {
                  // Optional: Handle "Done" action
                  FocusScope.of(context).unfocus();
                  _formKey.currentState?.validate();
                },
              ),
            ],
          ),
        ),
        Spacer(),
        // Start Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _saveAndContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF667eea),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Save and Continue',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
