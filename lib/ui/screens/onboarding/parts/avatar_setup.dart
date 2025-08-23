import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/loader/circular_indicator.dart';
import '../../../widgets/customs/header_widget.dart';
import '../../../layout/grid_view_widget.dart';
import '../../../../../app/res/svgs.dart';
import '../cubit/onboarding_cubit.dart';

class AvatarSetup extends StatefulWidget {
  const AvatarSetup({super.key});

  @override
  State<AvatarSetup> createState() => _AvatarSetupState();
}

class _AvatarSetupState extends State<AvatarSetup> {
  Future<void> saveUserDetail() async {
    final cubit = context.read<OnboardingCubit>();
    try {
      final result = await cubit.saveUserDetail();
      await onValue(result);
    } catch (error) {
      await onError(error);
    }
  }

  Future<void> onValue(bool value) async {
    if (value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile created successfully")),
      );
      await context.read<OnboardingCubit>().nextStep();
    }
  }

  Future<void> onError(Object error) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // content: Text(error.toString()),
        content: Text("Failed to create profile: $error"),
        showCloseIcon: true,
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<OnboardingCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderWidget(
          title: "Set Avatar",
          subtitle:
              'Select an avatar for your profile picture '
              'to personalize your account.',
          subTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 39),
        GridViewWidget(
          list: [
            Svgs.avatar1,
            Svgs.avatar2,
            Svgs.avatar3,
            Svgs.avatar4,
            Svgs.avatar5,
            Svgs.avatar6,
            Svgs.avatar7,
            Svgs.avatar8,
            Svgs.avatar9,
          ],
          shrinkWrap: true,
          crossAxisCount: 3,
          builder:
              (int index, listItem, bool isSelected) => Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.grey,
                  ),
                  shape: BoxShape.circle,
                ),
                height: 65,
                width: 65,
                child: Image.asset(listItem!),
              ),
          onSelected: cubit.saveUserAvatar,
        ),
        Spacer(),
        if (cubit.state.isImgSelected == true)
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: saveUserDetail,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF667eea),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child:
                  cubit.state.isLoading
                      ? CircularIndicator()
                      : const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),
        const SizedBox(height: 17),
      ],
    );
  }
}
