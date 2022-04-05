import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grabup/AllText.dart';
import 'package:grabup/main.dart';
import 'package:grabup/modals/JobsList.dart';
import 'package:grabup/screens/PostProject.dart';
import 'package:grabup/screens/JobDetailsScreen.dart';
import 'package:grabup/screens/LoginScreen.dart';
import 'package:grabup/screens/SearchScreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  JobsList jobsList;
  ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;
  List<InnerData> myList = [];
  String nextUrl = "";
  String myUid = "";
  String f_name = "";
  Timer timer;

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    fetchjobsList();
    // get details
    SharedPreferences.getInstance().then((value) {
      setState(() {
        isLoggedIn = value.getBool("isLoggedIn") ?? false;
        myUid = value.getString("uid");
        f_name = value.getString('f_name');
      });
    });

    WidgetsBinding.instance.addObserver(this);
    scrollController.addListener(() {
      print(scrollController.position.pixels);
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isLoadingMore) {
        print("Loadmore");
        _loadMoreFunc();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: LIGHT_GREY_SCREEN_BG,
        appBar: AppBar(
          title: Text('GrabUp',
              style: TextStyle(
                  fontSize: 17, color: LIME, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: LIGHT_GREY_SCREEN_BG,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: body(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: new FloatingActionButton.extended(
          onPressed: () {
            if (f_name == null) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PostProject()),
              );
            }
          },
          backgroundColor: LIME,
          icon: Icon(
            Icons.add,
            color: WHITE,
          ),
          label: Text("POST AD",
              style: TextStyle(
                  fontSize: 16, color: WHITE, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

 
  body() {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ));
            },
            child: Container(
              margin: EdgeInsets.all(10),
              height: 180,
              decoration: BoxDecoration(
                  color: LIME, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        f_name != null
                            ? WELCOME + ' ' + f_name.toUpperCase()
                            : WELCOME,
                        style: TextStyle(
                          fontSize: 10,
                          color: WHITE,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        DISCOVER,
                        style: TextStyle(
                            fontSize: 17,
                            color: WHITE,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        PERFECT_JOB,
                        style: TextStyle(
                            fontSize: 17,
                            color: WHITE,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: isLoggedIn ? 120 : 130,
                        height: 28,
                        child: Stack(
                          children: [
                            Image.asset(
                              "assets/homescreen/bookappointment.png",
                              width: isLoggedIn ? 120 : 130,
                              height: 28,
                              fit: BoxFit.fill,
                            ),
                            Center(
                              child: Text(
                                EXPLORE,
                                style: TextStyle(
                                    fontSize: 9,
                                    color: LIME,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    margin: EdgeInsets.all(14),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/homescreen/bannerimage.png",
                        height: MediaQuery.of(context).size.height * .2,
                        width: MediaQuery.of(context).size.width * .3,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          jobsList == null
              ? Container()
              : GridView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: myList.length,
                  padding: EdgeInsets.all(15),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    JobDetailsScreen(jobsList: myList[index])));
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: WHITE,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                imageUrl:
                                    Uri.parse(myList[index].image).toString(),
                                progressIndicatorBuilder: (context, url,
                                        downloadProgress) =>
                                    Container(
                                        child:
                                            Center(child: Icon(Icons.image))),
                                errorWidget: (context, url, error) => Container(
                                  child: Center(
                                    child: Icon(Icons.broken_image_rounded),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              myList[index].title,
                              style: TextStyle(
                                  color: NAVY_BLUE,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              myList[index].company,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: LIGHT_GREY_TEXT,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_sharp,
                                  size: 8,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  myList[index].country,
                                  style: TextStyle(
                                      color: LIGHT_GREY_TEXT,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w300),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Icon(Icons.work_off, size: 8),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  myList[index].workType,
                                  style: TextStyle(
                                      color: LIGHT_GREY_TEXT,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w300),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 25,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: LIME,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(13)),
                                    child: Center(
                                      child: Text(
                                        DETAILS,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: LIME,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          nextUrl != "null"
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(5),
                  child: SpinKitRipple(color: LIME))
              : Container(),
        ],
      ),
    );
  }

  // fetching jobs from server
  fetchjobsList() async {
    final response =
        await http.get(Uri.parse("$SERVER_ADDRESS/api/v1/listofjobs"));
    print("========");
    print(response);
    print("========");
    final jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonResponse['status'] == 1) {
      print('==body====');
      print(response.body[0].length);
      print('==end===');

      setState(() {
        jobsList = JobsList.fromJson(jsonDecode(response.body));
        myList.addAll(jobsList.data[0].data);
        nextUrl = jobsList.data[0].nextPageUrl;
      });
      print('========');
      print(myList);
      print('=======');
    }
  }

  void _loadMoreFunc() async {
    print(nextUrl);
    if (nextUrl != "null" && !isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });

      final response = await get(
        Uri.parse("$nextUrl"),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['status'] == 1) {
        print(response.body);
        jobsList = JobsList.fromJson(jsonDecode(response.body));
        setState(() {
          myList.addAll(jobsList.data[0].data);
          nextUrl = jobsList.data[0].nextPageUrl;
          isLoadingMore = false;
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    print("\n\nLifecycle state $state");
  }

  checkIfLoggedInFromAnotherDevice() async {}

  alertDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: _willPopScope,
            child: Dialog(
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
                          child:
                              Icon(Icons.check, size: 30, color: Colors.white),
                        )),
                    SizedBox(height: 15),
                    Text('Your account is logged In from another device'),
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
                                  builder: (context) => LoginScreen()));
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
                  ],
                )),
          );
        });
  }

  Future<bool> _willPopScope() async {
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
    return false;
  }
}
