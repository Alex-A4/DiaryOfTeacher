import 'package:shared_preferences/shared_preferences.dart';


//Singleton instance of user data
class User {
  static User _user;
  static User getUser() {
    if (_user == null)
      _user = User.fromStore();

    return _user;
  }


  String _uid;
  String _photoUrl;
  String _userName;

  //Constructor to restore user from cache
  User.fromStore() {
    SharedPreferences.getInstance()
        .then((prefs){
          _uid = prefs.getString('id');
          _photoUrl = prefs.getString('photoUrl');
          _userName = prefs.getString('userName');
    });
  }

  String get userName => _userName;

  String get photoUrl => _photoUrl;

  String get uid => _uid;
}