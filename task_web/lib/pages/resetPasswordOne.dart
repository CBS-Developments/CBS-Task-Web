import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/pages/resetPasswordTwo.dart';

import '../methods/colors.dart';
import '../sizes/pageSizes.dart';

class ResetPasswordOne extends StatefulWidget {
  const ResetPasswordOne({super.key});

  @override
  State<ResetPasswordOne> createState() => _ResetPasswordOneState();
}

class _ResetPasswordOneState extends State<ResetPasswordOne> {
  TextEditingController passwordVerifyController = TextEditingController();
  bool obscureText = true;

  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";
  String email = "";
  String password_ = "";
  String employee_ID = "";
  String designation = "";
  String company = "";

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
      employee_ID = prefs.getString('employee_ID') ?? "";
      designation = prefs.getString('designation') ?? "";
      company = prefs.getString('company') ?? "";
    });
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

                Text('$firstName $lastName', style: TextStyle(fontSize: 24),),
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
                              Text(email, style: TextStyle(fontSize: 16)),
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
                      child: Text("To continue, first verify that it's you",style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.all(5),
                  width: 360,
                  height: 60,
                  color: Colors.white,
                  child: TextField(
                    controller: passwordVerifyController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      labelText: 'Enter your current password',
                      hintText: '',
                    ),
                  ),
                ),

                Row(
                  children: [
                    SizedBox(width: 50,),

                    Checkbox(
                      value: !obscureText,
                      onChanged: (value) {
                        setState(() {
                          obscureText = !value!;
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
                        onPressed: () {
                          // Check if the entered password matches the stored password
                          if (passwordVerifyController.text == password_) {
                            // Passwords match, navigate to ResetPasswordTwo
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResetPasswordTwo(userName: userName,
                                  firstName: firstName,
                                  lastName: lastName, email: email, obscureText: obscureText,),
                              ),
                            );
                          } else {
                            // Passwords don't match, show an error message
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text('Password verification failed. Please try again.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
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
                        Text('Next',
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
