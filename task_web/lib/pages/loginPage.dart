
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/methods/colors.dart';
import 'package:task_web/pages/createAccountPage.dart';
import 'package:task_web/pages/taskMainPage.dart';
import 'package:task_web/sizes/pageSizes.dart';
import 'package:http/http.dart' as http;

import '../components.dart';
import 'dashboard/dashMain.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<bool> login(BuildContext context) async {
    if (emailController.text.trim().isEmpty) {
      snackBar(context, "Email can't be empty", Colors.redAccent);
      return false;
    }

    if (emailController.text.trim().length < 3) {
      snackBar(context, "Invalid Email.", Colors.yellow);
      return false;
    }

    var url = "http://dev.workspace.cbs.lk/login.php";
    var data = {
      "email": emailController.text,
      "password_": passwordController.text,
    };

    http.Response res = await http.post(
      Uri.parse(url),
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
          prefs.setString('email', result['email']);
          prefs.setString('password_', result['password_']);
          prefs.setString('phone', result['phone']);
          prefs.setString('employee_ID', result['employee_ID']);
          prefs.setString('designation', result['designation']);
          prefs.setString('company', result['company']);
          prefs.setString('user_role', result['user_role']);
          prefs.setString('activate', result['activate']);

          if (!mounted) return true;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DashManin()),
          );
        } else {
          snackBar(context, "Account Deactivated", Colors.redAccent); // Show Snackbar for deactivated account
        }
      } else {
        snackBar(context, "Incorrect Password", Colors.yellow); // Show Snackbar for incorrect password
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
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade300,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade500,
                  offset: const Offset(4, 4),
                  blurRadius: 5,
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
                //Image.asset('images/mobile.png', width: 200),
                const SizedBox(height: 10),
                const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Log in and start managing your tasks!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.all(5),
                  width: 330,
                  height: 60,
                  color: Colors.white,
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      labelText: 'Enter Your Email',
                      hintText: '',
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.email_outlined,
                          color: AppColor.loginF,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    onSubmitted: (value) {
                      login(context);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(5),
                  width: 330,
                  height: 60,
                  color: Colors.white,
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: '',
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.password_rounded,
                          color: AppColor.loginF,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    onSubmitted: (value) {
                      login(context);
                    },
                  ),
                ),
                const SizedBox(height: 60),
                Container(
                  height: 50,
                  width: 200,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      login(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColor.loginF,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // Rounded corners
                      ),
                    ),
                    child: const
                    Text('Log In',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),


                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an Account?",
                      style: TextStyle(fontSize: 18),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateAccountPage()),
                          );
                        },
                        child: const Text(
                          'Create an Account',
                          style: TextStyle(fontSize: 18),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
