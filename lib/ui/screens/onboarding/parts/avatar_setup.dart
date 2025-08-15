import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/customs/header_widget.dart';
import '../../../layout/grid_view_widget.dart';
import '../../../../../app/res/svgs.dart';
import '../cubit/onboarding_cubit.dart';

class AvatarSetup extends StatelessWidget {
  const AvatarSetup({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<OnboardingCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderWidget(
          title: "Set Avatar",
          subtitle:
              'Select an avatar for your profile picture to personalize your account.',
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
                    color: isSelected ? Colors.blue : Colors.grey,
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
              onPressed: () async {
                await cubit.nextStep();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF667eea),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        const SizedBox(height: 17),
      ],
    );
  }
}
