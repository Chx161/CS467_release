import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/models/Filter.dart';
import 'package:flutter_app/models/Profile.dart';
import 'package:flutter_app/screens/details/details_screen.dart';
import 'item_card.dart';
import 'package:flutter_app/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as dart_img;

class Body extends StatefulWidget {
  final bool useFilter;
  final Filter filter;

  Body({
    Key key,
    this.useFilter,
    this.filter,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Profile> profiles = List();
  Uint8List pic;
  String breed;

  // init state
  @override
  void initState() {
    super.initState();
    watchPetsCollection();
  }

  // Fetch Pic url by profile ID
  Future<bool> getPicUrl(int profileID) async {
    String requestURL = PICTURE_GET + '/' + profileID.toString();
    // print(requestURL);
    final response = await http.get(requestURL,
        headers: {"Accept": "application/json; charset=utf-8"});

    if (response.statusCode == 200) {
      //  print(base64.decode(jsonDecode(response.body)[0]['picUrl']));
      if (jsonDecode(response.body).length > 0) {
        pic = base64.decode(jsonDecode(response.body)[0]['picUrl']);
      } else {
        pic = Uint8List.fromList([]);
      }
      return true;
    } else {
      pic = Uint8List.fromList([]);
      throw Exception('Failed to load pic');
    }
  }

  Future<bool> getBreed(int profileID) async {
    String requestURL = BREED + '/' + profileID.toString();
    // print("GET breed: " + requestURL);
    final response = await http.get(requestURL,
        headers: {"Accept": "application/json; charset=utf-8"});
    if (response.statusCode == 200) {
      if (jsonDecode(response.body).length > 0) {
        breed = jsonDecode(response.body)['breedName'];
      } else {
        breed = "No breed information";
      }
      return true;
    } else {
      breed = "No breed information";
      throw Exception('Failed to load breed');
    }
  }

  // Fetch profiles
  void watchPetsCollection() async {
    print("Execute post request function");
    // post body
    Map filters;
    if (widget.useFilter == null || !widget.useFilter) {      // why useFilter could be null when page refreshed ????????
      filters = {
        // 'filters': {},
        'filters': {"isDeleted": 0},
      };
    } else {
      filters = {
        // 'filters': {"type": "cat"},
        'filters': widget.filter.toJson(),
      };
    }
    print("Before sending request: ");
    print(filters.toString());
    // send request
    final response = await http.post(
      PROFILES,
      headers: {"Accept": "application/json", "Content-Type": "application/json"},
      // Reference: https://stackoverflow.com/questions/50278258/http-post-with-json-on-body-flutter-dart
      body: utf8.encode(json.encode(filters)),      // !!!!!!!!
      //encoding: Encoding.getByName("utf-8")
    );
    // get response
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<Profile> retrievedProfiles = List();
      // print(jsonDecode(response.body)['data']);
      for (dynamic document in jsonDecode(response.body)['data']) {
        // print(document);
        Profile profile = Profile.fromJson(document);
        await getPicUrl(document['profileID']);
        profile.setImage = pic;
        await getBreed(document['profileID']);
        profile.setBreed = breed;
        // print(document['profileID']);
        // get pic url
        retrievedProfiles.add(profile);
      }
      setState(() {
        profiles = retrievedProfiles;
      });
    } else {
      throw Exception('Failed to load profiles');
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   if (currentPic == null) {
  //     return CircularProgressIndicator();
  //   }
  //   else if (currentPic.isEmpty){
  //     return CircularProgressIndicator();
  //     // return Container(
  //     //   height: 120.0,
  //     //   width: 120.0,
  //     //   decoration: BoxDecoration(
  //     //     image: DecorationImage(
  //     //       image: MemoryImage(sampleImage),
  //     //       fit: BoxFit.fitWidth,
  //     //     ),
  //     //     shape: BoxShape.circle,
  //     //   ),
  //     // );
  //   }

  // @override
  // Widget build(BuildContext context) =>
  // FutureBuilder( future: getPicUrl(11), builder: (context, snapshot) {
  //   if (snapshot.hasData){
  //     return Container(
  //             height: 120.0,
  //             width: 120.0,
  //             decoration: BoxDecoration(
  //               image: DecorationImage(
  //                 image: MemoryImage(currentPic),
  //                 fit: BoxFit.fitWidth,
  //               ),
  //               shape: BoxShape.circle,
  //             ),
  //           );
  //   }
  //   else {
  //     return CircularProgressIndicator();
  // }
  // });

  @override
  Widget build(BuildContext context) {
    if (profiles == null) {
      return CircularProgressIndicator();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: GridView.builder(
              itemCount: profiles.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: kDefaultPadding,
                  crossAxisSpacing: kDefaultPadding,
                  childAspectRatio: 0.75),
              itemBuilder: (context, index) => ItemCard(
                profile: profiles[index],
                press: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                        profile: profiles[index],
                      ),
                    )),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
