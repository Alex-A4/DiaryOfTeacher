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
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
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
                  SizedBox(height: 25.0,),
                  ListTile(
                    leading: Icon(Icons.event),
                    title: Text('Расписание', style: theme.textTheme.display1),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Ученики', style: theme.textTheme.display1),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.featured_play_list),
                    title: Text('Уроки', style: theme.textTheme.display1),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text('Перерыв', style: theme.textTheme.display1),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Настройки', style: theme.textTheme.display1),
                    onTap: () {},
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
