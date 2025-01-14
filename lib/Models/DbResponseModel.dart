class DbResponse {
  bool? status;
  String? message;
  dynamic result;

  DbResponse({this.status, this.message, this.result});

  DbResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['result'] = result;
    return data;
  }
}
