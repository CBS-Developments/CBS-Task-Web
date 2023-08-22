import 'package:flutter/material.dart';
import 'package:task_web/sizes/pageSizes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: getPageWidth(context),
        height: getPageHeight(context),
        child: Center(
          child: Container(
            width: 400,
            height: 450,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade300,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade500,
                    offset: const Offset(4, 4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),

                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4, -4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ]

            ),

            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Image.asset('images/mobile.png',
                width: 200,),

                SizedBox(
                  height: 10,
                ),
                Text('Log In',style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                ),

                SizedBox(
                  height: 5,
                ),

                Text('Log in and start managing your tasks!',style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                ),

                SizedBox(
                  height: 10,
                ),

                Container(
                  padding: const EdgeInsets.all(5),
                  width: 280,
                  height: 60,
                  color: Colors.white,
                  child: TextField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      labelText: 'Mobile Number',
                      hintText: '7X-XXX-XXXX',
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.smartphone_sharp,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    onSubmitted: (value) {
                      // login(context);
                    },
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                Container(
                  height: 40,
                  width: 200,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Log In'),
                    onPressed: () {
                      // login(context);
                    },
                  ),
                ),



              ],
            ),
          ),
        ),

      ),

    );
  }
}
