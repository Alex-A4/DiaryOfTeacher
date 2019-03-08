import 'package:flutter/material.dart';
import 'dart:math';

class DropdownMenu extends StatefulWidget {
  DropdownMenu(
      {Key key,
      this.buttonsCount,
      this.actions,
      this.icons,
      this.backgroundColor = Colors.black,
      this.iconColor = Colors.white})
      : assert(buttonsCount == icons.length),
        assert(buttonsCount == actions.length),
        super(key: key);

  int buttonsCount;
  Color iconColor;
  Color backgroundColor;
  List<IconData> icons;
  List<VoidCallback> actions;

  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu>
    with SingleTickerProviderStateMixin {
  final iconSize = 45.0;
  final iconSpace = 5.0;

  List<Animation<double>> animations = [];
  Animation<double> rotateAnim;

  AnimationController controller;
  Duration duration = Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: duration);

    final anim =
        CurvedAnimation(parent: controller, curve: Curves.easeOutQuart);

    for (int i = 0; i < widget.buttonsCount; i++)
      animations.add(Tween<double>(begin: 0, end: (iconSize + iconSpace) * i)
          .animate(anim));

    rotateAnim = Tween<double>(begin: 0.0, end: 10.0).animate(anim);
  }

  //Item of menu which will display always and allow to open/close menu
  Widget getPrimaryItem(IconData icon) {
    return Transform.rotate(
      angle: -pi * rotateAnim.value / 10.0,
      child: Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: widget.backgroundColor,
          boxShadow: [
            BoxShadow(color: Colors.black87, blurRadius: rotateAnim.value*2+5.0),
          ],
        ),
        child: Icon(
          icon,
          color: widget.iconColor,
        ),
      ),
    );
  }

  //Item of menu which will drop
  Widget getMenuItem(IconData icon, VoidCallback action) {
    return GestureDetector(
      onTap: () {
        if (controller.isCompleted) {
          controller.reverse();
          action();
        }
      },
      child: Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: widget.backgroundColor,
        ),
        child: Icon(
          icon,
          color: widget.iconColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 5.0),
      width: iconSize + 10.0,
      height: (iconSize + iconSpace) * (widget.buttonsCount + 1),
      child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Container(
                  width: iconSize + 10.0,
                  height: (iconSize + iconSpace) * (widget.buttonsCount + 1),
                  child: Stack(
                    children: widget.icons
                        .map((icon) => Positioned(
                              left: 0.0,
                              top: animations[widget.icons.indexOf(icon)]
                                  .value,
                              child: getMenuItem(icon,
                                  widget.actions[widget.icons.indexOf(icon)]),
                            ))
                        .toList(),
                  ),
                ),
                GestureDetector(
                  onTap: controller.isCompleted
                      ? () {
                          controller.reverse();
                        }
                      : () {
                          controller.forward();
                        },
                  child: getPrimaryItem(Icons.arrow_upward),
                ),
              ],
            );
          }),
    );
  }
}
