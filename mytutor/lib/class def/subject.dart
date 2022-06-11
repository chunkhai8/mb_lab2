class Subject {
  String? subjectid;
  String? subjectname;
  String? subjectdescription;
  String? subjectprice;
  String? tutorid;
  String? subjectsessions;
  String? subjectrating;

  Subject(
      {this.subjectid,
      this.subjectname,
      this.subjectdescription,
      this.subjectprice,
      this.tutorid,
      this.subjectsessions,
      this.subjectrating,
      });

  Subject.fromJson(Map<String, dynamic> json) {
    subjectid = json['subject_id'];
    subjectname = json['subject_name'];
    subjectdescription = json['subject_description'];
    subjectprice = json['subject_price'];
    tutorid = json['tutor_id'];
    subjectsessions = json['subject_sessions'];
    subjectrating = json['subject_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject_id'] = subjectid;
    data['subject_name'] = subjectname;
    data['subject_description'] = subjectdescription;
    data['subject_price'] = subjectprice;
    data['tutor_id'] = tutorid;
    data['subject_sessions'] = subjectsessions;
    data['subject_rating'] = subjectrating;
    return data;
  }
}