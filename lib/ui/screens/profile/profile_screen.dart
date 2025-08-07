import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/bottom_nav_layout_bloc.dart';

class ProfileItem {
  final String? icon;
  final String? title;
  final String? subtitle;

  ProfileItem({this.subtitle, this.icon, this.title});
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<ProfileItem> actions = [
    ProfileItem(
      title: "Enable Location",
      subtitle: "Enable location to access map functionalities",
    ),
    ProfileItem(title: "Delete All Tag", subtitle: "Delete all created tags"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            context.read<BottomNavLayoutCubit>().goHome();
          },
        ),
        title: Text("Profile"),
        elevation: 5,
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = actions[index];
              return ItemTileWidget(item: item);
            },
            itemCount: actions.length,
          ),
        ],
      ),
    );
  }
}

class ItemTileWidget extends StatelessWidget {
  const ItemTileWidget({super.key, this.trailing, required this.item});

  final Widget? trailing;
  final ProfileItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title ?? "Nil", style: TextStyle(fontSize: 18)),
      subtitle: Text(item.subtitle ?? "Nil", style: TextStyle(fontSize: 12)),
      trailing: trailing ?? Icon(Icons.keyboard_arrow_right_rounded, size: 12),
    );
  }
}
