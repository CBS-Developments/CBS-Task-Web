import 'package:flutter/material.dart';

import '../../drawers/adminSubDrawer.dart';
import '../../drawers/userDrawer.dart';
import '../../methods/appBar.dart';
import '../../methods/colors.dart';
import '../../methods/textFieldContainer.dart';

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
