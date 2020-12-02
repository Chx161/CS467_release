import 'dart:convert';
import 'package:flutter_app/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/models/Profile.dart';
import 'package:flutter_app/screens/home/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/models/Filter.dart';

class Body extends StatefulWidget {
  final Profile profile;
  const Body({Key key, this.profile}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // final Profile profile;
  // const Body({Key key, this.profile}) : super(key: key);
  String _curr_avail;
  SharedPreferences preferences;

  void initState() {
    super.initState();
    _curr_avail = widget.profile.availability;
    getPref();
  }

  void getPref() async {
    SharedPreferences retrievedPref = await SharedPreferences.getInstance();
    setState(() {
      preferences = retrievedPref;
      // print(preferences.getInt('isShelter'));
    });
  }

  void _toggleAvail(String newAvail) {
    setState(() {
      if (newAvail == "Adopted") {
        _curr_avail = "Adopted";
      } else if (newAvail == "Pending") {
        _curr_avail = "Pending";
      } else if (newAvail == "Not Available") {
        _curr_avail = "Not Available";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (preferences == null) {
      return CircularProgressIndicator();
    }
    Size size = MediaQuery.of(context).size;
    return ListView(
      children: <Widget>[
        (widget.profile.image.isEmpty || widget.profile.image == null)
            ? Image.asset(
                "assets/images/havanese.jpg",
                width: 600,
                height: 240,
                fit: BoxFit.fitHeight,
              )
            : Image.memory(
                widget.profile.image,
                width: 600,
                height: 240,
                fit: BoxFit.fitHeight,
              ),
        titleSection(widget.profile, _curr_avail),
        textSection(widget.profile),
        // Adopt button, visible to public users
        Visibility(
          visible: ((preferences.getInt('isShelter') == 0 && preferences.getInt('isAdmin') == 0) && widget.profile.availability == "Available") ? true : false,
          child: Container(
            margin: EdgeInsets.all(15),
            child: FlatButton(
              child: Text('Adopt'),
              color: kPrimaryColor,
              textColor: Colors.white,
              onPressed: () async {
                // SharedPreferences preferences =
                // await SharedPreferences.getInstance();
                // print("isAdmin: " + preferences.getInt('isAdmin').toString());
                String requestURL =
                    ADOPT + '/' + widget.profile.profileID.toString();
                // print("adopt profile by id: " + requestURL);
                // Public user. Can only adopt available pets
                print("availability: " + widget.profile.availability);
                if (widget.profile.availability != "Available" &&
                    preferences.getInt('isAdmin') == 0 &&
                    preferences.getInt('isShelter') == 0) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Currently not available. Please take a look at other pet\'s profiles.')));
                }
                if (widget.profile.availability == "Available" &&
                    preferences.getInt('isAdmin') == 0 &&
                    preferences.getInt('isShelter') == 0) {
                  // print("not admin");
                  Map data = {'availability': "Pending"};
                  final response = await http.post(
                    requestURL,
                    headers: {
                      "Accept": "application/json",
                      "Authorization":
                          "Bearer " + preferences.getString('token')
                    },
                    body: data,
                    //encoding: Encoding.getByName("utf-8")
                  );
                  if (response.statusCode == 200) {
                    Map<String, dynamic> responseMap =
                        jsonDecode(response.body);
                    print(responseMap.toString());
                    if (responseMap['status'].compareTo("success") == 0) {
                      _toggleAvail("Pending");
                      Filter filter = Filter(1, 1, 1, 1, "cat",
                          "available"); // dummy filter instance, not used
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Request sent to admin. Please wait for approval.')));
                      Future.delayed(const Duration(milliseconds: 800), () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => new HomeScreen(
                                filter: filter, useFilter: false), // add params
                          ),
                        );
                      });
                    } else {
                      //print(" ${resposne['message']}");
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text(responseMap['reason'])));
                    }
                  } else {
                    print(response.statusCode.toString());
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("Error, Please try again!")));
                  }
                } // Public users
              },
            ),
          ),
        ),

        Visibility(
          visible: ((preferences.getInt('isShelter') == 1 || preferences.getInt('isAdmin') == 1) && widget.profile.availability == "Pending") ? true : false,
          child: Container(
            margin: EdgeInsets.all(15),
            child: FlatButton(
              child: Text('Approve Adoption'),
              color: kPrimaryColor,
              textColor: Colors.white,
              onPressed: () async {
                // SharedPreferences preferences =
                // await SharedPreferences.getInstance();
                String requestURL =
                    ADOPT + '/' + widget.profile.profileID.toString();
                // Admin user.
                print("availability: " + widget.profile.availability);
                // if (widget.profile.availability != "Available" &&
                //     preferences.getInt('isAdmin') == 0 &&
                //     preferences.getInt('isShelter') == 0) {
                //   Scaffold.of(context).showSnackBar(SnackBar(
                //       content: Text(
                //           'Currently not available. Please take a look at other pet\'s profiles.')));
                // }

                if (widget.profile.availability == "Pending" &&
                    (preferences.getInt('isAdmin') == 1 ||
                        preferences.getInt('isShelter') == 1)) {
                  Map data = {'availability': "Adopted"};
                  final response = await http.post(
                    requestURL,
                    headers: {
                      "Accept": "application/json",
                      "Authorization":
                      "Bearer " + preferences.getString('token')
                    },
                    body: data,
                    //encoding: Encoding.getByName("utf-8")
                  );
                  if (response.statusCode == 200) {
                    Map<String, dynamic> responseMap =
                    jsonDecode(response.body);
                    print(responseMap.toString());
                    if (responseMap['status'].compareTo("success") == 0) {
                      _toggleAvail("Adopted");
                      Filter filter = Filter(1, 1, 1, 1, "cat",
                          "available"); // dummy filter instance, not used
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Approved adoption. Redirecting to home page.')));
                      Future.delayed(const Duration(milliseconds: 800), () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => new HomeScreen(
                                filter: filter, useFilter: false), // add params
                          ),
                        );
                      });
                    } else {
                      //print(" ${resposne['message']}");
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text(responseMap['reason'])));
                      // setState(() {
                      //   isSaving = false;
                      // });
                    }
                  } else {
                    print(response.statusCode.toString());
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("Error, Please try again!")));
                    // setState(() {
                    //   isSaving = false;
                    // });
                  }
                } // Admin or shelter users
              },
            ),
          ),
        ),

        // Delete button. Only visible to shelter and admin
        Visibility(
          visible: (preferences.getInt('isShelter') == 1 || preferences.getInt('isAdmin') == 1) ? true : false,
          child: Container(
            margin: EdgeInsets.all(15),
            child: FlatButton(
              child: Text('Delete Profile'),
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () async {
                // SharedPreferences preferences =
                //     await SharedPreferences.getInstance();
                String requestURL =
                    DELETE + '/' + widget.profile.profileID.toString();
                // print("delete profile by id: " + requestURL);
                Map data = {'id': widget.profile.profileID.toString()};
                final response = await http.post(
                  requestURL,
                  headers: {
                    "Accept": "application/json",
                    "Authorization": "Bearer " + preferences.getString('token')
                  },
                  body: data,
                  //encoding: Encoding.getByName("utf-8")
                );
                if (response.statusCode == 200) {
                  Map<String, dynamic> responseMap = jsonDecode(response.body);
                  print(responseMap.toString());
                  if (responseMap['status'].compareTo("success") == 0) {
                    Filter filter = Filter(1, 1, 1, 1, "cat",
                        "available"); // dummy filter instance, not used
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Delete successful')));
                    Future.delayed(const Duration(milliseconds: 500), () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(
                              filter: filter, useFilter: false), // add params
                        ),
                      );
                    });
                  } else {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text(responseMap['reason'])));
                  }
                } else {
                  print(response.statusCode.toString());
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Error, Please try again!")));
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

Widget titleSection(Profile profile, String _curr_avail) {
  return Container(
    padding: const EdgeInsets.all(32),
    child: Row(
      children: [
        Expanded(
          /*1*/
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*2*/
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  profile.petName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  profile.breed,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ),
              Text(
                _curr_avail,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
              // --- Dispositions ---
              (profile.goodWithAnimal == 1)
                  ? Text(
                      "Good with animals",
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    )
                  : Text(
                      "Not good with animals",
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
              (profile.goodWithChild == 1)
                  ? Text(
                      "Good with child",
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    )
                  : Text(
                      "Not good with child",
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
              (profile.leashed == 1)
                  ? Text(
                      "Must be leashed at all times",
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    )
                  : Text(
                      "Doesn't have to be leashed at all times",
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    )
            ],
          ),
        ),
        FavoriteWidget(),
      ],
    ),
  );
}

Widget textSection(Profile profile) {
  return Container(
    padding: const EdgeInsets.all(32),
    child: Text(
      profile.description == null ? "" : profile.description,
      softWrap: true,
    ),
  );
}

class FavoriteWidget extends StatefulWidget {
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = true;
  int _favoriteCount = 20;

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount -= 1;
        _isFavorited = false;
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            padding: EdgeInsets.all(0),
            alignment: Alignment.centerRight,
            icon: (_isFavorited ? Icon(Icons.star) : Icon(Icons.star_border)),
            color: Colors.red[500],
            onPressed: _toggleFavorite,
          ),
        ),
        SizedBox(
          width: 18,
          child: Container(
            child: Text('$_favoriteCount'),
          ),
        ),
      ],
    );
  }
}
