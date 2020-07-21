import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta/helpers/firebase_auth.dart';
import 'package:insta/models/profile_model.dart';
import 'package:insta/providers/current_user_provider.dart';
import 'package:insta/providers/post_creator_provider.dart';
import 'package:insta/screens/pick_images_screen.dart';
import 'package:provider/provider.dart';

import 'edit_personal_information.dart';

class EditProfile extends StatefulWidget {
  static const route = "/edit_profile";
  @override
  _EditProfileState createState() => _EditProfileState();
}

final _lightGreyBorder = UnderlineInputBorder(
  borderSide: BorderSide(
    color: Colors.grey[300],
  ),
);

class _EditProfileState extends State<EditProfile> {
  final _form = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  bool _isNameEmpty = false;
  bool _isUsernameEmpty = false;
  bool _loadingImage = false;
  bool _loadingProfile = false;

  final _profile = ProfileModel(
    name: "",
    username: "",
    bio: "",
  );

  void _uploadNewImage(CurrentUserProvider currentUser) async {
    List<File> images;
    await Navigator.of(context)
        .pushNamed(
          PickImagesScreen.route,
          arguments: 1,
        )
        .then((value) => images = value);

    if (images == null) return;

    setState(() {
      _loadingImage = true;
    });

    final result = await currentUser.changeProfilePicture(images[0]);
    setState(() {
      _loadingImage = false;
    });

    _key.currentState.showSnackBar(SnackBar(
      content: Text(result
          ? "Profile picture changed"
          : "Could not change profile picture"),
    ));

    if (result) {
      _notifyPosts(currentUser.account.id, null, currentUser.account.image);
      Navigator.of(context).pop();
    }
  }

  void _showSnackBar(String message) {
    _key.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void _updateProfile(CurrentUserProvider currentUser) async {
    if (!_form.currentState.validate()) return;

    _form.currentState.save();

    setState(() {
      _loadingProfile = true;
    });
    bool usernameExist =
        await Auth().checkIfUsernameExists(currentUser.account.username);

    if (usernameExist) {
      _showSnackBar("Username already in use");
      setState(() {
        _loadingProfile = false;
      });
      return;
    }

    bool result = await currentUser.updateProfile(_profile);

    if (result) {
      _notifyPosts(currentUser.account.id, _profile.username, null);
      Navigator.of(context).pop();
    } else
      _showSnackBar("Could not update profile");
  }

  void _notifyPosts(String userId, String username, String image) {
    Provider.of<PostCreatorProvider>(
      context,
      listen: false,
    ).updateCurrentUserPosts(userId, username, image);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentUser = Provider.of<CurrentUserProvider>(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Edit Profile"),
        elevation: 1,
        actions: <Widget>[
          _loadingProfile
              ? Center(
                  child: Container(
                    height: 15,
                    width: 25,
                    padding: EdgeInsets.only(right: 10),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                      strokeWidth: 2,
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    Icons.done,
                    color: !_isNameEmpty && !_isUsernameEmpty
                        ? Colors.blue
                        : Colors.blue[200],
                  ),
                  onPressed: !_isNameEmpty && !_isUsernameEmpty
                      ? () {
                          _updateProfile(currentUser);
                        }
                      : null,
                ),
        ],
      ),
      body: AbsorbPointer(
        absorbing: _loadingImage || _loadingProfile,
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    Container(
                      width: size.width,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              currentUser.account.image,
                            ),
                            radius: size.width * 0.11,
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () async {
                              _uploadNewImage(currentUser);
                            },
                            child: Text(
                              "Change Profile Photo",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Name",
                              labelStyle: TextStyle(color: Colors.grey[300]),
                              focusedBorder: _lightGreyBorder,
                              enabledBorder: _lightGreyBorder,
                            ),
                            textInputAction: TextInputAction.next,
                            initialValue: currentUser.account.name,
                            onChanged: (value) {
                              if (value.isEmpty)
                                setState(() {
                                  _isNameEmpty = true;
                                });
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return "Enter name";
                              else
                                return null;
                            },
                            onSaved: (value) => _profile.name = value,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Username",
                              labelStyle: TextStyle(color: Colors.grey[300]),
                              enabledBorder: _lightGreyBorder,
                              focusedBorder: _lightGreyBorder,
                            ),
                            textInputAction: TextInputAction.next,
                            initialValue: currentUser.account.username,
                            onChanged: (value) {
                              if (value.isEmpty)
                                setState(() {
                                  _isUsernameEmpty = true;
                                });
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return "Enter username";
                              else
                                return null;
                            },
                            onSaved: (value) => _profile.username = value,
                          ),
                          BioField(
                            initialValue: currentUser.account.bio,
                            onSaved: (value) {
                              _profile.bio = value;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    PersonalInfoBanner(),
                  ],
                ),
                if (_loadingImage)
                  Positioned.fill(
                    child: Container(
                      color: Colors.white54,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BioField extends StatefulWidget {
  final void Function(String) onSaved;
  final String initialValue;
  BioField({
    @required this.initialValue,
    @required this.onSaved,
  });
  @override
  _BioFieldState createState() => _BioFieldState();
}

class _BioFieldState extends State<BioField> {
  int currentLength = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentLength = widget.initialValue.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Bio",
        labelStyle: TextStyle(color: Colors.grey[300]),
        focusedBorder: _lightGreyBorder,
        enabledBorder: _lightGreyBorder,
        counterText: "${100 - currentLength}",
      ),
      textInputAction: TextInputAction.done,
      initialValue: widget.initialValue,
      onChanged: (value) {
        setState(() {
          currentLength = value.length;
        });
      },
      onSaved: widget.onSaved,
      maxLength: 100,
    );
  }
}

class PersonalInfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(EditPersonalInformation.route);
      },
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          border: Border.symmetric(
            vertical: BorderSide(
              color: Colors.grey[300],
              width: 0.5,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 18,
        ),
        child: Text(
          "Personal Information Settings",
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }
}
