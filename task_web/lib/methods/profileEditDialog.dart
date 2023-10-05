import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";
  String email = "";
  String password_ = "";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? "";
      firstName = prefs.getString('first_name') ?? "";
      lastName = prefs.getString('last_name') ?? "";
      phone = prefs.getString('phone') ?? "";
      userRole = prefs.getString('user_role') ?? "";
      email = prefs.getString('email') ?? "";
      password_ = prefs.getString('password_') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 50, // Adjust this value to change the vertical position
          right: 5, // Adjust this value to change the horizontal position
          child: Builder(
            builder: (context) {
              return AlertDialog(
                content: SizedBox(
                  height: 350,
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_circle_sharp, size: 50,)
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      Row(
                        children: [
                          TextField(
                            controller: firstNameController,
                            decoration: InputDecoration(
                                hintText: firstName
                            ),
                          ),
                          TextField(
                            controller: lastNameController,
                            decoration: InputDecoration(
                                hintText: lastName
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: email
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      TextField(
                        controller: mobileNumberController,
                        decoration: InputDecoration(
                            hintText: phone
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            hintText: password_
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      userProfileEditSave(
                          userName, firstNameController, lastNameController,emailController,mobileNumberController,passwordController
                         );
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close',
                      style:
                      TextStyle(
                          color: Colors.red
                      ),),
                  ),


                ],
              );
            }
          ),
        ),
      ],
    );
  }
}

Future<void> userProfileEditSave(String userName, TextEditingController firstNameController,
    TextEditingController lastNameController, TextEditingController emailController,
    TextEditingController mobileNumberController, TextEditingController passwordController) async {
  var data = {
    "user_name": userName,
    "first_name": 'dine',
    "last_name": 'ddd',
    "email": 'abc@gmail.com',
    "phone": '123458',
    "password_": '124',
  };

  const url = "http://dev.workspace.cbs.lk/profileEdit.php";
  http.Response res = await http.post(
    Uri.parse(url),
    body: data,
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
    },
  );

  if (res.statusCode.toString() == "200") {
    Map<String, dynamic> result = jsonDecode(res.body);
    print(result);
  }
}