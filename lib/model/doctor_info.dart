class ModelDoctorInfo {
  final String clinicName,
      address,
      doctorName,
      eveningTime,
      morningTime,
      specialization,
      docId,
      fees,
      dayOff,
      lateTime;
  final double latitude, longitude, distance;
  final review;

  ModelDoctorInfo(
    this.clinicName,
    this.address,
    this.doctorName,
    this.eveningTime,
    this.fees,
    this.morningTime,
    this.specialization,
    this.latitude,
    this.longitude,
    this.distance,
    this.review,
    this.docId,
    this.dayOff,
    this.lateTime,
  );
}
