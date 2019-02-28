import 'package:cached_network_image/cached_network_image.dart';
import 'package:diary_of_teacher/src/app.dart';
import 'package:diary_of_teacher/src/blocs/menu/menu.dart';
import 'package:diary_of_teacher/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuDrawer extends StatelessWidget {
  MenuBloc menuBloc;

  @override
  Widget build(BuildContext context) {
    menuBloc = BlocProvider.of<MenuBloc>(context);

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
                  moveTo(context, ProfileEvent());
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
                          style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 23.0, letterSpacing: 0.0),
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
                  Container(
                    height: 30.0,
                    child: Image.asset(
                      'assets/images/sheepTP.png',
                      repeat: ImageRepeat.repeat,
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  ListTile(
                    leading: Icon(Icons.event),
                    title: Text('Расписание', style: theme.textTheme.display1),
                    onTap: () {
                      moveTo(context, ScheduleEvent());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Ученики', style: theme.textTheme.display1),
                    onTap: () {
                      moveTo(context, StudentsEvent());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.featured_play_list),
                    title: Text('Уроки', style: theme.textTheme.display1),
                    onTap: () {
                      moveTo(context, LessonsEvent());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text('Перерыв', style: theme.textTheme.display1),
                    onTap: () {
                      moveTo(context, TimeoutEvent());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Настройки', style: theme.textTheme.display1),
                    onTap: () {
                      moveTo(context, SettingsEvent());
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

  void moveTo(context, MenuEvent event) {
    Navigator.of(context).pop();
    menuBloc.dispatch(event);
  }
}
