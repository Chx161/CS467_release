import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_app/screens/home/home_screen.dart';
import 'package:flutter_app/screens/home/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/api/api.dart';
import 'dart:convert';


class SignupShelterScreen extends StatefulWidget {
  @override
  _SignupShelterScreenState createState() => _SignupShelterScreenState();
}

class _SignupShelterScreenState extends State<SignupShelterScreen> {
  String email, password;
  TextEditingController _emailController=new TextEditingController();
  TextEditingController _passwordController=new TextEditingController();
  TextEditingController _shelternameController=new TextEditingController();
  TextEditingController _zipcodeController=new TextEditingController();
  TextEditingController _phonenumberController=new TextEditingController();
  bool isLoading=false; // for double click
  GlobalKey<ScaffoldState>_scaffoldKey=GlobalKey();

  Widget _buildNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            controller: _shelternameController,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Shelter Name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }
//phone_android
//place
  Widget _buildZipPhoneTFRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
                      child: Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            controller: _zipcodeController,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.place,
                color: Colors.white,
              ),
              hintText: 'Enter your Zipcode',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
                      flex: 3,
                    ),
          Spacer(),
          Expanded(
                      child: Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            controller: _phonenumberController,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.phone_android,
                color: Colors.white,
              ),
              hintText: 'Enter your Phonenumber',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
                      flex: 3,
                    ),
        ],
      ),
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        
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


  Widget _buildSignupBtn(context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          // print('Login Button Pressed');
          if(isLoading)
          {
            return;
          }
          signup(_emailController.text,
            _passwordController.text,
            _shelternameController.text,
            _zipcodeController.text,
            _phonenumberController.text);
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
          'SIGNUP',
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

  

  

  

  signup(email,password,shelterName,zipCode,phoneNumber) async
  {
    Map data = {
      'shelterName': shelterName,
      'email': email,
      'password': password,
      'zipCode': zipCode,
      'phoneNumber': phoneNumber
    };
    print(data.toString());
    final  response= await http.post(
        SHELTER_SIGNUP,
        headers: {
          "Accept": "application/json"
        },
        body: data,
        //encoding: Encoding.getByName("utf-8")
    );

    if (response.statusCode == 200) {
      Map<String,dynamic>responseMap=jsonDecode(response.body);
      
        print(responseMap.toString());


        if(responseMap['status'].compareTo("success") == 0)
        {
          
          showInSnackBar("Signup successful, please login");
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );

          });
          
        }else{
          //print(" ${resposne['message']}");
          showInSnackBar(responseMap['reason']);
          setState(() {
            isLoading=false;
          });
        }
    } else {
      showInSnackBar("Signup Error, Please try again!");
      setState(() {
        isLoading=false;
      });
    }

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
                        'Shelter Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      SizedBox(
                        height: 20.0,
                      ),
                      _buildNameTF(),
                      
                      _buildZipPhoneTFRow(),
                       
                      _buildEmailTF(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildSignupBtn(context)
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