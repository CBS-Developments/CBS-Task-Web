import 'package:flutter/material.dart';
import 'package:task_web/methods/colors.dart';
import 'package:task_web/sizes/pageSizes.dart';

import '../pages/chatPage.dart';
import '../pages/taskMainPage.dart';
import '../pages/taskPageOne.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({super.key});

  @override
  State<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 240,
        height: getPageHeight(context),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TaskMainPage()),
                  );
                },
                child: SizedBox(
                  height: 45,
                  width: 240,
                  child: Image.asset('images/dash.png'),
                ),
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TaskPageOne()),
                  );
                },
                child: SizedBox(
                  height: 45,
                  width: 240,
                  child: Image.asset('images/task.png'),
                ),
              ),

              TextButton(
                  onPressed:(){},
                  child: const Padding(
                    padding: EdgeInsets.only(left: 50),
                    child: Text('Taxation',style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 12,
                    fontWeight: FontWeight.bold),
                    ),
                  ),
              ),

              TextButton(
                onPressed:(){},
                child: Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Text('Talent Management',style: TextStyle(
                      color: AppColor.table,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                  ),
                ),
              ),


              TextButton(
                onPressed:(){},
                child:  Padding(
                  padding: EdgeInsets.only(left: 50),
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
                  padding: const EdgeInsets.only(left: 50),
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
                  padding: const EdgeInsets.only(left: 50),
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
                  padding: const EdgeInsets.only(left: 50),
                  child: Text('Development',style: TextStyle(
                      color: AppColor.table,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                  ),
                ),
              ),


              GestureDetector(
                onTap: (){},
                child: SizedBox(
                  height: 45,
                  width: 240,
                  child: Image.asset('images/calen.png'),
                ),
              ),

              GestureDetector(
                onTap: (){},
                child: SizedBox(
                  height: 45,
                  width: 240,
                  child: Image.asset('images/spec.png'),
                ),
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatPage()),
                  );
                },
                child: SizedBox(
                  height: 45,
                  width: 240,
                  child: Image.asset('images/chat.png'),
                ),
              ),
            ],
          ),
        ));
  }
}
