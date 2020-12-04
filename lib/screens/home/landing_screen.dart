import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/models/Filter.dart';
import 'package:flutter_app/screens/home/home_screen.dart';
import 'package:flutter_app/screens/home/signup_user_screen.dart';
import 'package:flutter_app/screens/home/signup_shelter_screen.dart';

import 'login_screen.dart';


class LandingScreen extends StatelessWidget {
  LandingScreen({Key key}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'WELCOME',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Text(
                        'This is a "dating" app project that matches shelter animals up with prospective owners.\n\nJoin us as a public user or shelter. \n\nAll public users can use this app to browse and search for prospective candidate pets for adoption. The app will show available animals with detailed information like breed, type and disposition for the user to make decisions. Administrators can log in with access to add or delete pet profiles. Shelter users can add and manage the profiles that they own.',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      _buildLoginBtn(context),
                      // _buildSignupBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


  Widget _buildLoginBtn(context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        // onPressed: () => print('Login Button Pressed'),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN or SIGNUP',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }