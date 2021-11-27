import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final void Function(int index) onChanged;
  final int value;
  final IconData filledStar;
  final IconData unfilledStar;
  const StarRating({
    Key? key,
    required this.onChanged,
    this.value = 0,
    required this.filledStar,
    required this.unfilledStar,
  }):super(key: key);
  @override
  Widget build(BuildContext context) {
    final color = Colors.amber;
    const size = 36.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () {
            onChanged(value == index + 1 ? index : index + 1);
          },
          color: index < value ? color : null,
          iconSize: size,
          icon: Icon(
            index < value
                ? filledStar
                : unfilledStar
          ),
          padding: EdgeInsets.zero,
          tooltip: "${index + 1} of 5",
        );
      }),
    );
  }
}
