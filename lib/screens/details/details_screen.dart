import 'package:flutter/material.dart';
import 'package:flutter_app/models/Profile.dart';
import 'package:flutter_app/screens/details/components/body.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants.dart';

class DetailsScreen extends StatelessWidget {
  final Profile profile;

  const DetailsScreen({Key key, this.profile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Body(profile: profile),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFfeffff),
      elevation: 0,
      leading: IconButton(
        icon: Image.asset('icons/backarrow.jpg'),
        // icon: SvgPicture.asset(
        //   'icons/back_arrow.svg',
        //   color: Colors.black,
        // ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
        // IconButton(
        //     icon: SvgPicture.asset("assets/icons/search.svg"),
        //     onPressed: () {}),
        SizedBox(width: kDefaultPadding / 2)
      ],
    );
  }
}