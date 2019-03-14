import 'package:flutter/material.dart';

//Widget which is displays how much time pass
class TimePasser extends StatefulWidget {
  TimePasser({
    Key key,
    this.textStyle = const TextStyle(fontSize: 20.0, color: Colors.black),
    @required this.controller,
  }) : super(key: key);

  PasserController controller;
  TextStyle textStyle;

  @override
  _TimePasserState createState() => _TimePasserState();
}

class _TimePasserState extends State<TimePasser> {
  PasserController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return controller.state == PasserState.stopped
        ? Container()
        : Container(
      child: Text(
        'Повторный ввод пароля заблокирован ещё ${controller
            .passedTime} секунд',
        softWrap: true,
        style: widget.textStyle,
      ),
    );
  }
}

//Pass controller needs to manipulate by passed time
//Provider needs to set up animation controller
class PasserController extends ChangeNotifier {
  final AnimationController _controller;

  //Provider which can provide ticks
  final TickerProvider vsync;

  //Time in seconds which need to pass
  int secondsToPass;
  Animation<double> timer;

  //State to track controller status
  PasserState state = PasserState.stopped;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //Constructor with basic init
  PasserController({this.vsync, this.secondsToPass})
      : _controller = AnimationController(vsync: vsync) {
    _controller
      ..duration = Duration(seconds: secondsToPass)
      ..addListener(() => notifyListeners())
      ..addStatusListener((status) {
        if (status == AnimationStatus.forward) state = PasserState.ticking;
        if (status == AnimationStatus.completed) state = PasserState.stopped;

        //Notify listeners if they are
        notifyListeners();
      });

    final anim = CurvedAnimation(parent: _controller, curve: Curves.linear);

    timer =
        Tween<double>(begin: 0.0, end: secondsToPass.toDouble()).animate(anim);
  }

  //Get passed time
  int get passedTime => (secondsToPass.toDouble() - timer.value).toInt();

  //Start to pass time if it's stopped
  void toggle() {
    if (state == PasserState.stopped) {
      _controller.value = 0.0;
      _controller.forward();
    }
  }
}

enum PasserState {
  ticking,
  stopped,
}
