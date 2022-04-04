import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grabup/modals/JobsList.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grabup/AllText.dart';
import 'package:grabup/main.dart';
import 'package:grabup/modals/JobDetails.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_share/flutter_share.dart';
import 'base/images.dart';

// class JobDetailsScreen extends StatefulWidget {
//   final int id;
//   JobDetailsScreen(this.id);

//   @override
//   _JobDetailsScreenState createState() => _JobDetailsScreenState();
// }

// class _JobDetailsScreenState extends State<JobDetailsScreen> {
//   DoctorDetail jobDetails;
//   bool isLoggedIn = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchJObDetails();
//     SharedPreferences.getInstance().then((value) {
//       isLoggedIn = value.getBool("isLoggedIn") ?? false;
//     });
//   }

//   // fetching details
//   fetchJObDetails() async {
//     final response = await get(
//         Uri.parse("$SERVER_ADDRESS/api/jobdetails?id=${widget.id}"));

//     print(response.request);

//     final jsonResponse = jsonDecode(response.body);

//     print(jsonResponse);

//     if (response.statusCode == 200 && jsonResponse['status'] == 1) {
//       setState(() {
//         jobDetails = DoctorDetail.fromJson(jsonResponse);
//       });
//     }
//   }

//   _launchURL(url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body:
//         // jobDetails == null
//         //     ? Center(
//         //         child: CircularProgressIndicator(
//         //           strokeWidth: 2,
//         //         ),
//         //       )
//         //     :
//             NestedScrollView(
//                 headerSliverBuilder: (context, val) {
//                   return <Widget>[
//                     SliverAppBar(
//                       backgroundColor: LIGHT_GREY_SCREEN_BG,
//                       expandedHeight: 250,
//                       leading: CircleAvatar(
//                         radius: 12,
//                         backgroundColor: WHITE,
//                         child: IconButton(
//                           icon: Icon(
//                             Icons.arrow_back,
//                             size: 20,
//                             color: LIME,
//                           ),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ),
//                       flexibleSpace: Center(
//                         child: Expanded(
//                             child: Image.asset(
//                           "assets/homescreen/appadvert.png",
//                           height: 300,
//                           width: MediaQuery.of(context).size.width,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, url, error) => Container(
//                             child: Container(
//                               height: 300,
//                               width: MediaQuery.of(context).size.width,
//                               child: Center(
//                                 child: Icon(Icons.broken_image_rounded),
//                               ),
//                             ),
//                           ),
//                         )),

//                         // CachedNetworkImage(
//                         //   fit: BoxFit.contain,
//                         //   height: 100,
//                         //   width: MediaQuery.of(context).size.width,
//                         //   imageUrl: jobDetails.data.image,
//                         //   progressIndicatorBuilder:
//                         //       (context, url, downloadProgress) => Container(
//                         //           height: 300,
//                         //           width: MediaQuery.of(context).size.width,
//                         //           child: Center(child: Icon(Icons.image))),
//                         //   errorWidget: (context, url, error) => Container(
//                         //     height: 300,
//                         //     width: MediaQuery.of(context).size.width,
//                         //     child: Center(
//                         //       child: Icon(Icons.broken_image_rounded),
//                         //     ),
//                         //   ),
//                         // ),
//                       ),
//                     ),
//                   ];
//                 },
//                 body: SafeArea(
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: SingleChildScrollView(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(15, 0, 15, 5),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       'jobDetails.data.name',
//                                       style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(15, 0, 15, 5),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Container(
//                                           height: 40,
//                                           width: 40,
//                                           decoration: BoxDecoration(
//                                             color: Colors.grey.shade300,
//                                             borderRadius:
//                                                 BorderRadius.circular(5),
//                                           ),
//                                           child: Center(
//                                               child: Icon(
//                                                   Icons.location_on_outlined)),
//                                         ),
//                                         SizedBox(
//                                           width: 10,
//                                         ),
//                                         Text(
//                                           'Uganda',
//                                           style: TextStyle(
//                                               color: NAVY_BLUE,
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.w700),
//                                         ),
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         Container(
//                                           height: 40,
//                                           width: 40,
//                                           decoration: BoxDecoration(
//                                             color: Colors.grey.shade300,
//                                             borderRadius:
//                                                 BorderRadius.circular(5),
//                                           ),
//                                           child: Center(
//                                             child: Image.asset(
//                                                 "assets/doctordetails/free-time.png"),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 10,
//                                         ),
//                                         Text(
//                                           'Full-Time',
//                                           style: TextStyle(
//                                               color: NAVY_BLUE,
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.w700),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(15, 0, 15, 5),
//                                 child: Row(
//                                   children: [
//                                     Text(
//                                       DEADLINE,
//                                       style: TextStyle(
//                                           fontSize: 14.5,
//                                           color: LIGHT_GREY_TEXT),
//                                     ),
//                                     Text(
//                                       '12th-Feb-2022',
//                                       style: TextStyle(
//                                           fontSize: 14.5,
//                                           color: LIGHT_GREY_TEXT),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Divider(
//                                 color: LIGHT_GREY,
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(15, 0, 15, 5),
//                                 child: Text(
//                                   COMPANY_DESCRIPTION,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 18),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(15, 5, 15, 15),
//                                 child: Text(
//                                   'Shamos Tech solutions is a talent marketplace that empowers entrepreneurs and SMEs to use their business challenges as an opportunity to get matched, engage with and hire skilled talent across Africa.For the job seeker, we give you a platform to showcase your skills, abilities, and previous works to a wider market and get you automatically matched and notified about open earning opportunities through our matching algorithm.We’re revolutionising connecting people in the field of service provision to customers looking to hire them for their skills and services, starting with the Ugandan market.',
//                                   style: TextStyle(
//                                       fontSize: 14.5, color: LIGHT_GREY_TEXT),
//                                   textAlign: TextAlign.justify,
//                                 ),
//                               ),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(15, 0, 15, 5),
//                                 child: Text(
//                                   JOB_ROLE,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 18),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(15, 5, 15, 15),
//                                 child: Text(
//                                   'As a software developer, you’ll be the brain behind crafting, developing, testing, going live and maintaining the Mimbbo system. You are passionate in understanding the business context for features built to drive better customer experience and adoption.',
//                                   style: TextStyle(
//                                       fontSize: 14.5, color: LIGHT_GREY_TEXT),
//                                   textAlign: TextAlign.justify,
//                                 ),
//                               ),

//                               Padding(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(15, 0, 15, 5),
//                                 child: Text(
//                                   RESPONSIBILITIES,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 18),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(15, 5, 15, 15),
//                                 child: Text(
//                                   'Familiar with the software development life cycle (SDLC) from analysis to deployment.Comply with coding standards and technical design.Believes in systematic approach to developing the system through clear documentation (flowcharts, layouts, & etc) of functionality, address every use case through creative solutions.Adapts structured coding styles for easy review, testing and maintainability of the code.Integrate the developed functionality and/or component into a fully functional system.Ensure unit and integration level verification plan are in place and adheres to great quality of code at all time.Active participate in troubleshooting, debugging and updating current live system.Verify user feedback in making system more stable and easy.Work closely with analysts, designers and other peer developers.Preparing technical training documents for onboarding new engineers',
//                                   style: TextStyle(
//                                       fontSize: 14.5, color: LIGHT_GREY_TEXT),
//                                   textAlign: TextAlign.justify,
//                                 ),
//                               ),
//                               // requirements
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(15, 0, 15, 5),
//                                 child: Text(
//                                   REQUIREMENTS,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 18),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(15, 5, 15, 15),
//                                 child: Text(
//                                   'Understanding of OOPS concepts, Persistence, Threading.Proficient in Javascript Competent with developing apps in popular web frameworks like React and React Native Knowledgeable in data structures and algorithms.Experience in designing interactive applications.A background in Engineering with sound oral and written communication skills will be a plus.',
//                                   style: TextStyle(
//                                       fontSize: 14.5, color: LIGHT_GREY_TEXT),
//                                   textAlign: TextAlign.justify,
//                                 ),
//                               ),
//                               //
//                             ],
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(20, 2, 20, 10),
//                         child: InkWell(
//                           onTap: () {
//                             _launchURL(
//                                 'https://careers.waape.io/jobs/xs2PxtKZ9XyK/software-developer-software-engineer-mimbbo?ft_source=6000030858&ft_medium=6000033967');
//                           },
//                           child: Container(
//                             height: 60,
//                             decoration: BoxDecoration(
//                               color: LIME,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 "Apply Now",
//                                 style: TextStyle(
//                                     color: WHITE,
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: 18),
//                               ),
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
// }

class JobDetailsScreen extends StatefulWidget {
  JobDetailsScreen({Key key, this.jobsList}) : super(key: key);
  final InnerData jobsList;

  static Route<T> getJobDetail<T>() {
    return MaterialPageRoute(
      builder: (_) => JobDetailsScreen(),
    );
  }

  @override
  _JobDetailsScreenState createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  Widget _header(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 26, vertical: 26),
      child: Column(
        children: [
          Row(
            children: [
              CachedNetworkImage(
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                imageUrl: Uri.parse(widget.jobsList.image).toString(),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Container(child: Center(child: Icon(Icons.image))),
                errorWidget: (context, url, error) => Container(
                  child: Center(
                    child: Icon(Icons.broken_image_rounded),
                  ),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        widget.jobsList.title,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(height: 5),
                  Text(
                    widget.jobsList.company,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _headerStatic("Work Type", '${widget.jobsList.workType}'),
              _headerStatic(
                  "Min-Experience", "${widget.jobsList.minExperience} year(s)"),
              _headerStatic("Deadline",
                  "${widget.jobsList.deadLine.day}/${widget.jobsList.deadLine.month}/${widget.jobsList.deadLine.year}"),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _headerStatic("Location",
                  '${widget.jobsList.address},${widget.jobsList.country}'),
              _headerStatic("Salary", "${widget.jobsList.minPrice}"),
            ],
          ),
          Divider(
            color: LIME,
            height: 25,
          ),
        ],
      ),
    );
  }

  Widget _headerStatic(String title, String sub) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: LIME,
            ),
          ),
          SizedBox(height: 5),
          Text(
            sub,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: LIGHT_GREY_TEXT,
            ),
          )
        ],
      ),
    );
  }

  Widget _companyDetails(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "About Company",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            widget.jobsList.compDetails,
            style: TextStyle(fontSize: 14, color: LIGHT_GREY_TEXT),
          ),
        ],
      ),
    );
  }

  Widget _jobDescription(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            "Roles",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            widget.jobsList.role,
            style: TextStyle(fontSize: 14, color: LIGHT_GREY_TEXT),
          ),
          SizedBox(height: 20),
          Text(
            "Responsibilities",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            widget.jobsList.responsibilities,
            style: TextStyle(fontSize: 14, color: LIGHT_GREY_TEXT),
          ),
          SizedBox(height: 20),
          Text(
            "Requirements",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            widget.jobsList.requiredSkills,
            style: TextStyle(fontSize: 14, color: LIGHT_GREY_TEXT),
          ),
          SizedBox(height: 20),
          Text(
            "Benefits",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            widget.jobsList.benefits,
            style: TextStyle(fontSize: 14, color: LIGHT_GREY_TEXT),
          ),
        ],
      ),
    );
  }

  Widget _apply(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      margin: EdgeInsets.only(top: 54),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(LIME),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 16))),
              onPressed: () {
                widget.jobsList.url != null
                    ? _launchURL(widget.jobsList.url)
                    : _launchURL('tel://256701407936');
              },
              child: Text(
                "Apply Now",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: LIGHT_GREY_SCREEN_BG,
        appBar: AppBar(
          backgroundColor: LIGHT_GREY_SCREEN_BG,
          iconTheme: IconThemeData(color: LIME),
          elevation: 0,
          actions: [
            IconButton(
                icon: Icon(Icons.ios_share),
                onPressed: () {
                  FlutterShare.share(
                      title: widget.jobsList.title,
                      text: 'Hey! Checkout this job by' +
                          widget.jobsList.company +
                          "\n",
                      linkUrl:
                          "http://play.google.com/store/apps/details?id=com.grabupapp.grabup");
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context),
              _companyDetails(context),
              _jobDescription(context),
              _apply(context)
            ],
          ),
        ));
  }
}
