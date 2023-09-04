import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/drawers/drawerDash.dart';
import 'package:task_web/sizes/pageSizes.dart';

import '../methods/appBar.dart';

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
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
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
                                    TextStyle(fontSize: 16),),
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
                                    TextStyle(fontSize: 16),),
                                  )
                                ],
                              )
                          ),


                        ],
                      ),
                    )
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
