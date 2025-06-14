import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'DetailsScreen.dart';
import 'patients.dart'; // assuming your Patient model is here
import 'dart:convert';
import 'package:http/http.dart' as http;

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
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
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Expected Mothers",
          style: theme.textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.person, color: Color.fromARGB(255, 20, 18, 19)),
                  title: Text(
                    patients[index].name,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 20, 18, 19),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Last Appointment Date: ${DateFormat('dd-MMM-yyyy').format(patients[index].LastAppointment)}',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(patient: patients[index]),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
