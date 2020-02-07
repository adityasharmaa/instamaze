import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final double width;
  final bool isBoundary;
  final String label;
  final Function action;

  SmallButton({
    @required this.width,
    @required this.label,
    @required this.action,
    this.isBoundary = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Container(
        decoration: BoxDecoration(
          border: isBoundary ? Border.all(color: Colors.grey[350]) : null,
          color: isBoundary ? Colors.white : Colors.blue,
          borderRadius: BorderRadius.circular(5),
        ),
        height: MediaQuery.of(context).size.longestSide * 0.035,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isBoundary ? Colors.black : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
