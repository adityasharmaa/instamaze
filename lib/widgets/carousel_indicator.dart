import 'package:flutter/material.dart';

class CarouselIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Color selectedColor;
  final Color unselectedColor;

  CarouselIndicator({
    @required this.count,
    @required this.currentIndex,
    this.selectedColor = Colors.blue,
    this.unselectedColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        count,
        (index) => Row(
          children: <Widget>[
            CircleAvatar(
              radius: index == currentIndex ? 3 : 2,
              backgroundColor:
                  index == currentIndex ? selectedColor : unselectedColor,
            ),
            if (index < count - 1) SizedBox(width: 5, height: 1),
          ],
        ),
      ),
    );
  }
}
