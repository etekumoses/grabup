import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grabup/screens/SignUpScreen.dart';
import 'package:grabup/screens/base/custom_snackbar.dart';
import '../AllText.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String name = "";
  String email = "";
  String password = "";
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final formKey = GlobalKey<FormState>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String image = "";

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
    return SafeArea(
        child: Scrollbar(
            child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
                physics: BouncingScrollPhysics(),
                child: Center(
                    child: SizedBox(
                        width: 1170,
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Image.asset(
                                    'assets/icon.png',
                                    height: MediaQuery.of(context).size.height /
                                        7.5,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Center(
                                  child: Text(
                                'Welcome!',
                                style: TextStyle(
                                    color: BLACK,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800),
                              )),
                              SizedBox(height: 12),
                              Center(
                                child: Text(
                                  'Add your account details to login',
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
                              Text(
                                EMAIL_ADDRESS,
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextFormField(
                                validator: (val) {
                                  if (!EmailValidator.validate(email)) {
                                    return "Enter correct email";
                                  }
                                  return null;
                                },
                                onSaved: (val) => email = val,
                                style: TextStyle(
                                    color: LIGHT_GREY_TEXT,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  isCollapsed: true,
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: LIGHT_GREY_TEXT, width: 0.5)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: LIGHT_GREY_TEXT, width: 0.5)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: LIGHT_GREY_TEXT, width: 0.5)),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    email = val;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                PASSWORD,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextFormField(
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return "Enter your password";
                                  }
                                  return null;
                                },
                                onSaved: (val) => password = val,
                                style: TextStyle(
                                    color: LIGHT_GREY_TEXT,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                                obscureText: true,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  isCollapsed: true,
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: LIGHT_GREY_TEXT, width: 0.5)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: LIGHT_GREY_TEXT, width: 0.5)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: LIGHT_GREY_TEXT, width: 0.5)),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                },
                              ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // GestureDetector(
                              //   onTap: () {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) =>
                              //                 ForgetPassword()));
                              //   },
                              //   child: Align(
                              //     alignment: Alignment.centerRight,
                              //     child: Text(
                              //       FORGET_PASSWORD,
                              //       style: TextStyle(
                              //           color: NAVY_BLUE,
                              //           fontSize: 12,
                              //           fontWeight: FontWeight.bold),
                              //     ),
                              //   ),
                              // ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        if (formKey.currentState.validate()) {
                                          formKey.currentState.save();
                                          loginIntoAccount(email, password);
                                        }
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(15, 5, 15, 15),
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: LIME,
                                        ),
                                        child: Center(
                                          child: Text(
                                            LOGIN,
                                            style: TextStyle(
                                                color: WHITE,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: TextStyle(
                                        color: LIGHT_GREY_TEXT, fontSize: 12),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpScreen()),
                                      );
                                    },
                                    child: Text(
                                      REGISTER,
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
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: Divider(
                              //         color: LIGHT_GREY_TEXT,
                              //       ),
                              //     ),
                              //     SizedBox(
                              //       width: 5,
                              //     ),
                              //     Text(
                              //       OR,
                              //       style: TextStyle(
                              //           color: LIGHT_GREY_TEXT,
                              //           fontWeight: FontWeight.bold,
                              //           fontSize: 17),
                              //     ),
                              //     SizedBox(
                              //       width: 5,
                              //     ),
                              //     Expanded(
                              //       child: Divider(
                              //         color: LIGHT_GREY_TEXT,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(
                              //   height: 20,
                              // ),

                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: InkWell(
                              //         borderRadius: BorderRadius.circular(50),
                              //         onTap: () {
                              //           googleLogin();
                              //         },
                              //         child: Container(
                              //           margin:
                              //               EdgeInsets.fromLTRB(15, 5, 15, 5),
                              //           height: 50,
                              //           decoration: BoxDecoration(
                              //             borderRadius:
                              //                 BorderRadius.circular(25),
                              //             color: NAVY_BLUE.withOpacity(0.7),
                              //           ),
                              //           child: Stack(
                              //             children: [
                              //               Row(
                              //                 children: [
                              //                   Expanded(
                              //                     child: Image.asset(
                              //                       "assets/loginregister/google_btn.png",
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ),
                              //               Center(
                              //                 child: Text(
                              //                   CONTINUE_WITH_GOOGLE,
                              //                   style: TextStyle(
                              //                       color: WHITE,
                              //                       fontSize: 16,
                              //                       fontWeight:
                              //                           FontWeight.bold),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     )
                              //   ],
                              // ),
                              // SizedBox(
                              //   height: 20,
                              // ),
                              // Platform.isIOS
                              //     ? Row(
                              //         children: [
                              //           Expanded(
                              //             child: Container(
                              //               margin: EdgeInsets.fromLTRB(
                              //                   15, 5, 15, 5),
                              //               height: 50,
                              //               decoration: BoxDecoration(
                              //                 borderRadius:
                              //                     BorderRadius.circular(25),
                              //                 color: NAVY_BLUE.withOpacity(0.7),
                              //               ),
                              //               child: Stack(
                              //                 children: [
                              //                   Row(
                              //                     children: [
                              //                       Expanded(
                              //                         child: Image.asset(
                              //                           "assets/loginregister/appleid.png",
                              //                         ),
                              //                       ),
                              //                     ],
                              //                   ),
                              //                   Center(
                              //                     child: Text(
                              //                       CONTINUE_WITH_APPLE_ID,
                              //                       style: TextStyle(
                              //                           color: WHITE,
                              //                           fontSize: 16,
                              //                           fontWeight:
                              //                               FontWeight.bold),
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ),
                              //             ),
                              //           )
                              //         ],
                              //       )
                              //     : Container(),
                            ],
                          ),
                        ))))));
  }

  errorDialog(message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
                Icon(
                  Icons.error,
                  size: 80,
                  color: Colors.red,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  message.toString(),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
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

  loginIntoAccount(String email, String password) async {
    processingDialog(PLEASE_WAIT_WHILE_LOGGING_INTO_ACCOUNT);
    // Response response;
    Dio dio = new Dio();

    FormData formData = FormData.fromMap({
      "email": email,
      "password": password,
    });
    print(formData);
    // response = await dio
    //     .post(SERVER_ADDRESS + "/api/v1/auth/login", data: formData)
    //     .catchError((e) {
    //   print("ERROR : $e");
    //   if (type == 2) {
    //     googleLogin();

    //   } else {
    //     Navigator.pop(context);
    //     print("Error" + e.toString());
    //     showCustomSnackBar('Invalid login details', context);
    //   }

    // });
    final response =
        await http.post(Uri.parse(SERVER_ADDRESS + "/api/v1/auth/login"),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/x-www-form-urlencoded"
            },
            body: {"email": email, "password": password},
            encoding: Encoding.getByName("utf-8"));
    Map<String, dynamic> resp = jsonDecode(response.body);
    print(resp);
    if (response != null && response.statusCode == 200 && resp['status'] == 1) {
      await SharedPreferences.getInstance().then((value) {
        value.setBool("isLoggedIn", true);
        value.setString("f_name", resp['data']['f_name'] ?? "");
        value.setString("email", resp['data']['email'] ?? "");
        value.setString("l_name", resp['data']['l_name'] ?? "");
        value.setString("profile_pic", resp['data']['image'] ?? "");
        value.setInt("id", resp['data']['id']);
        value.setString("phone", resp['data']['phone'] ?? "");
        value.setString("token", resp['token'] ?? "");
        value.setString(
            "cm_firebase_token", resp['data']['cm_firebase_token'] ?? "");
      }).then((value) {
        print("\n\nData added in device\n\n");
        print(resp['data']['image']);
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TabBarScreen(),
            ));
      });
    } else {
      Navigator.pop(context);
      print("Error" + response.statusCode.toString());
      showCustomSnackBar(resp['msg'], context);
    }
  }

  googleLogin() async {
    await _googleSignIn.signIn().then((value) {
      value.authentication.then((googleKey) {
        print(googleKey.idToken);
        print(googleKey.accessToken);
        print(value.email);
        print(value.displayName);
        print(value.photoUrl);
        setState(() {
          name = value.displayName;
          email = value.email;
          image = value.photoUrl;
        });

        // loginIntoAccount();
      }).catchError((e) {
        print(e.toString());
        showCustomSnackBar('Something went wrong. Try again!', context);
      });
    }).catchError((e) {
      print(e.toString());
      showCustomSnackBar('Something went wrong. Try again!', context);
    });
  }
}
