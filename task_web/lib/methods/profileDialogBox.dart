import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/methods/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";
  String email = "";

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

    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 200,
        child: Column(
          children: [
             Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Profile',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColor.drawerLight),),
            ],
          ),
            SizedBox(
              height: 30,
            ),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  firstName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  lastName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            Text(
              email,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              phone,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),

          ],
        ),
      ),

      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
