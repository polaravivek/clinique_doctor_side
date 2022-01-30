import 'dart:convert';

class ModelDoctorInfo {
  final String? clinicName;
  final String? address;
  final String? doctorName;
  final String? eveningTime;
  final String? morningTime;
  final String? specialization;
  final String? docId;
  final String? fees;
  final String? dayOff;
  final String? lateTime;
  final String? count;
  final String? img;
  final double? latitude;
  final double? longitude;
  final double? distance;
  final int? review;

  ModelDoctorInfo(
      {this.clinicName,
      this.address,
      this.doctorName,
      this.eveningTime,
      this.morningTime,
      this.specialization,
      this.docId,
      this.img,
      this.count,
      this.fees,
      this.dayOff,
      this.lateTime,
      this.latitude,
      this.longitude,
      this.distance,
      this.review});

  Map<String, dynamic> toMap() {
    return {
      'clinicName': clinicName,
      'address': address,
      'doctorName': doctorName,
      'evening time': eveningTime,
      'morning time': morningTime,
      'specialization': specialization,
      'docId': docId,
      'fees': fees,
      'dayoff': dayOff,
      'lateAllowedTime': lateTime,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'review': review,
      'img': img,
      'count': count
    };
  }

  factory ModelDoctorInfo.fromMap(Map<String, dynamic> map) {
    return ModelDoctorInfo(
        clinicName: map['clinicName'] ?? '',
        address: map['address'] ?? '',
        doctorName: map['doctorName'] ?? '',
        eveningTime: map['evening time'] ?? '',
        morningTime: map['morning time'] ?? '',
        specialization: map['specialization'] ?? '',
        docId: map['docId'] ?? '',
        fees: map['fees'] ?? '',
        dayOff: map['dayoff'] ?? '',
        lateTime: map['lateAllowedTime'] ?? '',
        latitude: map['latitude']?.toDouble() ?? 0.0,
        longitude: map['longitude']?.toDouble() ?? 0.0,
        distance: map['distance']?.toDouble() ?? 0.0,
        review: map['review']?.toInt() ?? 0,
        img: map['img'],
        count: map['count']);
  }

  String toJson() => json.encode(toMap());

  factory ModelDoctorInfo.fromJson(String source) =>
      ModelDoctorInfo.fromMap(json.decode(source));
}
