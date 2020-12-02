import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/models/Breed.dart';
import 'package:flutter_app/models/Disposition.dart';
import 'package:flutter_app/models/Filter.dart';
import 'package:flutter_app/models/Profile.dart';
import 'package:flutter_app/screens/home/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/api/api.dart';


class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  SearchPageState createState() {
    return new SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  List<Breed> dogBreeds = List<Breed>();
  List<Breed> catBreeds = List<Breed>();
  List<Breed> otherBreeds = List<Breed>();
  List<Breed> breedsOptions;

  final _formKey = GlobalKey<FormState>();
  String selectedType = "dog";
  String selectedAvail = "Available";
  int selectedBreed = 0;
  bool goodWithAnimal = true;
  bool goodWithChild = true;
  bool leashed = true;
  // bool isSaving=false; // for double click

  Future<String> fetchBreeds() async {
    final response = await http.get(BREEDS, headers: {"Accept": "application/json"});
    List<Breed> breeds;
    if (response.statusCode == 200) {
      var breedObjsJson = jsonDecode(response.body) as List;
      breeds = breedObjsJson.map((breedJson) => Breed.fromJson(breedJson)).toList();
    } else {
      throw Exception('Failed to load breeds');
    }
    List<Breed> fetchedDogBreeds = new List<Breed>();
    List<Breed> fetchedCatBreeds = new List<Breed>();
    List<Breed> fetchedOtherBreeds = new List<Breed>();
    breeds.forEach((breed) => {
      if (breed.type.compareTo("cat") == 0) {
        fetchedCatBreeds.add(breed)
      }else
        if (breed.type.compareTo("dog") == 0) {
          fetchedDogBreeds.add(breed)
        }else
          if (breed.type.compareTo("other") == 0) {
            fetchedOtherBreeds.add(breed)
          }
    });

    setState(() {
      dogBreeds = fetchedDogBreeds;
      catBreeds = fetchedCatBreeds;
      otherBreeds = fetchedOtherBreeds;
      breedsOptions = dogBreeds;
      selectedBreed = dogBreeds[0].breedID;
    });
    return "Success";
  }

  static SearchPageState of(BuildContext context) {
    return context.findAncestorStateOfType<SearchPageState>();
  }

  @override
  void initState() {
    super.initState();
    this.fetchBreeds();
  }

  @override
  Widget build(BuildContext context) {
    if (breedsOptions == null) {
      return Scaffold(appBar: AppBar(
        title: Text("Add search criterion"),
        leading: CloseButton(),
        actions: <Widget>[
          Builder(
            builder: (context) => FlatButton(
              child: Text("SAVE"),
              textColor: Colors.white,
              onPressed: () {
                // if (isSaving) {
                //   return;
                // }
                SearchPageState.of(context).save(context);
              },
            ),
          ),
        ],
      ), body: LinearProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Add search criterion"),
        leading: CloseButton(),
        actions: <Widget>[
          Builder(
            builder: (context) => FlatButton(
              child: Text("Filter"),
              textColor: Colors.white,
              onPressed: () {
                SearchPageState.of(context).save(context);
              },
            ),
          ),
        ],
      ),
      body: ListView(
        children: [Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 16.0,
                ),
                Text("Type:"),
                buildTypeDropdownButton(),
                Container(
                  height: 16.0,
                ),
                Text("Availability:"),
                buildAvailDropdownButton(),
                Container(
                  height: 16.0,
                ),
                Text("Breed:"),
                buildBreedDropdownButton(),
                Container(
                  height: 16.0,
                ),
                Text("Dispositions:"),
                buildGoodWAnimalListTile(),
                buildGoodWChildListTile(),
                buildLeashedListTile(),
                Container(
                  height: 16.0,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  CheckboxListTile buildGoodWAnimalListTile() {
    return CheckboxListTile(
              title: Text('Good with animals'),
              value: goodWithAnimal,
              onChanged: (newValue) {
                setState(() {
                  goodWithAnimal = newValue;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
            );
  }

  CheckboxListTile buildGoodWChildListTile() {
    return CheckboxListTile(
      title: Text('Good with children'),
      value: goodWithChild,
      onChanged: (newValue) {
        setState(() {
          goodWithChild = newValue;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
    );
  }

  CheckboxListTile buildLeashedListTile() {
    return CheckboxListTile(
      title: Text('Must be leashed at all times'),
      value: leashed,
      onChanged: (newValue) {
        setState(() {
          leashed = newValue;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
    );
  }

  DropdownButton<String> buildTypeDropdownButton() {
    return DropdownButton<String>(
      value: selectedType,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: kPrimaryColor),
      underline: Container(
        height: 2,
        color: kPrimaryColor,
      ),
      onChanged: (String newValue) {
        setState(() {
          selectedType = newValue;
          if (selectedType == 'dog') {
            breedsOptions = dogBreeds;
          }else if (selectedType == 'cat') {
            breedsOptions = catBreeds;
          }
          else if (selectedType == 'other') {
            breedsOptions = otherBreeds;
          }
          selectedBreed = breedsOptions[0].breedID;
        });
      },
      items: <String>['dog', 'cat', 'other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  DropdownButton<int> buildBreedDropdownButton() {
    return DropdownButton<int>(
      value: selectedBreed,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: kPrimaryColor),
      underline: Container(
        height: 2,
        color: kPrimaryColor,
      ),
      onChanged: (int newValue) {
        setState(() {
          selectedBreed = newValue;
        });
      },
      items: breedsOptions
          .map<DropdownMenuItem<int>>((Breed v) {
        return DropdownMenuItem<int>(
          value: v.breedID,
          child: Text(v.breedName),
        );
      }).toList(),
    );
  }

  DropdownButton<String> buildAvailDropdownButton() {
    return DropdownButton<String>(
      value: selectedAvail,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: kPrimaryColor),
      underline: Container(
        height: 2,
        color: kPrimaryColor,
      ),
      onChanged: (String newValue) {
        setState(() {
          selectedAvail = newValue;
        });
      },
      items: <String>['Available', 'Not available', 'Pending', 'Adopted']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  // Convert dispositions bool to int for filter model
  int toInt(dispo) {
    if (dispo) {
      return 1;
    }
    else {
      return 0;
    }
  }

  void save(context) async{
    if (_formKey.currentState.validate()) {
      Scaffold
          .of(context)
          .showSnackBar(SnackBar(content: Text('Processing Data')));
      Map data = {
        'type': selectedType,
        // 'shelterID': preferences.getInt("userID").toString(),
        'breedID': selectedBreed.toString(),
        'availability': selectedAvail,
        'goodWithAnimal': goodWithAnimal?"1":"0",
        'goodWithChild': goodWithChild?"1":"0",
        'leashed': leashed?"1":"0"
      };
      // build filter instance
      Filter filter = Filter(selectedBreed, toInt(goodWithAnimal), toInt(goodWithChild), toInt(leashed), selectedType, selectedAvail);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Create successful')));
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomeScreen(filter: filter, useFilter: true),
          ),
        );

      });
    }
  }
}