import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  final String heading, details, firstActionLabel, secondActionLabel;
  final Function firstAction, secondAction;

  InfoDialog({
    this.heading,
    this.details,
    this.firstActionLabel,
    this.secondActionLabel,
    this.firstAction,
    this.secondAction,
  });

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.longestSide;
    final _width = MediaQuery.of(context).size.shortestSide;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        height: _height * 0.3,
        width: _width * 0.6,
        child: Column(
          children: <Widget>[
            Expanded(
              child: SizedBox(),
            ),
            SizedBox(
              width: _width * 0.6,
              child: Center(
                child: Text(
                  heading,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: _width * 0.6,
              child: Center(
                child: Text(
                  details,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            Divider(height: 0),
            InkWell(
              onTap: firstAction,
              child: SizedBox(
                height: _height * 0.05,
                width: _width * 0.6,
                child: Center(
                  child: Text(
                    firstActionLabel,
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Divider(height: 0),
            InkWell(
              onTap: secondAction,
              child: SizedBox(
                height: _height * 0.05,
                width: _width * 0.6,
                child: Center(child: Text(secondActionLabel)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
