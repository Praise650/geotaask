import 'package:flutter/cupertino.dart';

typedef Builder<T> = Widget Function(
  int index,
  T? listItem,
  bool isSelected,
  bool falseItem,
  // int selectedIndex,
  // bool firstItem,
  // bool lastItem,
);
typedef OnSelected<T> = void Function(T selectedItem);

class ScrollableHorizontalList<T> extends StatefulWidget {
  const ScrollableHorizontalList(
      {super.key,
      required this.list,
      required this.builder,
      required this.onSelected,
        this.falseItem = false,
      this.scrollDirection, this.mainAxisSpacing});

  final List<T> list;
  final Builder<T> builder;
  final OnSelected<T> onSelected;
  final Axis? scrollDirection;
  final double? mainAxisSpacing;
  final bool falseItem;
  @override
  State<ScrollableHorizontalList<T>> createState() => _VerticalListState<T>();
}

class _VerticalListState<T> extends State<ScrollableHorizontalList<T>> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          children: [
            ...List.generate(
              widget.list.length,
                  (index) => Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() => selectedIndex = index);
                      widget.onSelected(widget.list[index]);
                    },
                    child: widget.builder(
                        index + (widget.falseItem ? 1 : 0),
                      widget.list[index],
                      selectedIndex == index,
                      widget.falseItem
                      // selectedIndex??0,
                      // selectedIndex == 0,
                      // selectedIndex == widget.list.length - 1,
                    ),
                  ),
                  if (index != widget.list.length - 1)
                    SizedBox(width: widget.mainAxisSpacing ?? 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class HorizontalList<T> extends StatefulWidget {
  const HorizontalList(
      {super.key,
      required this.list,
      required this.builder,
      required this.onSelected,
        this.falseItem = false,
      this.scrollDirection, this.mainAxisSpacing});

  final List<T> list;
  final Builder<T> builder;
  final OnSelected<T> onSelected;
  final Axis? scrollDirection;
  final double? mainAxisSpacing;
  final bool falseItem;
  @override
  State<HorizontalList<T>> createState() => _HorizontalListState<T>();
}

class _HorizontalListState<T> extends State<HorizontalList<T>> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...List.generate(
            widget.list.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() => selectedIndex = index);
                    widget.onSelected(widget.list[index]);
                  },
                  child: widget.builder(
                      index + (widget.falseItem ? 1 : 0),
                    widget.list[index],
                    selectedIndex == index,
                    widget.falseItem
                    // selectedIndex??0,
                    // selectedIndex == 0,
                    // selectedIndex == widget.list.length - 1,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
