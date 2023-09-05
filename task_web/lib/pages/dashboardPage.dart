import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/drawers/drawerDash.dart';
import 'package:task_web/methods/taskLog.dart';
import 'package:task_web/sizes/pageSizes.dart';

import '../methods/appBar.dart';
import '../methods/chartBox.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";

  String get taskCount => '20';

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppBar(),
      ),

      body: Row(
        children: [
          LeftDrawerDash(),

          SizedBox(width: getPageWidth(context)-240,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Welcome $firstName $lastName!",
                    style: const TextStyle(color: Colors.black, fontSize: 30.0),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 60,
                      width: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text('Total Tasks',style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Text(taskCount,style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),),
                          )
                        ],
                      ),
                    ),
                    
                    Container(
                      width: 360,
                      height: 40,
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          TextButton(
                              onPressed: (){}, 
                              child: Row(
                                children: [
                                  Icon(Icons.add_circle_outline,color: Colors.red,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('User Creation',style:
                                    TextStyle(
                                        fontSize: 16,
                                      color: Colors.black
                                    ),
                                    ),
                                  )
                                ],
                              )
                          ),

                          VerticalDivider(
                            thickness: 2,
                          ),

                          TextButton(
                              onPressed: (){},
                              child: Row(
                                children: [
                                  Icon(Icons.add_circle_outline,color: Colors.red,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('Company Creation',style:
                                    TextStyle(fontSize: 16,color: Colors.black),),
                                  )
                                ],
                              )
                          ),


                        ],
                      ),
                    )
                  ],
                ),

                SizedBox(height: 10,),

                SizedBox(
                  width: getPageWidth(context)-240,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ChartBox(
                        centerText: '60.0%',
                        percent: 0.6,
                        footerText: 'Completed this Week',
                      ),

                      ChartBox(
                        centerText: '25.0%',
                        percent: 0.25,
                        footerText: 'In-Progress this Week',
                      ),

                      ChartBox(
                        centerText: '15.0%',
                        percent: 0.15,
                        footerText: 'To-Do this Week',
                      ),

                      ChartBox(
                        centerText: '10.0%',
                        percent: 0.10,
                        footerText: 'OverDue this Week',
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 450,
                      height: 250,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.white, // Background color for the "Notification" text
                            child: Row(
                              children: [
                                Icon(Icons.notifications_active, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  "Notification",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    TaskLog(),
                  ],
                )


              ],
            ),
          )

        ],
      ),

    );
  }
}
