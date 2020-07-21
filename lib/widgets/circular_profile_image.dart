import 'package:flutter/material.dart';

class CircularProfileImage extends StatelessWidget {
  final String image;
  final double radius;
  final bool showLittleAddIcon;
  CircularProfileImage({
    @required this.image,
    this.radius = 25,
    this.showLittleAddIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: image != null
              ? image.isNotEmpty
                  ? NetworkImage(image)
                  : AssetImage("assets/images/user_icon.png")
              : AssetImage("assets/images/user_icon.png"),
          radius: radius,
        ),
        if (showLittleAddIcon)
          Positioned(
            right: 0,
            bottom: 0,
            child: CircleAvatar(
              radius: radius / 4 + 1,
              backgroundColor: Colors.white,
            ),
          ),
        if (showLittleAddIcon)
          Positioned(
            right: 1,
            bottom: 1,
            child: Icon(
              Icons.add_circle,
              color: Colors.blue,
              size: radius / 2,
            ),
          ),
      ],
    );
  }
}
