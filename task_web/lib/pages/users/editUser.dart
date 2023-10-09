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
  final String userName;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;
  final String employeeID;
  final String designation;
  final String company;

  const EditUserPage(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.phone,
      required this.employeeID,
      required this.designation,
      required this.company,
      required this.userName});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  TextEditingController newFirstNameController = TextEditingController();
  TextEditingController newLastNameController = TextEditingController();
  TextEditingController newEmailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newContactController = TextEditingController();
  TextEditingController newEmployeeIDController = TextEditingController();
  TextEditingController newDesignationController = TextEditingController();
  TextEditingController newCompanyController = TextEditingController();


  Future<bool> editUser(
      String userName,
      String newFirstName,
      String newLastName,
      String newEmail,
      String newPassword,
      String newContact,
      String newEmployeeID,
      String newDesignation,
      String newCompany,
      ) async {
    // Prepare the data to be sent to the PHP script.
    var data = {
      "user_name": userName,
      "first_name": newFirstName,
      "last_name": newLastName,
      "email": newEmail,
      "password_": newPassword,
      "phone": newContact,
      "employee_ID": newEmployeeID,
      "designation": newDesignation,
      "company": newCompany,
    };

    // URL of your PHP script.
    const url = "http://dev.workspace.cbs.lk/editUser.php";

    try {
      final res = await http.post(
        Uri.parse(url),
        body: data,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      if (res.statusCode == 200) {
        final responseBody = jsonDecode(res.body);

        // Debugging: Print the response data.
        print("Response from PHP script: $responseBody");

        if (responseBody == "true") {
          print('Successful');
          snackBar(context, "Profile Edite successful!", Colors.green);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return const CurrentUser();
            }),
          );
          return true; // PHP code was successful.
        } else {
          print('PHP code returned "false".');
          return false; // PHP code returned "false."
        }
      } else {
        print('HTTP request failed with status code: ${res.statusCode}');
        return false; // HTTP request failed.
      }
    } catch (e) {
      print('Error occurred: $e');
      return false; // An error occurred.
    }
  }


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
                        controller: newFirstNameController,
                        hintText: widget.firstName,
                      ),
                      TextFieldContainer(
                        topic: 'Last Name:',
                        controller: newLastNameController,
                        hintText: widget.lastName,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextFieldContainer(
                        topic: 'Email:',
                        controller: newEmailController,
                        hintText: widget.email,
                      ),
                      TextFieldContainer(
                        topic: 'Password:',
                        controller: newPasswordController,
                        hintText: widget.password,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextFieldContainer(
                        topic: 'Contact Number:',
                        controller: newContactController,
                        hintText: widget.phone,
                      ),
                      TextFieldContainer(
                        topic: 'Employee ID:',
                        controller: newEmployeeIDController,
                        hintText: widget.employeeID,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextFieldContainer(
                        topic: 'Designation:',
                        controller: newDesignationController,
                        hintText: widget.designation,
                      ),
                      TextFieldContainer(
                        topic: 'Company:',
                        controller: newCompanyController,
                        hintText: widget.company,
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
                              editUser(
                                  widget.userName,
                                  newFirstNameController.text,
                                  newLastNameController.text,
                                  newEmailController.text,
                                  newPasswordController.text,
                                  newContactController.text,
                                  newEmployeeIDController.text,
                                  newDesignationController.text,
                                  newCompanyController.text);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColor.loginF,
                              backgroundColor: Colors.lightBlue.shade50,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(5), // Rounded corners
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
                                    builder: (context) => const CurrentUser()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColor.loginF,
                              backgroundColor: Colors.lightBlue.shade50,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(5), // Rounded corners
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
