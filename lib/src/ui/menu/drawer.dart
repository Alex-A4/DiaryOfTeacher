import 'package:cached_network_image/cached_network_image.dart';
import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/models/user.dart';
import 'package:diary_of_teacher/src/ui/main/profile_screen.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5.0,
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: Container(),
              expandedHeight: 150.0,
              flexibleSpace: GestureDetector(
                onTap: () {
                  Windows.moveTo(Window.Profile, context, () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ProfileScreen()));
                  });
                },
                child: Material(
                  elevation: 5.0,
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundImage: CachedNetworkImageProvider(
                            User.user.photoUrl,
                          ),
                        ),
                        padding: EdgeInsets.only(
                            left: 15.0, top: 40.0, bottom: 15.0),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20.0, bottom: 7.0),
                        child: Text(
                          User.user.userName,
                          style: theme.textTheme.display1,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  SizedBox(
                    height: 25.0,
                  ),
                  ListTile(
                    leading: Icon(Icons.event),
                    title: Text('Расписание', style: theme.textTheme.display1),
                    onTap: () {
                      Windows.moveTo(Window.Schedule, context, (){
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Ученики', style: theme.textTheme.display1),
                    onTap: () {
                      Windows.moveTo(Window.Schedule, context, (){
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.featured_play_list),
                    title: Text('Уроки', style: theme.textTheme.display1),
                    onTap: () {
                      Windows.moveTo(Window.Schedule, context, (){
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text('Перерыв', style: theme.textTheme.display1),
                    onTap: () {
                      Windows.moveTo(Window.Schedule, context, (){
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Настройки', style: theme.textTheme.display1),
                    onTap: () {
                      Windows.moveTo(Window.Schedule, context, (){
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum Window {
  Profile,
  Schedule,
  Students,
  Lessons,
  Timeout,
  Settings,
}

class Windows {
  Window _currentWindow;

  set currentWindow(Window value) => _currentWindow = value;

  Window get currentWindow => _currentWindow;

  //Singleton instance
  static Windows _window;

  //Close drawer and move to another window
  static void moveTo(
      Window nextWindow, BuildContext context, Function func) async {
    if (_window == null) {
      _window = Windows();
    }
    _window.currentWindow = nextWindow;

    _closeDrawer(context);
    //Wait while drawer is not close
    await Future.delayed(Duration(seconds: 1));

    //If we choose another window then open it
    if (_window.currentWindow != nextWindow) func();
  }

  //Close the drawer and go to new screen
  static void _closeDrawer(context) {
    Navigator.of(context).pop();
  }
}
