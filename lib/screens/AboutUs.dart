import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/foundation.dart';
import '../AllText.dart';
import '../main.dart';
import 'base/custom_app_bar.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  Widget html;

  @override
  void initState() {
    loadHtml();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: LIGHT_GREY_SCREEN_BG,
          appBar: CustomAppBar(
            title: 'About $APPNAME',
            isCenter: true,
            isElevation: false,
            isBackButtonExist: true,
          ),
          body: SafeArea(
            child: html == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: html,
                    ),
                  ),
          )),
    );
  }

  loadHtml() async {
    final data = await rootBundle.loadString('assets/tnc.html');

    setState(() {
      html = Html(
        data: data,
      );
    });
  }
}
