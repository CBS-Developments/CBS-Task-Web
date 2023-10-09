import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_web/methods/TextFieldLogin.dart';

import '../components.dart';
import '../methods/colors.dart';
import '../sizes/pageSizes.dart';
import 'loginPage.dart';
import 'package:http/http.dart' as http;


class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController companyController = TextEditingController();


  Future<void> createUser(BuildContext context) async {
    // Validate input fields
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        mobileNumberController.text.isEmpty ||
        designationController.text.isEmpty ||
        passwordController.text.isEmpty ||
        companyController.text.isEmpty) {
      // Show an error message if any of the required fields are empty
      snackBar(context, "Please fill in all required fields", Colors.red);
      return;
    }

    // Other validation logic can be added here

    // If all validations pass, proceed with the registration
    var url = "http://dev.workspace.cbs.lk/createUser.php";

    var data = {
      "user_name": firstNameController.text.substring(0, 5) + mobileNumberController.text.substring(mobileNumberController.text.length - 2),
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "email": emailController.text,
      "password_": passwordController.text,
      "phone": mobileNumberController.text,
      "designation": designationController.text,
      "company": companyController.text,
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
          MaterialPageRoute(builder: (context) => const LoginPage()),
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
      content: Text('Registration successful!'),
      backgroundColor: Colors.green, // You can customize the color
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: getPageWidth(context),
        height: getPageHeight(context),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 850,
              height: getPageHeight(context),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(20),
              //   color: Colors.white60,
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.grey.shade500,
              //       offset: const Offset(4, 4),
              //       blurRadius: 5,
              //       spreadRadius: 1,
              //     ),
              //     const BoxShadow(
              //       color: Colors.white,
              //       offset: Offset(-4, -4),
              //       blurRadius: 15,
              //       spreadRadius: 1,
              //     ),
              //   ],
              // ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'Workspace',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    const Text(
                      'Get Started With Workspace',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Join and manage all your tasks from one single ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      'platform',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextFieldLogin(topic: 'First Name', controller: firstNameController, hintText: '', suficon: Icon(Icons.person)),
                            TextFieldLogin(topic: 'Last Name', controller: lastNameController, hintText: '', suficon: Icon(Icons.person))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextFieldLogin(topic: 'Work Email Address', controller: emailController, hintText: '', suficon: Icon(Icons.email)),
                            TextFieldLogin(topic: 'Phone', controller: mobileNumberController, hintText: '', suficon: Icon(Icons.phone))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextFieldLogin(topic: 'Company name', controller: companyController, hintText: '', suficon: Icon(Icons.home_work)),
                            TextFieldLogin(topic: 'Designation', controller: designationController, hintText: '', suficon: Icon(Icons.add))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextFieldLogin(topic: 'Password', controller: passwordController, hintText: '', suficon: Icon(Icons.remove_red_eye))
                          ],
                        )
                      ],
                    ),
                    // Container(
                    //   padding: const EdgeInsets.all(5),
                    //   width: 330,
                    //   height: 60,
                    //   color: Colors.white,
                    //   child: TextField(
                    //     controller: firstNameController,
                    //     keyboardType: TextInputType.number,
                    //     decoration: InputDecoration(
                    //       alignLabelWithHint: true,
                    //       border: const OutlineInputBorder(),
                    //       labelText: 'First Name',
                    //       hintText: '',
                    //       suffixIcon: IconButton(
                    //         icon: Icon(
                    //           Icons.person_outline_rounded,
                    //           color: AppColor.loginF,
                    //         ),
                    //         onPressed: () {},
                    //       ),
                    //     ),
                    //     onSubmitted: (value) {
                    //     },
                    //   ),
                    // ),
                    // const SizedBox(height: 20),
                    //
                    // Container(
                    //   padding: const EdgeInsets.all(5),
                    //   width: 330,
                    //   height: 60,
                    //   color: Colors.white,
                    //   child: TextField(
                    //     controller: lastNameController,
                    //     keyboardType: TextInputType.number,
                    //     decoration: InputDecoration(
                    //       alignLabelWithHint: true,
                    //       border: const OutlineInputBorder(),
                    //       labelText: 'Last Name',
                    //       hintText: '',
                    //       suffixIcon: IconButton(
                    //         icon: Icon(
                    //           Icons.person_outline_rounded,
                    //           color: AppColor.loginF,
                    //         ),
                    //         onPressed: () {},
                    //       ),
                    //     ),
                    //     onSubmitted: (value) {
                    //     },
                    //   ),
                    // ),
                    //
                    // const SizedBox(height: 20),
                    //
                    // Container(
                    //   padding: const EdgeInsets.all(5),
                    //   width: 330,
                    //   height: 60,
                    //   color: Colors.white,
                    //   child: TextField(
                    //     controller: emailController,
                    //     keyboardType: TextInputType.number,
                    //     decoration: InputDecoration(
                    //       alignLabelWithHint: true,
                    //       border: const OutlineInputBorder(),
                    //       labelText: 'Enter Your Email',
                    //       hintText: '',
                    //       suffixIcon: IconButton(
                    //         icon: Icon(
                    //           Icons.email_outlined,
                    //           color: AppColor.loginF,
                    //         ),
                    //         onPressed: () {},
                    //       ),
                    //     ),
                    //     onSubmitted: (value) {
                    //     },
                    //   ),
                    // ),
                    //
                    // const SizedBox(height: 20),
                    //
                    // Container(
                    //   padding: const EdgeInsets.all(5),
                    //   width: 330,
                    //   height: 60,
                    //   color: Colors.white,
                    //   child: TextField(
                    //     controller: mobileNumberController,
                    //     keyboardType: TextInputType.number,
                    //     decoration: InputDecoration(
                    //       alignLabelWithHint: true,
                    //       border: const OutlineInputBorder(),
                    //       labelText: 'Mobile Number',
                    //       hintText: '',
                    //       suffixIcon: IconButton(
                    //         icon: Icon(
                    //           Icons.phone_android_rounded,
                    //           color: AppColor.loginF,
                    //         ),
                    //         onPressed: () {},
                    //       ),
                    //     ),
                    //     onSubmitted: (value) {
                    //     },
                    //   ),
                    // ),
                    //
                    // const SizedBox(height: 20),
                    //
                    // Container(
                    //   padding: const EdgeInsets.all(5),
                    //   width: 330,
                    //   height: 60,
                    //   color: Colors.white,
                    //   child: TextField(
                    //     controller: passwordController,
                    //     obscureText: true,
                    //     decoration: InputDecoration(
                    //       alignLabelWithHint: true,
                    //       border: const OutlineInputBorder(),
                    //       labelText: 'Password',
                    //       hintText: '',
                    //       suffixIcon: IconButton(
                    //         icon: Icon(
                    //           Icons.password_rounded,
                    //           color: AppColor.loginF,
                    //         ),
                    //         onPressed: () {},
                    //       ),
                    //     ),
                    //     onSubmitted: (value) {
                    //     },
                    //   ),
                    // ),
                    // const SizedBox(height: 25),
                    // Container(
                    //   height: 50,
                    //   width: 200,
                    //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       createUser(context);
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       foregroundColor: AppColor.loginF,
                    //       backgroundColor: Colors.white,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(5), // Rounded corners
                    //       ),
                    //     ),
                    //     child: const
                    //     Text('Sign Up',
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 18
                    //       ),
                    //     ),
                    //   ),
                    //
                    //
                    // ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already using workspace?',style: TextStyle(fontSize: 18),),
                        TextButton(onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        }, child: Text('Sign In here',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,  color: AppColor.tealLog),))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

    );
  }
}
