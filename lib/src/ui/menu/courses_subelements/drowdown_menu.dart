import 'package:diary_of_teacher/src/app.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class DropdownMenu extends StatefulWidget {
  DropdownMenu({Key key, this.editAction, this.addPhotoAction, this.textAction})
      : super(key: key);

  VoidCallback editAction;
  VoidCallback addPhotoAction;
  VoidCallback textAction;

  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu>
    with SingleTickerProviderStateMixin {
  final iconSize = 40.0;
  final iconSpace = 5.0;

  final List<IconData> icons = [
    Icons.edit,
    Icons.add_a_photo,
    Icons.text_fields
  ];

  Animation<double> firstAnim;
  Animation<double> secondAnim;
  Animation<double> thirdAnim;
  Animation<double> rotateAnim;

  AnimationController controller;
  Duration duration = Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: duration);

    final anim =
        CurvedAnimation(parent: controller, curve: Curves.easeOutQuart);
    firstAnim =
        Tween<double>(begin: 0, end: (iconSize + iconSpace) * 1).animate(anim);
    secondAnim =
        Tween<double>(begin: 0, end: (iconSize + iconSpace) * 2).animate(anim);
    thirdAnim =
        Tween<double>(begin: 0, end: (iconSize + iconSpace) * 3).animate(anim);
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
          color: theme.primaryColor,
          boxShadow: [
            BoxShadow(color: Colors.black54, blurRadius: rotateAnim.value + 5.0)
          ],
        ),
        child: Icon(
          icon,
          color: Colors.black54,
        ),
      ),
    );
  }

  //Item of menu which will drop
  Widget getMenuItem(IconData icon, VoidCallback action) {
    return GestureDetector(
      onTap: () {
        controller.reverse();
        action();
      },
      child: Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: theme.primaryColorDark,
        ),
        child: Icon(
          icon,
          color: Colors.black54,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 5.0),
      width: iconSize + 10.0,
      height: (iconSize + iconSpace) * 4,
      child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Positioned(
                  left: 0.0,
                  top: firstAnim.value,
                  child: getMenuItem(icons[0], widget.editAction),
                ),
                Positioned(
                  left: 0.0,
                  top: secondAnim.value,
                  child: getMenuItem(icons[1], widget.addPhotoAction),
                ),
                Positioned(
                  left: 0.0,
                  top: thirdAnim.value,
                  child: getMenuItem(icons[2], widget.textAction),
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
