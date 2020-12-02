import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/models/Filter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/models/Breed.dart';
import 'package:flutter_app/models/Disposition.dart';
import 'dart:convert';
import 'package:flutter_app/screens/home/home_screen.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:io';
import 'dart:typed_data';


class AddProfilePage extends StatefulWidget {
  AddProfilePage({Key key}) : super(key: key);

  @override
  AddProfilePageState createState() {
    return new AddProfilePageState();
  }
}

class AddProfilePageState extends State<AddProfilePage> {
  List<Breed> dogBreeds = List<Breed>();
  List<Breed> catBreeds = List<Breed>();
  List<Breed> otherBreeds = List<Breed>();
  List<Breed> breedsOptions;
  TextEditingController _petnameController=new TextEditingController();
  TextEditingController _descriptionController=new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String selectedType = "dog";
  String selectedAvail = "Available";
  int selectedBreed = 0;
  bool goodWithAnimal = true;
  bool goodWithChild = true;
  bool leashed = true;
  bool isSaving=false; // for double click
  Uint8List _imageBytesFromPicker;
  // Friend _selectedFriend = null;

  Future<String> fetchBreeds() async {
    final response = await http.get(BREEDS, headers: {"Accept": "application/json"});
    List<Breed> breeds;
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var breedObjsJson = jsonDecode(response.body) as List;
      breeds = breedObjsJson.map((breedJson) => Breed.fromJson(breedJson)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
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

    //print(dogBreeds);
    return "Success";
  }

  @override
  void initState() {
    super.initState();
    this.fetchBreeds();
  }

  static AddProfilePageState of(BuildContext context) {
    return context.findAncestorStateOfType<AddProfilePageState>();
  }

  @override
  Widget build(BuildContext context) {
    if (breedsOptions == null) {
      return Scaffold(appBar: AppBar(
        title: Text("Add a profile"),
        leading: CloseButton(),
        actions: <Widget>[
          Builder(
            builder: (context) => FlatButton(
              child: Text("SAVE"),
              textColor: Colors.white,
              onPressed: () {
                if (isSaving) {
                  return;
                }
                AddProfilePageState.of(context).save(context);
              },
            ),
          ),
        ],
      ), body: LinearProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a profile"),
        leading: CloseButton(),
        actions: <Widget>[
          Builder(
            builder: (context) => FlatButton(
              child: Text("SAVE"),
              textColor: Colors.white,
              onPressed: () {
                if (isSaving) {
                  return;
                }
                AddProfilePageState.of(context).save(context);
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
                  Text("Pet Name:"),
                  Container(
                    height: 16.0,
                  ),
                  TextFormField(
                    maxLines: 1,
                    controller: _petnameController,
                    // inputFormatters: [LengthLimitingTextInputFormatter(200)],
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Pet name cannot be empty";
                      }
                      return null;
                    },
                  ),
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
                  Text("Upload image:"),
                  Container(
                    height: 16.0,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        final img = await ImagePickerWeb.getImage(outputType: ImageType.bytes);
                        setState(() {
                          _imageBytesFromPicker = img;
                        });
                      },
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Color(0xffFDCF09),
                        child: _imageBytesFromPicker != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: new Image.memory(_imageBytesFromPicker),
                        )
                            : Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50)),
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text("Status description:"),
                  Container(
                    height: 16.0,
                  ),
                  TextFormField(
                    maxLines: 5,
                    controller: _descriptionController,
                    // inputFormatters: [LengthLimitingTextInputFormatter(200)],
                    validator: (value) {
                      if (value.isEmpty) {
                        return "You must detail the status";
                      }
                      return null;
                    },
                  ),
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
      title: Text('Good with other animals'),
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
    // var breeds = dogBreeds;
    // if (selectedType == 'cat') {
    //   breeds = catBreeds;
    // }
    // else if (selectedType == 'other') {
    //   breeds = otherBreeds;
    // }
    //print(breeds);

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
      items: <String>['Available', 'Not Available', 'Pending', 'Adopted']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }



  void save(context) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (_formKey.currentState.validate()) {
      // store the favor request on firebase
      // Navigator.pop(context);
      // if (_formKey.currentState.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.

      setState(() {
        isSaving=true;
      });
      Scaffold
          .of(context)
          .showSnackBar(SnackBar(content: Text('Processing Data')));

      Map data = {
        'petName': _petnameController.text,
        'type': selectedType,
        'shelterID': preferences.getInt("userID").toString(),
        'breedID': selectedBreed.toString(),
        'availability': selectedAvail,
        'description': _descriptionController.text,
        'goodWithAnimal': goodWithAnimal?"1":"0",
        'goodWithChild': goodWithChild?"1":"0",
        'leashed': leashed?"1":"0"
      };
      print(data.toString());
      print(PROFILE_ADD);
      final  response= await http.post(
        PROFILE_ADD,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer " + preferences.getString('token')
        },
        body: data,
        //encoding: Encoding.getByName("utf-8")
      );
      print(PROFILE_ADD);
      if (response.statusCode == 200) {
        Map<String,dynamic>responseMap=jsonDecode(response.body);

        print(responseMap.toString());


        if(responseMap['status'].compareTo("success") == 0)
        {
          Map imgData = {
            "picUrl":base64.encode(_imageBytesFromPicker),
            "profileID":responseMap['profileID'].toString()
          };

          final  responseImg = await http.post(
            PICTURE_ADD,
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer " + preferences.getString('token')
            },
            body: imgData,
            //encoding: Encoding.getByName("utf-8")
          );


          Filter filter = Filter(1, 1, 1, 1, "cat", "available");     // dummy filter instance, not used
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Create successful')));
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomeScreen(filter: filter, useFilter: false),   // add params
              ),
            );

          });

        }else{
          //print(" ${resposne['message']}");
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(responseMap['reason'])));
          setState(() {
            isSaving=false;
          });
        }
      } else {
        print(response.statusCode.toString());
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Error, Please try again!")));
        setState(() {
          isSaving=false;
        });
      }
      // final snackBar = SnackBar(content: Text('Are you talkin\' to me?'));
      // _scaffoldKey.currentState.showSnackBar(snackBar);

    }
    // }
  }
}