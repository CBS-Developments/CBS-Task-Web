
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/sizes/pageSizes.dart';
import 'package:http/http.dart' as http;

import '../components.dart';
import 'taskPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneNumberController = TextEditingController();

  Future<bool> login(BuildContext context) async {
    if (phoneNumberController.text.trim().isEmpty) {
      snackBar(context, "Phone number can't be empty", Colors.redAccent);
      return false;
    }

    if (phoneNumberController.text.trim().length < 3) {
      snackBar(context, "Invalid number. Number must be above 3 characters", Colors.yellow);
      return false;
    }

    var url = "http://dev.connect.cbs.lk/login.php";
    var data = {
      "phone": phoneNumberController.text,
    };

    http.Response res = await http.post(
      url,
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName("utf-8"),
    );

    if (res.statusCode.toString() == "200") {
      Map<String, dynamic> result = jsonDecode(res.body);
      print(result);
      bool status = result['status'];
      if (status) {
        if (result['activate'] == '1') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('login_state', '1');
          prefs.setString('user_name', result['user_name']);
          prefs.setString('first_name', result['first_name']);
          prefs.setString('last_name', result['last_name']);
          prefs.setString('phone', result['phone']);
          prefs.setString('user_role', result['user_role']);
          prefs.setString('activate', result['activate']);

          if (!mounted) return true;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskPage()),
          );
        } else {
          snackBar(context, "Permission denied", Colors.yellow);
        }
      } else {
        snackBar(context, result['message'], Colors.redAccent);
      }
    } else {
      snackBar(context, "Error", Colors.redAccent);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: getPageWidth(context),
        height: getPageHeight(context),
        child: Center(
          child: Container(
            width: 400,
            height: 450,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade300,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade500,
                  offset: const Offset(4, 4),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset('images/mobile.png', width: 200),
                const SizedBox(height: 10),
                const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Log in and start managing your tasks!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(5),
                  width: 280,
                  height: 60,
                  color: Colors.white,
                  child: TextField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      labelText: 'Mobile Number',
                      hintText: '7X-XXX-XXXX',
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.smartphone_rounded,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    onSubmitted: (value) {
                      login(context);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 40,
                  width: 200,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Log In'),
                    onPressed: () {
                      login(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
