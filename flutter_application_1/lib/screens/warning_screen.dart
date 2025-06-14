import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'patients.dart';
import 'DetailsScreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class WarningScreen extends StatefulWidget {
  const WarningScreen({super.key});

  @override
  _WarningScreenState createState() => _WarningScreenState();
}

class _WarningScreenState extends State<WarningScreen> {
  List<Patient> patients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }
  
  Future<void> fetchPatients() async {
    const url = 'http://10.0.2.2:5085/api/PwRegistration/all-mothers-last-visit'; // replace with your actual API endpoint

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Patient> loadedPatients = data.map((json) => Patient.fromJson(json)).toList();

        setState(() {
          patients = loadedPatients;
          print(patients);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load patients');
      }
    } catch (e) {
      print("Error fetching patients: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort patients based on dueDate (EDD)
    patients.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mothers' Due Dates",
          style: theme.textTheme.titleLarge,
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final patient = patients[index];
          final daysUntilDue = patient.dueDate.difference(DateTime.now()).inDays;
          final formattedEDD = DateFormat('dd-MMM-yyyy').format(patient.dueDate);

          final dueText = daysUntilDue >= 0
              ? "$daysUntilDue days remaining"
              : "${-daysUntilDue} days overdue";

          final dueColor = daysUntilDue >= 0 ? Colors.blue : Colors.red;

          return ListTile(
            leading: Icon(Icons.calendar_today, color: dueColor),
            title: Text(
              patient.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: dueColor,
              ),
            ),
            subtitle: Text(
              'EDD: $formattedEDD\n$dueText',
              style: TextStyle(color: dueColor),
            ),
            isThreeLine: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(patient: patient),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
