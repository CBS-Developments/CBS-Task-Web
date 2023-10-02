import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/pages/taskPageOne.dart';

import '../drawers/drawerTask.dart';
import '../methods/appBar.dart';
import '../methods/colors.dart';
import '../methods/taskTable.dart';
import '../methods/upMainRow.dart';
import '../sizes/pageSizes.dart';

class TaskPageTwo extends StatefulWidget {
  const TaskPageTwo({super.key});

  @override
  State<TaskPageTwo> createState() => _TaskPageTwoState();
}

class _TaskPageTwoState extends State<TaskPageTwo> {

  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? "";
      firstName = prefs.getString('first_name') ?? "";
      lastName = prefs.getString('last_name') ?? "";
      phone = prefs.getString('phone') ?? "";
      userRole = prefs.getString('user_role') ?? "";

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppBar(),
      ),
      body:
      Row(
        children: [
          const LeftDrawer(),

          Container(
            // color: Colors.white,
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
                        color: AppColor.drawerDark,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                    ),
                  ),
                ),


                TextButton(
                  onPressed:(){},
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
          ),

          Column(
            children:  [
              UpMainRow(),
              SizedBox(height: 20,),
              TaskTable(
              ),

              SizedBox(height: 18),



            ],
          )
        ],
      ),

    );
  }
}

