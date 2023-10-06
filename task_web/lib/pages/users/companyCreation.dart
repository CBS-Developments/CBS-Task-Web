import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_web/pages/users/currentCompany.dart';

import '../../components.dart';
import '../../drawers/adminSubDrawer.dart';
import '../../drawers/userDrawer.dart';
import '../../methods/appBar.dart';
import '../../methods/colors.dart';
import '../../methods/textFieldContainer.dart';
import 'currentUser.dart';
import 'package:http/http.dart' as http;

class CompanyCreation extends StatefulWidget {
  const CompanyCreation({Key? key}) : super(key: key);

  @override
  State<CompanyCreation> createState() => _CompanyCreationState();
}

class _CompanyCreationState extends State<CompanyCreation> {

  TextEditingController cinNoCreateController = TextEditingController();
  TextEditingController companyNameCreateController = TextEditingController();
  TextEditingController companyEmailCreateController = TextEditingController();
  TextEditingController regNoCreateController = TextEditingController();
  TextEditingController addressCreateController = TextEditingController();
  TextEditingController contactPerCreateController = TextEditingController();
  TextEditingController contactPerMobileCreateController = TextEditingController();
  TextEditingController contactPerEmailCreateController = TextEditingController();

  Future<void> createCompany(BuildContext context) async {
    // Validate input fields
    if (cinNoCreateController.text.trim().isEmpty ||
        companyNameCreateController.text.trim().isEmpty ||
        companyEmailCreateController.text.trim().isEmpty ||
        regNoCreateController.text.isEmpty ||
        addressCreateController.text.isEmpty||
        contactPerCreateController.text.isEmpty||
        contactPerMobileCreateController.text.isEmpty||
        contactPerEmailCreateController.text.isEmpty)
    {
      // Show an error message if any of the required fields are empty
      snackBar(context, "Please fill in all required fields", Colors.red);
      return;
    }


    // If all validations pass, proceed with the registration
    var url = "http://dev.workspace.cbs.lk/createCompany.php";

    var data = {
      "cin_no": cinNoCreateController.text,
      "company_name": companyNameCreateController.text,
      "company_email": companyEmailCreateController.text,
      "reg_no": regNoCreateController.text,
      "address_": addressCreateController.text,
      "contact_person_name": contactPerCreateController.text,
      "contact_person_phone": contactPerMobileCreateController.text,
      "contact_person_email": contactPerEmailCreateController.text,
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
    final snackBar =  SnackBar(
      content: Text('Company Created Successfully!'),
      backgroundColor: Colors.green, // You can customize the color
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppBar(),
      ),

      body: Row(
        children: [
          const UserDrawer(),
          const AdminSubDrawer(),

          Column(
            children: [
              const SizedBox(height: 20,),
              const Text('Company Creation',
                style:
                TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),),
              Container(
                margin: const EdgeInsets.all(30),
                width: 800,
                height: 500,
                decoration: const BoxDecoration(
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
                        TextFieldContainer(topic: 'CIN No:', controller: cinNoCreateController, hintText: '',),
                        TextFieldContainer(topic: 'Company Name:', controller: companyNameCreateController, hintText: '',),
                      ],
                    ),

                    Row(
                      children: [
                        TextFieldContainer(topic: 'Company Email:', controller: companyEmailCreateController, hintText: '',),
                        TextFieldContainer(topic: 'Company Registration No:', controller: regNoCreateController, hintText: '',),
                      ],
                    ),

                    Row(
                      children: [
                        TextFieldContainer(topic: 'Address:', controller: addressCreateController, hintText: '',),
                        TextFieldContainer(topic: 'Contact Person Name:', controller: contactPerCreateController, hintText: '',),
                      ],
                    ),

                    Row(
                      children: [
                        TextFieldContainer(topic: 'Contact Person Mobile:', controller: contactPerMobileCreateController, hintText: '',),
                        TextFieldContainer(topic: 'Contact Person Email:', controller: contactPerEmailCreateController, hintText: '',),
                      ],
                    ),

                    const SizedBox(height: 50,),

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
                                createCompany(context);
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
                                  MaterialPageRoute(builder: (context) => const CurrentCompany()),
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
