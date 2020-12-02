import 'package:flutter/material.dart';
import 'package:flutter_app/models/Profile.dart';
import '../../../constants.dart';

class ProfileTitleWithImage extends StatelessWidget {
  const ProfileTitleWithImage({
    Key key,
    @required this.profile,
  }) : super(key: key);

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            profile.petName,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: kDefaultPadding),
          Row(
            children: <Widget>[
              SizedBox(width: kDefaultPadding),
              Expanded(child: Image.memory(profile.image, fit: BoxFit.fill))
            ],
          )
        ],
      ),
    );
  }
}


