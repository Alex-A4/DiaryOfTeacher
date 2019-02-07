import 'package:cached_network_image/cached_network_image.dart';
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
              elevation: 5.0,
              leading: Container(),
              expandedHeight: 150.0,
              flexibleSpace: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
                child: Material(
                  color: Color(0xFFFFEFF5),
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
                          style: TextStyle(
                            fontSize: 20.0,
                            letterSpacing: 2.0,
                          ),
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
                  ListTile(
                    leading: Icon(Icons.event),
                    title: Text('Расписание'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Ученики'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.featured_play_list),
                    title: Text('Уроки'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text('Перерыв'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Настройки'),
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
