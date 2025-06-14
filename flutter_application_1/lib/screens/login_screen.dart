import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatelessWidget {
  final Function(Locale) setLocale;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  LoginScreen({super.key, required this.setLocale});

  // sign user in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.key21), // 'Login'
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              // Toggle between 'en' and 'ka'
              if (Localizations.localeOf(context).languageCode == 'en') {
                setLocale(const Locale('ka'));
              } else {
                setLocale(const Locale('en'));
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 100),
              Image.asset(
                'images/logo.png',
                width: 200,
              ),
              const SizedBox(height: 50),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: localizations.key18, // 'Username'
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: localizations.key19, // 'Password'
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    localizations.key20, // 'Forgot Password'
                    style: const TextStyle(color: Colors.indigo),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () async{
                  final rchId = usernameController.text.trim();

                  if (rchId.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter RCH ID")),
                    );
                    return;
                  }

                  if (rchId.toLowerCase() == 'caretaker') {
                    Navigator.pushNamed(context, '/caretaker');
                    
                    return;
                  }

                  final url = Uri.parse('http://10.0.2.2:5085/api/PwRegistration/$rchId'); // use 10.0.2.2 for Android emulator

                  try {
                    final response = await http.get(url);
                    if (response.statusCode == 200) {
                      final motherData = jsonDecode(response.body);
                      print(motherData);
                      Navigator.pushNamed(context, '/home', arguments: motherData);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Mother not found")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Error connecting to server")),
                    );
                  }
                },
                child: Text(
                  localizations.key21, // 'Login'
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
