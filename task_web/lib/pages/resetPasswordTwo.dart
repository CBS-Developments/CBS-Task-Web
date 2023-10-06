import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components.dart';
import '../methods/colors.dart';
import '../sizes/pageSizes.dart';
import 'package:http/http.dart' as http;

import 'loginPage.dart';

class ResetPasswordTwo extends StatefulWidget {
  final String userName;
  final String firstName;
  final String lastName;
  final String email;
  final bool obscureText;
  const ResetPasswordTwo({
    super.key,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email, required this.obscureText,
  });

  @override
  State<ResetPasswordTwo> createState() => _ResetPasswordTwoState();
}

class _ResetPasswordTwoState extends State<ResetPasswordTwo> {
  TextEditingController newPasswordController = TextEditingController();

  bool obscureTextTwo =true;

  Future<bool> resetPassword(
      String userName, String newPassword) async {
    var data = {
      "user_name": userName,
      "password_": newPassword,
    };

    const url = "http://dev.workspace.cbs.lk/resetPassword.php";
    final res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );

    if (res.statusCode == 200) {
      if (jsonDecode(res.body) == "true") {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: getPageWidth(context),
        height: getPageHeight(context),
        color: Colors.grey.shade50,
        child: Center(
          child: Container(
            width: 450,
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.shade500,
                width: 1.0,
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  margin: const EdgeInsets.all(20),
                  width: 80,
                  height: 80,
                  child: Image.asset('images/logonew.png'),
                ),

                Text(
                  '${widget.firstName} ${widget.lastName}',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 10,),

                Row(
                  mainAxisSize: MainAxisSize.min, // This ensures the Container only takes the width of its child
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey.shade500,
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              Icon(Icons.account_circle_rounded),
                              SizedBox(width: 5,),
                              Text(widget.email, style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    SizedBox(width: 30,),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Set a strong new password for your account",style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.all(5),
                  width: 360,
                  height: 60,
                  color: Colors.white,
                  child: TextField(
                    controller: newPasswordController,
                    obscureText: obscureTextTwo, // Use the local variable
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      labelText: 'Enter new password',
                      hintText: '',
                    ),
                  ),
                ),

                Row(
                  children: [
                    SizedBox(width: 50),
                    Checkbox(
                      value: !obscureTextTwo, // Inverse the value for the checkbox
                      onChanged: (value) {
                        setState(() {
                          obscureTextTwo = !value!; // Update the local variable
                        });
                      },
                    ),
                    Text('Show Password'),
                  ],
                ),

                SizedBox(height: 30,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 40,
                      width: 100,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        onPressed: () async {
                          final success = await resetPassword(
                            widget.userName,
                            newPasswordController.text,
                          );
                          if (success) {
                            snackBar(context, "Password reset successful! Please log in again.", Colors.green);
                            final prefs = await SharedPreferences.getInstance();
                            prefs.remove("login_state"); // Remove the "login_state" key
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const LoginPage();
                              }),
                            );
                          } else {
                            snackBar(context, "Password reset failed. Please try again.", Colors.red);
                          }
                        },

                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColor.loginF,
                          backgroundColor: Colors.blueGrey.shade50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), // Rounded corners
                          ),
                        ),
                        child: const
                        Text('Save',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,color: Colors.blue
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 40,)
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
