import 'package:flutter/material.dart';
import 'package:task_web/pages/users/companyCreation.dart';
import 'package:task_web/pages/users/currentCompany.dart';
import 'package:task_web/pages/users/currentUser.dart';
import 'package:task_web/pages/users/userCreation.dart';

import '../methods/colors.dart';
import '../sizes/pageSizes.dart';

class AdminSubDrawer extends StatelessWidget {
  const AdminSubDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(
            color:Colors.grey.shade400, // Color of the left border
            width: 2.0, // Width of the left border
          ),
        ),
      ),
      width: 198,
      height: getPageHeight(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CurrentUser()),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text('Current Users',style: TextStyle(
                  color:AppColor.table,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              ),
            ),
          ),

          TextButton(
            onPressed:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CurrentCompany()),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text('Current Company',style: TextStyle(
                  color: AppColor.table,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              ),
            ),
          ),


          TextButton(
            onPressed:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserCreation()),
              );
            },
            child:  Padding(
              padding: EdgeInsets.all(5),
              child: Text('User Creation',style: TextStyle(
                  color: AppColor.table,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              ),
            ),
          ),

          TextButton(
            onPressed:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompanyCreation()),
              );
            },
            child:  Padding(
              padding: const EdgeInsets.all(5),
              child: Text('Company Creation',style: TextStyle(
                  color: AppColor.table,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
