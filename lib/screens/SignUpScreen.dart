import 'dart:io';

import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grabup/AllText.dart';
import 'package:grabup/screens/base/custom_app_bar.dart';

import '../main.dart';
import 'LoginScreen.dart';
import 'base/custom_snackbar.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String f_name = "";
   String l_name = "";
  String emailAddress = "";
  String phoneNumber = "";
  String password = "";
  String confirmPassword = "";
  String path = "";
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: WHITE,
        body: body(),
      ),
    );
  }

  body() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        'assets/icon.png',
                        height: MediaQuery.of(context).size.height / 7.5,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                      child: Text(
                    'Let\'s Get Started!',
                    style: TextStyle(
                        color: BLACK,
                        fontSize: 25,
                        fontWeight: FontWeight.w800),
                  )),
                  SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Create an account to get exciting features',
                      style: TextStyle(
                          color: LIGHT_GREY_TEXT,
                          fontSize: 12,
                          fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: Container(
                              height: 140,
                              width: 140,
                              child: path.isEmpty
                                  ? Icon(
                                      Icons.account_circle,
                                      size: 150,
                                      color: LIGHT_GREY_TEXT,
                                    )
                                  : Image.file(
                                      File(path),
                                      height: 140,
                                      width: 140,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Container(
                            height: 137,
                            width: 137,
                            child: InkWell(
                              onTap: () {
                                showSheet();
                              },
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Image.asset(
                                  "assets/loginregister/edit.png",
                                  height: 35,
                                  width: 35,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          FNAME,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Enter your first name";
                            }
                            return null;
                          },
                          onSaved: (val) => f_name = val,
                          style: TextStyle(
                            color: LIGHT_GREY_TEXT,
                          ),
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: EdgeInsets.all(5),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                            disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                          ),
                          onChanged: (val) {
                            setState(() {
                              f_name = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          LNAME,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Enter your last name";
                            }
                            return null;
                          },
                          onSaved: (val) => l_name = val,
                          style: TextStyle(
                            color: LIGHT_GREY_TEXT,
                          ),
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: EdgeInsets.all(5),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                            disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                          ),
                          onChanged: (val) {
                            setState(() {
                              l_name = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          EMAIL_ADDRESS,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Enter your email address";
                            } else if (!EmailValidator.validate(val)) {
                              return "Enter correct email";
                            }
                            return null;
                          },
                          onSaved: (val) => emailAddress = val,
                          style: TextStyle(
                            color: LIGHT_GREY_TEXT,
                          ),
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: EdgeInsets.all(5),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                            disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                          ),
                          onChanged: (val) {
                            setState(() {
                              emailAddress = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          PHONE_NUMBER,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Enter your phone number";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          onSaved: (val) => phoneNumber = val,
                          style: TextStyle(
                            color: LIGHT_GREY_TEXT,
                          ),
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: EdgeInsets.all(5),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                            disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                          ),
                          onChanged: (val) {
                            setState(() {
                              phoneNumber = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          PASSWORD,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        TextFormField(
                          obscureText: true,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Enter your password";
                            }
                            return null;
                          },
                          onSaved: (val) => password = val,
                          style: TextStyle(
                            color: LIGHT_GREY_TEXT,
                          ),
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: EdgeInsets.all(5),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                            disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                          ),
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          CONFIRM_PASSWORD,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        TextFormField(
                          obscureText: true,
                          validator: (val) {
                            if (val.isEmpty) {
                              return "Enter your password";
                            } else if (val != password) {
                              return "Password mismatch";
                            }
                            return null;
                          },
                          onSaved: (val) => confirmPassword = val,
                          style: TextStyle(
                            color: LIGHT_GREY_TEXT,
                          ),
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: EdgeInsets.all(5),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                            disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: LIGHT_GREY_TEXT,
                              width: 0.5,
                            )),
                          ),
                          onChanged: (val) {
                            setState(() {
                              confirmPassword = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          button(),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account? ",
                style: TextStyle(color: LIGHT_GREY_TEXT, fontSize: 12),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text(
                  LOGIN,
                  style: TextStyle(
                      color: NAVY_BLUE,
                      fontSize: 13,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  button() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              if (formKey.currentState.validate()) {
                formKey.currentState.save();
                createAccount();
              }
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: LIME,
              ),
              child: Center(
                child: Text(
                  REGISTER,
                  style: TextStyle(
                      color: WHITE, fontWeight: FontWeight.w700, fontSize: 17),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  final picker = ImagePicker();

  Future getImage({bool fromGallery = false}) async {
    final pickedFile = await picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera);

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

  createAccount() async {
    if (path.isEmpty) {
      showCustomSnackBar(IMAGE_NOT_SELECTED, context);
    } else {
      processingDialog(PLEASE_WAIT_WHILE_CREATING_ACCOUNT);
      Response response;
      Dio dio = new Dio();

      FormData formData = FormData.fromMap({
        "f_name": f_name,
        "l_name": l_name,
        "email": emailAddress,
        "password": password,
        "phone": phoneNumber,
        "image": await MultipartFile.fromFile(path, filename: "profile.png"),
      });
      response =
          await dio.post(SERVER_ADDRESS + "/api/v1/auth/register", data: formData);
      if (response.statusCode == 200 && response.data['status'] == 1) {
        print(response.toString());
        // FirebaseDatabase.instance
        //     .reference()
        //     .child(response.data['data']['id'].toString())
        //     .set({
        //   "f_name": response.data['data']['f_name'],
        //   "l_name": response.data['data']['l_name'],
        //   "profile": "profile/" +
        //       response.data['data']['profile_pic'].toString().split("/").last,
        // }).then((value) async {
        //   print("\n\nData added in cloud firebase\n\n");
        //   FirebaseDatabase.instance
        //       .reference()
        //       .child(response.data['data']['user_sid'].toString())
        //       .child("TokenList")
        //       .set({"device": await firebaseMessaging.getToken()}).then(
        //           (value) async {
        //     print("\n\nData added in firebase database\n\n");
        //     await SharedPreferences.getInstance().then((value) {
        //       value.setBool("isLoggedIn", true);
        //       value.setString("f_name", response.data['data']['f_name']);
        //       value.setString("l_name", response.data['data']['l_name']);
        //       value.setString("email", response.data['data']['email']);
        //       value.setString("phone_no", response.data['data']['phone_no']);
        //       value.setString("password", password);

        //       value.setString("profile_pic",
        //           response.data['data']['profile_pic'].toString());
        //       value.setInt("id", response.data['data']['id']);
        //       value.setString("uid", response.data['data']['id'].toString());
        //     });

        //     print("\n\nData added in device\n\n");

        //     Navigator.popUntil(context, (route) => route.isFirst);
        //     Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => TabBarScreen(),
        //         ));
        //   }).catchError((e) {
        //     Navigator.pop(context);
        //     showCustomSnackBar(e, context);
        //   });
        // }).catchError((e) {
        //   Navigator.pop(context);
          
        //   showCustomSnackBar(e.toString(), context);
        // });
        Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ));
      } else {
        Navigator.pop(context);
        print("Error" + response.toString());
        showCustomSnackBar(response.data['msg'], context);
      }
    }
  }

 
  processingDialog(message) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(LOADING),
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(color: LIGHT_GREY_TEXT, fontSize: 14),
                  ),
                )
              ],
            ),
          );
        });
  }

  showSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  TAKE_A_PICTURE,
                ),
                leading: CircleAvatar(
                  backgroundColor: LIME,
                  child: Center(
                    child: Icon(
                      Icons.camera_alt,
                      color: WHITE,
                    ),
                  ),
                ),
                subtitle: Text(
                  TAKE_A_PICTURE_DESC,
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  getImage(fromGallery: false);
                },
              ),
              ListTile(
                title: Text(
                  PICK_FROM_GALLERY,
                ),
                leading: CircleAvatar(
                  backgroundColor: LIME,
                  child: Center(
                    child: Icon(
                      Icons.photo,
                      color: WHITE,
                    ),
                  ),
                ),
                subtitle: Text(
                  PICK_FROM_GALLERY_desc,
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  getImage(fromGallery: true);
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: LIME,
                        ),
                        child: Center(
                          child: Text(
                            CANCEL,
                            style: TextStyle(
                                color: WHITE,
                                fontWeight: FontWeight.w700,
                                fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        });
  }
}
