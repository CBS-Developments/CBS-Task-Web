import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/methods/drawer.dart';

import '../methods/sideDropMenu.dart';

class MainDashBoard extends StatefulWidget {
  const MainDashBoard({super.key});

  @override
  State<MainDashBoard> createState() => _MainDashBoardState();
}

class _MainDashBoardState extends State<MainDashBoard> {

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
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          'CBS Task System',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        actions: [

          Column(
            children: [
              const Text('',style: TextStyle(
                color: Colors.black,
              ),),
              Text(
                "$firstName $lastName",
                style: const TextStyle(color: Colors.black, fontSize: 18.0),
              ),
            ],
          ),

          const SizedBox(width: 10,),

          IconButton(
              onPressed: ()
              {},
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.black,
              )),


          IconButton(
              onPressed: ()
              {
                showPopupMenu(context);
              },
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              )),

        ],
      ),

      body: Row(
        children: [
          LeftDrawer(),
        ],
      ),

    );
  }
}
