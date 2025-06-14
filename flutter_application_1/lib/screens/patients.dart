import 'package:intl/intl.dart';


class Patient {
  final String name;
  final String phno;
  final int age;
  final int weight;
  final String height;
  final DateTime LastAppointment;
  final DateTime firstAncDate;
  final DateTime dueDate;
  final DateTime ComplainDateTime;
  final double hb;
  final int pulse;
  final int spo2;
  final int gluc;
  final int fhr;

  Patient({
    required this.name,
    required this.phno,
    required this.age,
    required this.weight,
    required this.height,
    required this.LastAppointment,
    required this.firstAncDate,
    required this.dueDate,
    required this.ComplainDateTime,
    required this.hb,
    required this.pulse,
    required this.spo2,
    required this.gluc,
    required this.fhr,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      name: json['name'] ?? 'Unknown',
      phno: json['phone'] ?? 'N/A', // Optional: add this if your API returns it
      age: json['motherAge'] ?? 0,
      weight: 0, // Not provided
      height: '', // Not provided
      LastAppointment: DateTime.tryParse(json['lastAppointment'] ?? '') ?? DateTime.now(),
      firstAncDate: DateTime.tryParse(json['lmp'] ?? '') ?? DateTime.now(),
      dueDate: DateTime.tryParse(json['dueDate'] ?? '') ?? DateTime(1900),
      ComplainDateTime: DateTime.now(), // Placeholder
      hb: (json['hb'] as num?)?.toDouble() ?? 0.0,
      pulse: json['pulse'] ?? 0,
      spo2: json['spo2'] ?? 0,
      gluc: json['gluc'] ?? 0,
      fhr: json['fhr'] ?? 0,
    );
  }
}

final List<Patient> patients = [];