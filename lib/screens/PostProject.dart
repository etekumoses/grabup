import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grabup/modals/CategoryList.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grabup/AllText.dart';

import '../main.dart';
import 'base/custom_app_bar.dart';
import 'base/custom_snackbar.dart';
import 'package:http/http.dart' as http;

import 'base/listcountry.dart';

class PostProject extends StatefulWidget {
  @override
  _PostProjectState createState() => _PostProjectState();
}

class _PostProjectState extends State<PostProject> {
  String categoryValue;

  int categoryId;
  int userId;
  String selectedFormattedDate;
  TextEditingController titleController = TextEditingController();
  TextEditingController compnameController = TextEditingController();
  TextEditingController aboutcompController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController respController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController requiredController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController benefitsController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String date;
  DateTime selectedDate = DateTime.now();
  String _deadline = " ";
  CategoryList categories;
  bool isLoadingCategory = false;
  bool isPostingMadeSuccessfully = false;
  List<String> monthsList = [
    "",
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  final min_experience = ['1 year', '2 years', '3 years', '4 years +'];
  String selectedminexpValue;
  final work_type = ['Full Time', 'Part Time', 'Contract', 'Remote'];
  String selectedworktypeValue;
  String fname, lname, phone, token;
  String selectedcountry;
  @override
  void initState() {
    super.initState();
    selectedFormattedDate = selectedDate.day.toString() +
        " " +
        monthsList[selectedDate.month] +
        ", " +
        selectedDate.year.toString();

    getCategoriesList();
    SharedPreferences.getInstance().then((value) {
      userId = value.getInt("id");
      fname = value.getString("f_name");
      lname = value.getString("l_name");
      phone = value.getString("phone");
      token = value.getString('token');
      compnameController =
          TextEditingController(text: value.getString("f_name"));
      phoneController = TextEditingController(text: value.getString("phone"));
    });
  }

// image
  String path = "";
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

//
  String _url;
  String get urlvalue => _url;
  validateUrl(TextEditingController controller, String value) {
    if (value == "www" || value == "http" || value == "https")
      controller
        ..text = "https://"
        ..selection = TextSelection.collapsed(offset: controller.text.length);

    _url = controller.text;
  }

// bottomsheet
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: LIGHT_GREY_SCREEN_BG,
        appBar: CustomAppBar(
          title: 'New Job',
          isBackButtonExist: true,
          isCenter: true,
          isElevation: false,
          onBackPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TabBarScreen()),
            );
          },
        ),
        body: body(),
      ),
    );
  }

  body() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  // title
                  Text(
                    TITLE,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                        hintText: 'Project or job title',
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        isCollapsed: true),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: LIGHT_GREY_TEXT),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // category
                  Text(
                    'Category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  DropdownButton(
                    isExpanded: true,
                    hint: Text(
                      isLoadingCategory ? LOADING : SELECT_CATEGORY,
                    ),
                    value: categoryValue,
                    icon: Image.asset(
                      "assets/postjob/down-arrow.png",
                      height: 15,
                      width: 15,
                    ),
                    items: categories == null
                        ? []
                        : List.generate(categories.data.length, (index) {
                            return DropdownMenuItem(
                              value: categories.data[index].name,
                              child: Text(categories.data[index].name),
                              key: UniqueKey(),
                              onTap: () {
                                setState(() {
                                  categoryId = categories.data[index].id;
                                });
                              },
                            );
                          }),
                    onChanged: (val) {
                      print(val);
                      setState(() {
                        categoryValue = val.toString();
                      });
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  // company name
                  Text(
                    COMPANY_NAME,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: compnameController,
                    decoration: InputDecoration(
                        hintText: 'Company/ recruiter name',
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        isCollapsed: true),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: LIGHT_GREY_TEXT),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // about
                  Text(
                    'About Company',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: aboutcompController,
                    maxLines: 10,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(color: LIGHT_GREY_TEXT, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Company details',
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: LIGHT_GREY_TEXT, width: 0.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: LIGHT_GREY_TEXT, width: 0.5),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: LIGHT_GREY_TEXT, width: 0.5),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // deadline
                  Text(
                    'Application Deadline',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          selectedFormattedDate.toString(),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: LIGHT_GREY_TEXT),
                        ),
                        Divider(
                          color: LIGHT_GREY_TEXT,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // role
                  Text(
                    JOB_ROLE,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: roleController,
                    maxLines: 10,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(color: LIGHT_GREY_TEXT, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Employee roles',
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: LIGHT_GREY_TEXT, width: 0.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: LIGHT_GREY_TEXT, width: 0.5),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: LIGHT_GREY_TEXT, width: 0.5),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // responsibilities
                  Text(
                    RESPONSIBILITIES,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: respController,
                    maxLines: 10,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(color: LIGHT_GREY_TEXT, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Employee responsibilites',
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: LIGHT_GREY_TEXT, width: 0.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: LIGHT_GREY_TEXT, width: 0.5),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: LIGHT_GREY_TEXT, width: 0.5),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //type
                  Text(
                    'Work Type',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  DropdownButton(
                    isExpanded: true,
                    hint: Text(
                      SELECT_WORK_TYPE,
                    ),
                    icon: Image.asset(
                      "assets/postjob/down-arrow.png",
                      height: 15,
                      width: 15,
                    ),
                    value: selectedworktypeValue,
                    items: work_type.map<DropdownMenuItem>((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      print(val);
                      setState(() {
                        selectedworktypeValue = val.toString();
                      });
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // required skills
                  Text(
                    REQUIREMENTS,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: requiredController,
                    maxLines: 10,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(color: LIGHT_GREY_TEXT, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Expected required skills',
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: LIGHT_GREY_TEXT, width: 0.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: LIGHT_GREY_TEXT, width: 0.5),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: LIGHT_GREY_TEXT, width: 0.5),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // address
                  Text(
                    'Address',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: addressController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: 'Job address',
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        isCollapsed: true),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: LIGHT_GREY_TEXT),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // country
                  Text(
                    'Country',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  DropdownButton(
                      isExpanded: true,
                      hint: Text(
                        'Select Country',
                      ),
                      icon: Image.asset(
                        "assets/postjob/down-arrow.png",
                        height: 15,
                        width: 15,
                      ),
                      value: selectedcountry,
                      items: listCountry
                          .map(
                            (e) => DropdownMenuItem(
                              value: e["name"],
                              child: Text(
                                e["name"],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedcountry = value.toString();
                        });
                      }),

                  SizedBox(
                    height: 15,
                  ),
                  //experience
                  Text(
                    EXPERIENCE,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  DropdownButton(
                    isExpanded: true,
                    hint: Text(
                      SELECT_MIN_EXPERIENCE,
                    ),
                    icon: Image.asset(
                      "assets/postjob/down-arrow.png",
                      height: 15,
                      width: 15,
                    ),
                    value: selectedminexpValue,
                    items: min_experience.map<DropdownMenuItem>((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      print(val);
                      setState(() {
                        selectedminexpValue = val.toString();
                      });
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  // url
                  Text(
                    'Application Website Link(Optional)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: urlController,
                    onChanged: (value) => validateUrl(urlController, value),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: 'https://',
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        isCollapsed: true),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: LIGHT_GREY_TEXT),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  // phone
                  Text(
                    PHONE_NUMBER,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        hintText: 'Contact number',
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        isCollapsed: true),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: LIGHT_GREY_TEXT),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // price
                  Text(
                    MIN_SALARY + ' (Optional)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: salaryController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'Expected pay',
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        isCollapsed: true),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: LIGHT_GREY_TEXT),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // about
                  Text(
                    'Other benefits(optional)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: benefitsController,
                    maxLines: 10,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(color: LIGHT_GREY_TEXT, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Any other details',
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: LIGHT_GREY_TEXT, width: 0.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: LIGHT_GREY_TEXT, width: 0.5),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: LIGHT_GREY_TEXT, width: 0.5),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // image
                  Text(
                    'Photo',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: LIGHT_GREY),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(children: [
                          InkWell(
                              onTap: () {
                                showSheet();
                              },
                              child: Container(
                                height: 140,
                                width: MediaQuery.of(context).size.width,
                                child: Image.file(
                                  File(path),
                                  height: 140,
                                  width: 140,
                                  fit: BoxFit.cover,
                                ),
                              )),
                          path.isEmpty
                              ? Positioned(
                                  top: 30,
                                  bottom: 30,
                                  left: 50,
                                  right: 50,
                                  child: InkWell(
                                      onTap: () {
                                        showSheet();
                                      },
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.add_a_photo,
                                            color: LIME,
                                          ),
                                          Text(
                                            'Tap to upload',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      )),
                                )
                              : SizedBox(),
                        ]),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomButtons(),
         SizedBox(
                    height: 15,
                  ),
      ],
    );
  }

  bottomButtons() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                postproject();
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(12, 5, 12, 15),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: LIME,
                ),
                child: Center(
                  child: Text(
                    SUBMIT,
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
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        currentDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        print(selectedDate.toString().substring(0, 10));
        selectedFormattedDate = selectedDate.day.toString() +
            " " +
            monthsList[selectedDate.month] +
            ", " +
            selectedDate.year.toString();
      });
  }

  getCategoriesList() async {
    print('Getting category');

    final response =
        await http.get(Uri.parse("$SERVER_ADDRESS/api/v1/listofcategory"));

    print(response.request);

    final jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonResponse['status'] == 1) {
      setState(() {
        categories = CategoryList.fromJson(jsonResponse);
      });
    }
  }

  postproject() async {
    if (categoryId == null ||
        selectedminexpValue == null ||
        selectedcountry == null ||
        selectedworktypeValue == null ||
        compnameController.text.isEmpty ||
        aboutcompController.text.isEmpty ||
        respController.text.isEmpty ||
        requiredController.text.isEmpty ||
        roleController.text.isEmpty ||
        addressController.text.isEmpty ||
        phoneController.text.isEmpty ||
        path.isEmpty ||
        titleController.text.isEmpty ||
        _deadline == "Select Deadline") {
      showCustomSnackBar(ENTER_ALL_FIELDS_TO_POST_AD, context, isError: true);
    } else {
      dialog();

      print("category_id:" +
          categoryId.toString() +
          "\n" +
          "min_experience:" +
          selectedminexpValue.toString() +
          "\n" +
          "title:" +
          titleController.text +
          "\n" +
          "phone:" +
          phoneController.text +
          "\n" +
          "dead_line:" +
          selectedDate.toString().substring(0, 10) +
          "\n" +
          "user_id:" +
          userId.toString() +
          "\n" +
          "role:" +
          roleController.text);

      Response response;
      Dio dio = new Dio();

      FormData formData = FormData.fromMap({
        "category_id": categoryId.toString(),
        "title": titleController.text,
        "company": compnameController.text,
        "comp_details": aboutcompController.text,
        "role": roleController.text,
        "work_type": selectedworktypeValue,
        "responsibilities": respController.text,
        "min_experience": selectedminexpValue,
        "image": await MultipartFile.fromFile(path, filename: "profile.png"),
        "required_skills": requiredController.text,
        "address": addressController.text,
        "country": selectedcountry,
        "benefits": benefitsController.text,
        "min_price": salaryController.text,
        "dead_line": selectedDate.toString().substring(0, 10),
        "user_id": userId.toString(),
        "url": urlController.text == null
            ? phoneController.text
            : urlController.text,
      });

      response = await dio.post(
        SERVER_ADDRESS + "/api/v1/user/postjob",
        data: formData,
        options: new Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}),
      );

      print(response.realUri);

      if (response.statusCode == 200 && response.data['status'] == 1) {
        print("Success");
        setState(() {
          Navigator.pop(context);
          showCustomSnackBar(response.data['msg'], context);
          isPostingMadeSuccessfully = true;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => TabBarScreen()));
      } else {
        Navigator.pop(context);
        print("Error" + response.toString());
        showCustomSnackBar(response.data['msg'], context);
      }
    }
  }

  dialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              PROCESSING,
            ),
            content: Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      PLEASE_WAIT_WHILE_POSTING_JOB,
                      style: TextStyle(fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  messageDialog(String s1, String s2) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              s1,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s2,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (isPostingMadeSuccessfully) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TabBarScreen(),
                        ));
                  } else {
                    Navigator.pop(context);
                  }
                },
                style: TextButton.styleFrom(backgroundColor: LIME),
                child: Text(
                  OK,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: WHITE,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
