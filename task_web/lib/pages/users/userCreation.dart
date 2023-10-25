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

class UserCreation extends StatefulWidget {
  const UserCreation({Key? key}) : super(key: key);

  @override
  State<UserCreation> createState() => _UserCreationState();
}

class _UserCreationState extends State<UserCreation> {

  TextEditingController firstNameCreateController = TextEditingController();
  TextEditingController lastNameCreateController = TextEditingController();
  TextEditingController emailCreateController = TextEditingController();
  TextEditingController passwordCreateController = TextEditingController();
  TextEditingController contactCreateController = TextEditingController();
  TextEditingController employeeIDCreateController = TextEditingController();
  TextEditingController designationCreateController = TextEditingController();
  TextEditingController companyCreateController = TextEditingController();

  Future<void> createUser(BuildContext context) async {
    // Validate input fields
    if (firstNameCreateController.text.trim().isEmpty ||
        lastNameCreateController.text.trim().isEmpty ||
        emailCreateController.text.trim().isEmpty ||
        passwordCreateController.text.isEmpty ||
        contactCreateController.text.isEmpty||
        employeeIDCreateController.text.isEmpty||
        designationCreateController.text.isEmpty||
        companyCreateController.text.isEmpty)
    {
      // Show an error message if any of the required fields are empty
      snackBar(context, "Please fill in all required fields", Colors.red);
      return;
    }

    // Other validation logic can be added here

    // If all validations pass, proceed with the registration
    var url = "http://dev.workspace.cbs.lk/createUser.php";

    var data = {
      "user_name": firstNameCreateController.text.substring(0, 5) + contactCreateController.text.substring(contactCreateController.text.length - 2),
      "first_name": firstNameCreateController.text.toString().trim(),
      "last_name": lastNameCreateController.text.toString().trim(),
      "email": emailCreateController.text.toString().trim(),
      "password_": passwordCreateController.text.toString().trim(),
      "phone": contactCreateController.text.toString().trim(),
      "employee_ID": employeeIDCreateController.text.toString().trim(),
      "designation": designationCreateController.text.toString().trim(),
      "company": companyCreateController.text.toString().trim(),
      "user_role": '0',
      "activate": '1',
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
      if (jsonDecode(res.body) == "true") {
        if (!mounted) return;
        showSuccessSnackBar(context);// Show the success SnackBar
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CurrentUser()),
        );
      } else {
        if (!mounted) return;
        snackBar(context, "Error", Colors.red);
      }
    } else {
      if (!mounted) return;
      snackBar(context, "Error", Colors.redAccent);
    }
  }

  void showSuccessSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('User Created Successfully!'),
      backgroundColor: Colors.green, // You can customize the color
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppBar(),
      ),

      body: Row(
        children: [
          UserDrawer(),
          AdminSubDrawer(),

          Column(
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
                        TextFieldContainer(topic: 'First Name:', controller: firstNameCreateController, hintText: '',),
                        TextFieldContainer(topic: 'Last Name:', controller: lastNameCreateController, hintText: '',),
                      ],
                    ),

                    Row(
                      children: [
                        TextFieldContainer(topic: 'Email:', controller: emailCreateController, hintText: '',),
                        TextFieldContainer(topic: 'Password:', controller: passwordCreateController, hintText: '',),
                      ],
                    ),

                    Row(
                      children: [
                        TextFieldContainer(topic: 'Contact Number:', controller: contactCreateController, hintText: '',),
                        TextFieldContainer(topic: 'Employee ID:', controller: employeeIDCreateController, hintText: '',),
                      ],
                    ),

                    Row(
                      children: [
                        TextFieldContainer(topic: 'Designation:', controller: designationCreateController, hintText: '',),
                        TextFieldContainer(topic: 'Company:', controller: companyCreateController, hintText: '',),
                      ],
                    ),

                    SizedBox(height: 50,),

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
                               createUser(context);
                             },
                             style: ElevatedButton.styleFrom(
                               foregroundColor: AppColor.loginF,
                               backgroundColor: Colors.lightBlue.shade50,
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(5), // Rounded corners
                               ),
                             ),
                             child: const
                             Text('Create',
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
                                 MaterialPageRoute(builder: (context) => const CurrentUser()),
                               );
                             },
                             style: ElevatedButton.styleFrom(
                               foregroundColor: AppColor.loginF,
                               backgroundColor: Colors.lightBlue.shade50,
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(5), // Rounded corners
                               ),
                             ),
                             child: const
                             Text('Cancel',
                               style: TextStyle(
                                 fontWeight: FontWeight.bold,color: Colors.redAccent
                               ),
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
          )
        ],
      ),
    );
  }
}
