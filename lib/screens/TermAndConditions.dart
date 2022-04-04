import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/foundation.dart';
import '../AllText.dart';
import '../main.dart';
import 'base/custom_app_bar.dart';

class TermAndConditions extends StatefulWidget {
  @override
  _TermAndConditionsState createState() => _TermAndConditionsState();
}

class _TermAndConditionsState extends State<TermAndConditions> {
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
            title: TERM_AND_CONDITION,
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
