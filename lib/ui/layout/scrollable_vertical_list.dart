import 'package:flutter/cupertino.dart';

typedef Builder<T> = Widget Function(int index, T? listItem, bool isSelected);
typedef OnSelected<T> = void Function(T selectedItem);

class VerticalList<T> extends StatefulWidget {
  const VerticalList({
    Key? key,
    required this.list,
    required this.builder,
    required this.onSelected,
  }) : super(key: key);

  final List<T> list;
  final Builder<T> builder;
  final OnSelected<T> onSelected;

  @override
  State<VerticalList<T>> createState() => _VerticalListState<T>();
}

class _VerticalListState<T> extends State<VerticalList<T>> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          ...List.generate(
            widget.list.length,
            (index) {
              return GestureDetector(
                onTap: () {
                  setState(() => selectedIndex = index);
                  widget.onSelected(widget.list[index]);
                },
                child: widget.builder(
                  index,
                  widget.list[index],
                  selectedIndex == index,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
