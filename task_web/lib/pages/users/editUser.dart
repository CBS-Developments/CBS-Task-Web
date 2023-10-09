import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_web/pages/users/currentUser.dart';

import '../../components.dart';
import '../../drawers/adminSubDrawer.dart';
import '../../drawers/userDrawer.dart';
import '../../methods/appBar.dart';
import '../../methods/colors.dart';
import '../../methods/textFieldContainer.dart';
import 'package:http/http.dart' as http;

class EditUserPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;
  final String employeeID;
  final String designation;
  final String company;

  const EditUserPage({super.key, required this.firstName, required this.lastName, required this.email, required this.password, required this.phone, required this.employeeID, required this.designation, required this.company});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  TextEditingController firstNameCreateController = TextEditingController();
  TextEditingController lastNameCreateController = TextEditingController();
  TextEditingController emailCreateController = TextEditingController();
  TextEditingController passwordCreateController = TextEditingController();
  TextEditingController contactCreateController = TextEditingController();
  TextEditingController employeeIDCreateController = TextEditingController();
  TextEditingController designationCreateController = TextEditingController();
  TextEditingController companyCreateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppBar(),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(30),
              width: 800,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey, // Shadow color
                    blurRadius: 5, // Spread radius
                    offset: Offset(0, 3), // Offset in x and y directions
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      TextFieldContainer(
                        topic: 'First Name:',
                        controller: firstNameCreateController,
                        hintText: widget.firstName,
                      ),
                      TextFieldContainer(
                        topic: 'Last Name:',
                        controller: lastNameCreateController,
                        hintText:  widget.lastName,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextFieldContainer(
                        topic: 'Email:',
                        controller: emailCreateController,
                        hintText:  widget.email,
                      ),
                      TextFieldContainer(
                        topic: 'Password:',
                        controller: passwordCreateController,
                        hintText:  widget.password,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextFieldContainer(
                        topic: 'Contact Number:',
                        controller: contactCreateController,
                        hintText:  widget.phone,
                      ),
                      TextFieldContainer(
                        topic: 'Employee ID:',
                        controller: employeeIDCreateController,
                        hintText:  widget.employeeID,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextFieldContainer(
                        topic: 'Designation:',
                        controller: designationCreateController,
                        hintText:  widget.designation,
                      ),
                      TextFieldContainer(
                        topic: 'Company:',
                        controller: companyCreateController,
                        hintText:  widget.company,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 750,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 40,
                          width: 140,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                            onPressed: () {
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColor.loginF,
                              backgroundColor: Colors.lightBlue.shade50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5), // Rounded corners
                              ),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 140,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CurrentUser()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColor.loginF,
                              backgroundColor: Colors.lightBlue.shade50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5), // Rounded corners
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}