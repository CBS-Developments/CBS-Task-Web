import 'package:flutter/material.dart';
import 'package:task_web/pages/taskPageThree.dart';

import '../methods/colors.dart';
import '../pages/taskPageOne.dart';
import '../pages/taskPageTwo.dart';
import '../sizes/pageSizes.dart';

class SubDrawer extends StatelessWidget {
  const SubDrawer({super.key});

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
      width: 150,
      height: getPageHeight(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskPageOne()),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text('Taxation',style: TextStyle(
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
                MaterialPageRoute(builder: (context) => TaskPageTwo()),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text('Talent Management',style: TextStyle(
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
                MaterialPageRoute(builder: (context) => TaskPageThree()),
              );
            },
            child:  Padding(
              padding: EdgeInsets.all(5),
              child: Text('Finance & Accounting',style: TextStyle(
                  color: AppColor.table,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              ),
            ),
          ),

          TextButton(
            onPressed:(){},
            child:  Padding(
              padding: const EdgeInsets.all(5),
              child: Text('Audit & Assurance',style: TextStyle(
                  color: AppColor.table,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              ),
            ),
          ),

          TextButton(
            onPressed:(){},
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text('Company Secretarial',style: TextStyle(
                  color: AppColor.table,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              ),
            ),
          ),

          TextButton(
            onPressed:(){},
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text('Development',style: TextStyle(
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
