import 'package:flutter/material.dart';

import '../../app/res/images.dart';
import '../layout/base_bottom_sheet.dart';
import '../layout/grid_view_widget.dart';

class MapMenuBottomSheet extends StatelessWidget {
  const MapMenuBottomSheet({super.key});

  List get mapTypes => [
    {"type": "Normal", "img": Images.normal},
    {"type": "Terrain", "img": Images.terrain},
    {"type": "Satellite", "img": Images.normal},
    {'type': 'Hybrid', "img": Images.hybrid},
  ];

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      showHandleBar: true,
      hasScrollableChild: true,
      multiplier: .45,
      builder:
          (context, size) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Map Type",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              GridViewWidget(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: 2,
                crossAxisSpacing: 15,
                childAspectRatio: 16 / 15,
                list: mapTypes,
                onSelected: (onSelected) {},
                builder: (index, item, isSelected) {
                  final item = mapTypes[index];
                  return Column(
                    children: [
                      Container(
                        height: 50,
                        width: 60,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(10),
                          border: isSelected ? Border.all(width: 2) : null,
                        ),
                        child: ClipRect(
                          clipBehavior: Clip.hardEdge,
                          child: Image.asset(item["img"], fit: BoxFit.fill),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        item["type"]!,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
    );
  }
}
