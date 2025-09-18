class RatingImages {
  String? status;
  String? message;
  String? total;
  List<String>? data;

  RatingImages({this.status, this.message, this.total, this.data});

  RatingImages.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total'] = this.total;
    data['data'] = this.data;
    return data;
  }
}
