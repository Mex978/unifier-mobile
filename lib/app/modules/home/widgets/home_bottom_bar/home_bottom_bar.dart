import 'package:flutter/material.dart';

class HomeBottomBarItem {
  final IconData? icon;
  final String? label;

  HomeBottomBarItem({this.icon, this.label});
}

class HomeBottomBar extends StatefulWidget {
  final ValueChanged<int>? onTap;
  final int? currentIndex;
  final List<HomeBottomBarItem>? items;

  const HomeBottomBar({Key? key, this.currentIndex, this.onTap, this.items}) : super(key: key);

  @override
  _HomeBottomBarState createState() => _HomeBottomBarState();
}

class _HomeBottomBarState extends State<HomeBottomBar> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: 56,
      child: Row(
          children: widget.items
                  ?.asMap()
                  .map<int, Widget>((index, item) => MapEntry(
                        index,
                        Expanded(
                          child: buildItem(index, item),
                        ),
                      ))
                  .values
                  .toList() ??
              []

          // <Widget>[
          //   buildItem(),
          //   Container(
          //     width: 66,
          //     color: Colors.green,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         Icon(Icons.notifications_active, color: Colors.white),
          //         Text("NOTIF", style: TextStyle(color: Colors.white))
          //       ],
          //     ),
          //   ),
          //   Expanded(
          //     child: Container(
          //       alignment: Alignment.center,
          //       color: Colors.red,
          //       child: Text("BUY NOW", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          //     ),
          //   ),
          // ],
          ),
    );
  }

  Widget buildItem(int index, HomeBottomBarItem item) {
    final inactiveColor = Colors.grey;
    final activeColor = Theme.of(context).accentColor;

    if (item.icon != null && item.label != null) {
      final isSelected = index == widget.currentIndex;

      bool? isMiddleItem;

      final itemsLength = widget.items?.length ?? 0;
      final hasMiddle = itemsLength % 2 != 0;

      if (hasMiddle) {
        final middleIndex = itemsLength ~/ 2;
        isMiddleItem = middleIndex == index;
      }

      return Container(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 56,
            height: 56,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  widget.onTap?.call(index);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      item.icon,
                      size: 24,
                      color: isSelected ? activeColor : inactiveColor,
                    ),
                    SizedBox(height: 1),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                      child: Text(
                        item.label!,
                        style: TextStyle(
                          color: isSelected ? activeColor : inactiveColor,
                          fontSize: isSelected ? 14 : 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
