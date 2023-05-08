class Appointments {
  final String expertName;
  final String speciality;
  final String experience;
  final String expertProfilePic;
  final String expertId;
  final String expertDocumentID;
  final String customerName;
  final String customerNumber;
  final String customerProfilePic;
  final String customerID;
  final String customerDocumentID;
  final String appointmentDate;
  final String appointmentHour;
  final String location;
  final String expectedWorkHour;
  final String deviceToken;
  bool isApproved = false;

  Appointments({
    required this.expertName,
    required this.speciality,
    required this.expectedWorkHour,
    required this.experience,
    required this.expertProfilePic,
    required this.expertId,
    required this.expertDocumentID,
    required this.customerName,
    required this.customerNumber,
    required this.customerProfilePic,
    required this.customerID,
    required this.customerDocumentID,
    required this.appointmentDate,
    required this.appointmentHour,
    required this.location,
    required this.isApproved,
    required this.deviceToken,
  });

  // from map
  factory Appointments.fromMap(Map<String, dynamic> map) {
    return Appointments(
      expertName: map['expertName'] ?? '',
      expertProfilePic: map['expertProfilePic'] ?? '',
      speciality: map['speciality'] ?? '',
      experience: map['experience'] ?? '',
      expertId: map['expertId'] ?? '',
      location: map['location'] ?? '',
      customerName: map['customerName'] ?? '',
      customerNumber: map['customerNumber'] ?? '',
      customerProfilePic: map['customerProfilePic'] ?? '',
      customerID: map['customerID'] ?? '',
      appointmentDate: map['appointmentDate'] ?? '',
      appointmentHour: map['appointmentHour'] ?? '',
      deviceToken: map['deviceToken'] ?? '',
      isApproved: map['isApproved'] ?? '',
      expertDocumentID: map['doctorDocumentID'] ?? '',
      customerDocumentID: map['patientDocumentID'] ?? '',
      expectedWorkHour: map['expectedWorkHour'],
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "expertName": expertName,
      "expertProfilePic": expertProfilePic,
      "speciality": speciality,
      "experience": experience,
      "expertId": expertId,
      "location": location,
      "customerName": customerName,
      "customerNumber": customerNumber,
      "customerProfilePic": customerProfilePic,
      "customerID": customerID,
      "appointmentDate": appointmentDate,
      "appointmentHour": appointmentHour,
      "deviceToken": deviceToken,
      "isApproved": isApproved,
      "expertDocumentID": expertDocumentID,
      "customerDocumentID": customerDocumentID,
      "expectedWorkHour": expectedWorkHour
    };
  }
}
