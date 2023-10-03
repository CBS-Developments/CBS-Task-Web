import 'package:flutter/material.dart';
import 'package:task_web/methods/appBar.dart';

import '../methods/colors.dart';
import '../sizes/pageSizes.dart';
import 'loginPage.dart';



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
            height: 600,
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
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.all(5),
                  width: 330,
                  height: 60,
                  color: Colors.white,
                  child: TextField(
                    controller: firstNameController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      labelText: 'First Name',
                      hintText: '',
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.person_outline_rounded,
                          color: AppColor.loginF,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    onSubmitted: (value) {
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
                    controller: lastNameController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      labelText: 'Last Name',
                      hintText: '',
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.person_outline_rounded,
                          color: AppColor.loginF,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    onSubmitted: (value) {
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
                    controller: mobileNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      labelText: 'Mobile Number',
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
                    },
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  height: 50,
                  width: 200,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColor.loginF,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // Rounded corners
                      ),
                    ),
                    child: const
                    Text('Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),
                    ),
                  ),


                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?',style: TextStyle(fontSize: 18),),
                    TextButton(onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    }, child: const Text('Login',style: TextStyle(fontSize: 18),))
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
