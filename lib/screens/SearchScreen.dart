import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:grabup/modals/SearchJob.dart';
import 'package:grabup/screens/JobDetailsScreen.dart';

import '../AllText.dart';
import '../main.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchJob searchJob;
  bool isSearching = false;
  ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;
  String nextPageUrl = "";
  String keyword = "";
  List<InnerData> myList = [];
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      print(scrollController.position.pixels);
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isLoadingMore) {
        print("Loadmore");
        _loadMoreFunc();
      }
    });
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: LIGHT_GREY_SCREEN_BG,
        appBar: AppBar(
          flexibleSpace: header(),
          backgroundColor: WHITE,
          leading: Container(),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 60),
            child: Container(
              height: 50,
              margin: EdgeInsets.all(10),
              child: TextField(
                focusNode: focusNode,
                decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    hintText: SEARCH_HERE_JOB,
                    suffixIcon: IconButton(
                      icon: Image.asset(
                        "assets/homescreen/search_header.png",
                        height: 25,
                        width: 25,
                      ),
                      onPressed: () {
                        searchjobs(keyword);
                      },
                    )),
                onChanged: (val) {
                  setState(() {
                    keyword = val;
                  });
                  searchjobs(val);
                },
                onSubmitted: (val) {
                  searchjobs(val);
                },
              ),
            ),
          ),
        ),
        body: searchJob == null
            ? Container()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: myList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        JobDetailsScreen()));
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
                                    imageUrl: Uri.parse(myList[index].image)
                                        .toString(),
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Container(
                                                child: Center(
                                                    child: Icon(Icons.image))),
                                    errorWidget: (context, url, error) =>
                                        Container(
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
                    nextPageUrl != "null"
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(5),
                            child: Text(
                              'Loading...',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: LIME,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 50,
                          )
                  ],
                ),
              ),
      ),
    );
  }

  header() {
    return SafeArea(
      child: Container(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 18,
                      color: BLACK,
                    ),
                    constraints: BoxConstraints(maxWidth: 30, minWidth: 10),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    SEARCH,
                    style: TextStyle(
                        color: BLACK,
                        fontSize: 25,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  searchjobs(String keyword) async {
    setState(() {
      isSearching = true;
    });

    final response =
        await get(Uri.parse("$SERVER_ADDRESS/api/v1/searchterm?term=$keyword"));

    final jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonResponse['status'] == 1) {
      setState(() {
        searchJob = null;
        myList.clear();
        searchJob = SearchJob.fromJson(jsonResponse);
        myList.addAll(searchJob.data[0].data);
        isSearching = false;
        print(searchJob.data[0].data);
        nextPageUrl = searchJob.data[0].nextPageUrl;
      });
    }
  }

  void _loadMoreFunc() async {
    if (nextPageUrl != "null") {
      setState(() {
        isLoadingMore = true;
      });

      final response = await get(Uri.parse("$nextPageUrl&term=$keyword"));

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['status'] == 1) {
        setState(() {
          searchJob = SearchJob.fromJson(jsonResponse);
          isSearching = false;
          myList.addAll(searchJob.data[0].data);
          isLoadingMore = false;
        });
      }
    }
  }
}
