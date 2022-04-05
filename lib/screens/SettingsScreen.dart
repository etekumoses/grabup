import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grabup/screens/HomeScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grabup/AllText.dart';
import 'package:grabup/screens/AboutUs.dart';
import 'package:grabup/screens/ContactUsScreen.dart';
import 'package:grabup/screens/LoginScreen.dart';
import 'package:grabup/screens/TermAndConditions.dart';
import 'package:grabup/screens/UpdateProfileScreen.dart';
import 'package:grabup/screens/base/custom_app_bar.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String path = "";
  final picker = ImagePicker();
  String imageUrl;
  String fname, lname, email;
  List<OptionsList> list = [];

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        imageUrl = value.getString("profile_pic");
        fname = value.getString("f_name");
        lname = value.getString("l_name");
        email = value.getString("email");
      });
    });
    list.add(OptionsList(
        OTHER_SETTINGS,
        [TERM_AND_CONDITION, ABOUT_US, CONTACT_US],
        [TermAndConditions(), AboutUs(), ContactUsScreen()]));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: LIGHT_GREY_SCREEN_BG,
        appBar: CustomAppBar(
          title: 'Settings',
          isCenter: true,
          isBackButtonExist: false,
          isElevation: false,
        ),
        body: body(),
      ),
    );
  }

  body() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [profileCard(), optionsList()],
        ),
      ),
    );
  }

  profileCard() {
    print(imageUrl);
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), color: LIME),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/placeholder.jpg',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    image: imageUrl != null
                        ? SERVER_ADDRESS +
                            '/storage/app/public/profile/' +
                            imageUrl
                        : "assets/placeholder.jpg",
                    imageErrorBuilder: (c, o, s) => Image.asset(
                        'assets/placeholder.jpg',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Container(
                height: 110,
                width: 110,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () async {
                      bool check = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateProfileScreen()));
                      if (check) {
                        await SharedPreferences.getInstance().then((value) {
                          setState(() {
                            imageUrl = value.getString("profile_pic");
                            fname = value.getString("f_name");
                            lname = value.getString("l_name");
                          });
                        });
                      }
                    },
                    child: fname != null
                        ? Image.asset(
                            "assets/loginregister/edit.png",
                            height: 35,
                            width: 35,
                            fit: BoxFit.fill,
                          )
                        : Container(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          fname != null
              ? Text(
                  fname.toUpperCase(),
                  style: TextStyle(
                      color: WHITE, fontSize: 13, fontWeight: FontWeight.w700),
                )
              : InkWell(
                  onTap: () {
                    if (fname == null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    }
                  },
                  child: Container(
                    height: 25,
                    width: MediaQuery.of(context).size.width * .2,
                    decoration: BoxDecoration(
                        color: WHITE, borderRadius: BorderRadius.circular(13)),
                    child: Center(
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            fontSize: 12,
                            color: LIME,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
          SizedBox(
            height: 5,
          ),
          fname == null
              ? Container()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email_outlined,
                      color: WHITE,
                      size: 12,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      email,
                      style: TextStyle(
                          color: WHITE,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
          fname == null
              ? Container()
              : SizedBox(
                  height: 8,
                ),
          fname != null
              ? InkWell(
                  onTap: () {
                    messageDialog(ALERT, ARE_YOU_SURE_TO_LOG_OUT);
                  },
                  child: Container(
                    height: 25,
                    width: MediaQuery.of(context).size.width * .2,
                    decoration: BoxDecoration(
                        color: WHITE, borderRadius: BorderRadius.circular(13)),
                    child: Center(
                      child: Text(
                        LOG_OUT,
                        style: TextStyle(
                            fontSize: 12,
                            color: LIME,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                )
              : Container(),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

  optionsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  list[index].title,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Divider(
              color: LIGHT_GREY_TEXT,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: list[index].options.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => list[index].screen[i]));
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            list[index].options[i].toString(),
                            style: TextStyle(
                                fontSize: 17,
                                color: LIGHT_GREY_TEXT,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: LIGHT_GREY_TEXT,
                            size: 15,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        setState(() {
          path = File(pickedFile.path).path;
        });
      } else {
        print('No image selected.');
      }
    });
  }

  messageDialog(String s1, String s2) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              elevation: 0,
              backgroundColor: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10.0),
                  Container(
                      decoration:
                          BoxDecoration(color: ERROR, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.check, size: 30, color: Colors.white),
                      )),
                  SizedBox(height: 15),
                  Text(s2),
                  SizedBox(height: 10),
                  Divider(
                    height: 1,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: InkWell(
                      highlightColor: Colors.grey[200],
                      onTap: () async {
                        await SharedPreferences.getInstance().then((value) {
                          value.clear();
                        });
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TabBarScreen()));
                      },
                      child: Center(
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: InkWell(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      highlightColor: Colors.grey[200],
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
        });
  }
}

class OptionsList {
  String title;
  List<String> options;
  List<Widget> screen;

  OptionsList(this.title, this.options, this.screen);
}
