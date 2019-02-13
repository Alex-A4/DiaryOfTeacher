import 'package:shared_preferences/shared_preferences.dart';

//Singleton instance of user data
class User {
  static User _user;

  static User get user => _user;

  String _uid;
  String _photoUrl;
  String _userName;

  //Building user data from cache
  static Future<Null> buildUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _user = User.fromStore(prefs);
  }

  //Constructor to restore user from cache
  User.fromStore(SharedPreferences prefs) {
    _uid = prefs.getString('id');
    _photoUrl = prefs.getString('photoUrl');
    _userName = prefs.getString('userName');
  }

  String get userName => _userName;

  String get photoUrl => _photoUrl;

  String get uid => _uid;

  set userName(String value) => _userName = value;

  set photoUrl(String value) => _photoUrl = value;
}
