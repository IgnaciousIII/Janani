class PwRegistration {
  final int rchid;
  final String mothername;
  final String husbandname;
  final String mobileno;
  final String district;
  final String village;
  // Add more fields as needed...

  PwRegistration({
    required this.rchid,
    required this.mothername,
    required this.husbandname,
    required this.mobileno,
    required this.district,
    required this.village,
  });

  factory PwRegistration.fromJson(Map<String, dynamic> json) {
    return PwRegistration(
      rchid: json['rchid'],
      mothername: json['mothername'],
      husbandname: json['husbandname'],
      mobileno: json['mobileno'],
      district: json['district'],
      village: json['village'],
    );
  }
}
