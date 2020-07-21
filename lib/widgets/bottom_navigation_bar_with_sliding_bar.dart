import 'package:flutter/material.dart';

class BottomNavigationBarWithSlidingBar extends StatefulWidget {
  final List<String> items;
  final Function onTap;
  BottomNavigationBarWithSlidingBar({
    @required this.items,
    @required this.onTap,
  });

  @override
  _BottomNavigationBarWithSlidingBarState createState() =>
      _BottomNavigationBarWithSlidingBarState();
}

class _BottomNavigationBarWithSlidingBarState extends State<BottomNavigationBarWithSlidingBar> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final sliderLength = MediaQuery.of(context).size.width / widget.items.length;
    return Container(
      height: MediaQuery.of(context).size.longestSide * 0.05,
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              ...widget.items
                  .map((title) => InkWell(
                        onTap: () {
                          setState(() {
                            _selectedIndex = widget.items.indexOf(title);
                          });
                          widget.onTap(widget.items.indexOf(title));
                        },
                        child: _BottomNavigationBarWithSlidingBarItem(
                          width: sliderLength,
                          title: title,
                          selected: _selectedIndex == widget.items.indexOf(title),
                        ),
                      ))
                  .toList()
            ],
          ),
          AnimatedPositioned(
            curve: Curves.fastOutSlowIn,
            bottom: 0,
            left: _selectedIndex * sliderLength,
            child: _BottomNavigationBarWithSlidingBarSlider(
              sliderLength,
            ),
            duration: Duration(
              milliseconds: 300,
            ),
          )
        ],
      ),
    );
  }
}

class _BottomNavigationBarWithSlidingBarItem extends StatelessWidget {
  final String title;
  final bool selected;
  final double width;
  _BottomNavigationBarWithSlidingBarItem({
    @required this.title,
    this.selected,
    @required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Center(
        child: FittedBox(
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavigationBarWithSlidingBarSlider extends StatelessWidget {
  final double length;
  _BottomNavigationBarWithSlidingBarSlider(this.length);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.002,
      width: length,
      color: Theme.of(context).accentColor,
    );
  }
}
