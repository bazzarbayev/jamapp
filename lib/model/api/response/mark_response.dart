
class Mark {
  int id;
  int grade;
  String gradeComment;

  Mark({this.id, this.grade, this.gradeComment});

  Mark.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    grade = json['grade'] == null ? 0 : json['grade'];
    gradeComment = json['grade_comment'] == null ? "" : json['grade_comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['grade'] = this.grade;
    data['grade_comment'] = this.gradeComment;
    return data;
  }
}

