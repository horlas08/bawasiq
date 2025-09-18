class LiveOrderTracking {
  String? error;
  String? message;
  LiveOrderTrackingData? data;

  LiveOrderTracking({this.error, this.message, this.data});

  LiveOrderTracking.fromJson(Map<String, dynamic> json) {
    error = json['error'].toString();
    message = json['message'].toString();
    data = json['data'] != null ? new LiveOrderTrackingData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LiveOrderTrackingData {
  String? id;
  String? orderId;
  String? latitude;
  String? longitude;
  String? trackedAt;
  String? createdAt;
  String? updatedAt;

  LiveOrderTrackingData(
      {this.id,
      this.orderId,
      this.latitude,
      this.longitude,
      this.trackedAt,
      this.createdAt,
      this.updatedAt});

  LiveOrderTrackingData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    orderId = json['order_id'].toString();
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    trackedAt = json['tracked_at'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['tracked_at'] = this.trackedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
