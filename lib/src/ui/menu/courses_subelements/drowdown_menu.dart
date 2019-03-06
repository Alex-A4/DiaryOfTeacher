import 'package:diary_of_teacher/src/app.dart';
import 'package:flutter/material.dart';

class DropdownMenu extends StatefulWidget {
  DropdownMenu({Key key}) : super(key: key);

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

  AnimationController controller;
  Duration duration = Duration(milliseconds: 270);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: duration);

    final anim = CurvedAnimation(parent: controller, curve: Curves.bounceIn);
    firstAnim =
        Tween<double>(begin: 0, end: (iconSize + iconSpace) * 1).animate(anim);
    secondAnim =
        Tween<double>(begin: 0, end: (iconSize + iconSpace) * 2).animate(anim);
    thirdAnim =
        Tween<double>(begin: 0, end: (iconSize + iconSpace) * 3).animate(anim);
  }

  //Item of menu which will display always and allow to open/close menu
  Widget getPrimaryItem(IconData icon) {
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: theme.primaryColor,
      ),
      child: Icon(
        icon,
        color: Colors.black54,
      ),
    );
  }

  //Item of menu which will drop
  Widget getMenuItem(IconData icon, VoidCallback action) {
    return GestureDetector(
      onTap: action,
      child: Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: theme.primaryColor,
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
      width: 50.0,
      height: (iconSize + iconSpace) * 4,
      child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Positioned(
                  left: 0.0,
                  top: firstAnim.value,
                  child: getMenuItem(icons[0], () {}),
                ),
                Positioned(
                  left: 0.0,
                  top: secondAnim.value,
                  child: getMenuItem(icons[1], () {}),
                ),
                Positioned(
                  left: 0.0,
                  top: thirdAnim.value,
                  child: getMenuItem(icons[2], () {}),
                ),
                GestureDetector(
                  onTap: controller.isCompleted
                      ? controller.reverse
                      : controller.forward(),
                  child: getPrimaryItem(
                      controller.isCompleted || controller.isAnimating
                          ? Icons.arrow_upward
                          : Icons.arrow_downward),
                ),
              ],
            );
          }),
    );
  }
}
