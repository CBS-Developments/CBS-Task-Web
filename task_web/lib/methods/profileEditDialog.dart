import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/methods/colors.dart';

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
          child: AlertDialog(
            content: SizedBox(
              height: 350,
              child: Column(
                children: [
                  Row(
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

                  TextField(
                    decoration: InputDecoration(
                      hintText: '$firstName $lastName'
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  TextField(
                    decoration: InputDecoration(
                        hintText: email
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  TextField(
                    decoration: InputDecoration(
                        hintText: phone
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  TextField(
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
                  // Add logic for the edit button here
                },
                child: const Text(
                  'Save',
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
          ),
        ),
      ],
    );
  }
}
