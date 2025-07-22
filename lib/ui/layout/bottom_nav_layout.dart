import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'cubit/bottom_nav_layout_bloc.dart';

class BottomNavLayout extends StatelessWidget {
  const BottomNavLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavLayoutCubit, int>(
      builder: (context, currentIndex) {
        final cubit = context.read<BottomNavLayoutCubit>();
        final items = cubit.list;

        return SafeArea(
          child: Scaffold(
            body: child,
            bottomNavigationBar: BottomNavigationBar(
              selectedFontSize: 10.0,
              unselectedFontSize: 10.0,
              iconSize: 20,
              elevation: 6,
              backgroundColor: Colors.white,
              // onTap: cubit.moveTo,
              onTap: cubit.onTap,
              currentIndex: currentIndex,
              enableFeedback: true,
              showUnselectedLabels: true,
              showSelectedLabels: true,
              type: BottomNavigationBarType.fixed,
              landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black.withOpacity(.30),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
              items: List.generate(
                items.length,
                (index) => BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      SvgPicture.asset(
                        items[index].image,
                        color: Colors.black.withOpacity(.30),
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                  activeIcon: Column(
                    children: [
                      SvgPicture.asset(
                        items[index].image,
                        color: Colors.black,
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                  label: items[index].name,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
