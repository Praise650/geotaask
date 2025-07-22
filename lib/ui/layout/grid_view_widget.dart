import 'package:flutter/material.dart';

typedef Builders<T> = Widget Function(int index, T? listItem, bool isSelected);
typedef OnSelected<T> = void Function(T selectedItem);

class GridViewWidget<T> extends StatefulWidget {
  const GridViewWidget({
    super.key,
    required this.builder,
    required this.onSelected,
    this.shrinkWrap = true,
    this.falseItem = false,
    this.list,
    this.addWidget,
    this.crossAxisCount,
    this.scrollDirection,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.childAspectRatio,
    this.physics,
  });

  final List<T>? list;
  final bool falseItem;
  final bool shrinkWrap;
  final Widget? addWidget;
  final Builders<T> builder;
  final int? crossAxisCount;
  final Axis? scrollDirection;
  final double? mainAxisSpacing, crossAxisSpacing, childAspectRatio;
  final OnSelected<T> onSelected;
  final ScrollPhysics? physics;

  @override
  State<GridViewWidget<T>> createState() => _GridViewWidgetState<T>();
}

class _GridViewWidgetState<T> extends State<GridViewWidget<T>> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    // Check if the list is null or empty
    final itemList = widget.list ?? [];

    return GridView.count(
      crossAxisCount: widget.crossAxisCount ?? 2,
      shrinkWrap: widget.shrinkWrap,
      scrollDirection: widget.scrollDirection ?? Axis.vertical,
      physics: widget.physics,
      crossAxisSpacing: widget.crossAxisSpacing ?? 15,
      mainAxisSpacing: widget.mainAxisSpacing ?? 15,
      childAspectRatio: widget.childAspectRatio??1.0,
      children: List.generate(
        itemList.length + (widget.falseItem ? 1 : 0),
            (index) {
          // Place the addWidget at the first position
          if (widget.falseItem && index == 0) {
            return widget.addWidget ?? const SizedBox.shrink();
          }

          // Calculate the correct item index (offset by 1 if addWidget is shown first)
          final itemIndex = widget.falseItem ? index - 1 : index;

          return GestureDetector(
            onTap: () {
              setState(() => selectedIndex = itemIndex);
              widget.onSelected(itemList[itemIndex]);
            },
            child: widget.builder(
              itemIndex,
              itemList[itemIndex],
              selectedIndex == itemIndex,
            ),
          );
        },
      ),
    );
  }
}
