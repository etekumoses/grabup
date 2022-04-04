class JobsList {
  int status;
  String msg;
  List<Data> data;

  JobsList({this.status, this.msg, this.data});

  JobsList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    data =List<Data>.from(json["data"].map((x) => Data.fromJson(x)));
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['status'] = this.status;
  //   data['msg'] = this.msg;
  //   if (this.data != null) {
  //     data['data'] = this.data.toJson();
  //   }
  //   return data;
  // }
}

class Data {
  int currentPage;
  List<InnerData> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  int perPage;
  String prevPageUrl;
  int to;
  int total;

  Data(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <InnerData>[];
      json['data'].forEach((v) {
        data.add(new InnerData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'].toString();
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'].toString();
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class InnerData {
  int id;
  String image;
  String title;
  String company;
  String compDetails;
  String role;
  String responsibilities;
  String minExperience;
  String requiredSkills;
  String workType;
  dynamic address;
  String country;
  String benefits;
  String minPrice;
  dynamic otherDetails;
  dynamic url;
  DateTime deadLine;

  InnerData({
    this.id,
    this.image,
    this.title,
    this.company,
    this.compDetails,
    this.role,
    this.responsibilities,
    this.minExperience,
    this.requiredSkills,
    this.workType,
    this.address,
    this.country,
    this.benefits,
    this.minPrice,
    this.otherDetails,
    this.url,
    this.deadLine,
  });

  InnerData.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    image = json["image"];
    title = json["title"];
    company = json["company"];
    compDetails = json["comp_details"];
    role = json["role"];
    responsibilities = json["responsibilities"];
    minExperience = json["min_experience"];
    requiredSkills = json["required_skills"];
    workType = json["work_type"];
    address = json["address"];
    country = json["country"];
    benefits = json["benefits"];
    minPrice = json["min_price"];
    otherDetails = json["other_details"];
    url = json["url"];
    deadLine = DateTime.parse(json["dead_line"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['company'] = this.company;
    data['role'] = this.role;
    data['comp_details'] = this.compDetails;
    data['work_type'] = this.workType;
    data['responsibilities'] = this.responsibilities;
    data['min_experience'] = this.minExperience;
    data['image'] = this.image;
    data['required_skills'] = this.requiredSkills;
    data['address'] = this.address;
    data['country'] = this.country;
    data['benefits'] = this.benefits;
    data['min_price'] = this.minPrice;
    data['other_details'] = this.otherDetails;
    data['url'] = this.url;
    data['dead_line'] = this.deadLine;
    return data;
  }
}
