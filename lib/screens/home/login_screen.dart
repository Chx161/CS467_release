import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/models/Filter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_app/screens/home/home_screen.dart';
import 'package:flutter_app/screens/home/signup_user_screen.dart';
import 'package:flutter_app/screens/home/signup_shelter_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/api/api.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  String email, password;
  TextEditingController _emailController=new TextEditingController();
  TextEditingController _passwordController=new TextEditingController();
  bool isLoading=false; // for double click
  GlobalKey<ScaffoldState>_scaffoldKey=GlobalKey();

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            controller: _emailController,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            controller: _passwordController,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn(context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        // onPressed: () => print('Login Button Pressed'),
        onPressed: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          // print('Login Button Pressed');
          if(isLoading)
          {
            return;
          }
          login(_emailController.text,_passwordController.text);
          setState(() {
            isLoading=true;
          });
          
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
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

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Join us as',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
                      child: RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: Colors.white,
                        child: Text(
                          "USER",
                          style: TextStyle(
                          color: Color(0xFF527DAA),
                          letterSpacing: 1.5,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                          ),
                        ),
                        onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SignupUserScreen(),
              ),
            )
                      ),
                      flex: 2,
                    ),
          Spacer(),
          Expanded(
                      child: RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: Colors.white,
                        child: Text(
                          "SHELTER",
                          style: TextStyle(
                          color: Color(0xFF527DAA),
                          letterSpacing: 1.5,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                          ),
                        ),
                        onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SignupShelterScreen(),
              ),
            )
                      ),
                      flex: 2,
                    ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => print('Sign Up Button Pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  login(email,password) async
  {
    Map data = {
      'grant_type': "password",
      'username': email,
      'password': password
    };
    print(data.toString());
    final  response= await http.post(
        LOGIN,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "Basic YXBwOmFwcDEyMw=="
        },
        body: data,
        //encoding: Encoding.getByName("utf-8")
    );

    if (response.statusCode == 200) {
      Map<String,dynamic>responseMap=jsonDecode(response.body);
      final  responseCurr = await http.get(
        CURRENT,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + responseMap['access_token']
        }
       // encoding: Encoding.getByName("utf-8")
      ) ;
      setState(() {
        isLoading=false;
      });

      if (responseCurr.statusCode == 200) {
          Map<String,dynamic>currMap=jsonDecode(responseCurr.body);
        print(currMap.toString());


        if(currMap['status'].compareTo("success") == 0)
        {
          
          savePref(currMap["data"]['isAdmin'],
            currMap["data"]['isShelter'],
            currMap["data"]['userID'],
            currMap["data"]['email'],
            currMap["data"]['firstName'],
            currMap["data"]['lastName'],
            currMap["data"]['zipCode'],
            currMap["data"]['phoneNumber'],
            currMap["data"]['shelterName'],
            responseMap["access_token"]
          );
          Filter filter = Filter(1, 1, 1, 1, "cat", "available");     // dummy filter instance, not used
          Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomeScreen(filter: filter, useFilter: false),   // add params
              ),
            );
        }else{
          //print(" ${resposne['message']}");
        }
      

      } else {
        showInSnackBar("Login Error, Please try again!");
      }
    } else {
      showInSnackBar("Login Error, Please try again!");
      setState(() {
        isLoading=false;
      });
    }

  }
  savePref(int isAdmin, int isShelter, int userID, String email, String firstName, String lastName, String zipCode, String phoneNumber, String shelterName, String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
      print('Login Button Pressed' + userID.toString() + email);
      preferences.setInt("isAdmin", isAdmin);
      preferences.setInt("isShelter", isShelter);
      preferences.setInt("userID", userID);
      preferences.setString("email", email);
      preferences.setString("firstName", firstName);
      preferences.setString("lastName", lastName);
      preferences.setString("zipCode", zipCode);
      preferences.setString("phoneNumber", phoneNumber);
      preferences.setString("shelterName", shelterName);
      preferences.setString("token", token);
      preferences.commit();

  }

  void showInSnackBar(String value) {
    print(value);
    _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(value)));
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildEmailTF(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                      // _buildForgotPasswordBtn(),
                      // _buildRememberMeCheckbox(),
                      _buildLoginBtn(context),
                      _buildSignInWithText(),
                      _buildSocialBtnRow(),
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