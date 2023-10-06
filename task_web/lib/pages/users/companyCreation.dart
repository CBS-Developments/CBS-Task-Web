import 'package:flutter/material.dart';

import '../../drawers/adminSubDrawer.dart';
import '../../drawers/userDrawer.dart';
import '../../methods/appBar.dart';
import '../../methods/colors.dart';
import '../../methods/textFieldContainer.dart';
import 'currentUser.dart';

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
              const SizedBox(height: 20,),
              const Text('Company Creation',
                style:
                TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),),
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
                                // createUser(context);
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
