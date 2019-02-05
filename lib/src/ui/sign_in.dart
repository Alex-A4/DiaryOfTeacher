import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_of_teacher/src/ui/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  SharedPreferences prefs;

  //For authentication
  final GoogleSignIn _gsi = GoogleSignIn();
  final FirebaseAuth _fbAuth = FirebaseAuth.instance;

  FirebaseUser currentUser;
  bool isLoading = false;
  bool isLoggedIn = false;

  //For building password
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await _gsi.signIn();
    //If user not select an account
    if (googleUser == null) {
      this.setState(() {
        isLoading = false;
      });
      return;
    }

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _fbAuth.signInWithGoogle(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    if (user != null) {
      // Check is already signed up
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;

      currentUser = user;

      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance
            .collection('users')
            .document(user.uid)
            .setData({'photoUrl': user.photoUrl, 'id': user.uid});

        // Write data to local
        print('UserId: ${currentUser.uid}\nPhotoUrl: ${currentUser.photoUrl}');
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('photoUrl', currentUser.photoUrl);
      } else {
        // Write data to local
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
        await prefs.setInt('passwordHash', documents[0]['passwordHash']);
      }
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
      });

      setState(() {
        isLoggedIn = true;
      });
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
        isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? getPasswordBuilding() : getSignIn();
  }

  //Screen to set password for user
  Widget getPasswordBuilding() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Придумайте пароль'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/login_picture.png',
                  height: 200.0,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(
                  height: 50.0,
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintText: 'Введите пароль',
                    ),
                    controller: _passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    validator: (pass) {
                      if (pass.isEmpty) return 'Введите пароль';
                      if (pass.length != 6)
                        return 'Пароль должен состоять из 6 символов';
                    },
                    textAlign: TextAlign.center,
                    maxLength: 6,
                  ),
                ),
                RaisedButton(
                  child: Text(
                    'Сохранить',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      //Writing hashcode of password to stores
                      Firestore.instance
                          .collection('users')
                          .document(currentUser.uid)
                          .updateData({
                        'passwordHash': _passwordController.text.hashCode
                      });

                      prefs.setInt(
                          'passwordHash', _passwordController.text.hashCode);

                      print(
                          'PasswordHash: ${_passwordController.text.hashCode}');

                      Fluttertoast.showToast(
                          msg: 'Пароль сохранён',
                          gravity: ToastGravity.BOTTOM,
                          textColor: Colors.black);
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => LogIn()));
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Screen to sign in with Google
  Widget getSignIn() {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Авторизация'),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/login_picture.png',
                    height: 200.0,
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  RaisedButton(
                    onPressed: handleSignIn,
                    child: Text('войти с помощью гугл'.toUpperCase()),
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                  ),
                ],
              ),
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xFFF0FFF0),
                    ),
                  )
                : Container(),
          ],
        ));
  }
}
