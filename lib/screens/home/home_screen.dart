import 'package:flutter/material.dart';
import 'package:flutter_app/models/Filter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_app/screens/home/components/body.dart';
import 'package:flutter_app/screens/menu/add_profile_screen.dart';
import 'package:flutter_app/screens/menu/search_screen.dart';
import 'package:flutter_app/screens/home/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  final Filter filter;
  final bool useFilter;
  HomeScreen({Key key, this.filter, this.useFilter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      appBar: buildAppBar(),
      body: Body(filter: filter, useFilter: useFilter),
      drawer: SideMenu(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      // leading: IconButton(
      //   icon: SvgPicture.asset("assets/icons/menu.svg"),
      //   onPressed: () {},
      // ),
    );
  }
}

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Hello!'),
            decoration: BoxDecoration(
              // color: Colors.pink[50],
              color: Color(0xFFFE8F88),
            ),
          ),
          ListTile(
            title: Text('Add Profile'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              // Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddProfilePage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Search'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchPage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Log Out'),
            onTap: () async {
                SharedPreferences preferences = await SharedPreferences.getInstance();
                preferences.clear();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
            },
          ),
        ],
      ),
    );
  }
}
