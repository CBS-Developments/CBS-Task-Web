import 'package:flutter/material.dart';
import 'package:task_web/methods/colors.dart';
import 'package:task_web/sizes/pageSizes.dart';

import '../pages/chatPage.dart';
import '../pages/dashboard/dashMain.dart';
import '../pages/dashboard/dashboadPageUser.dart';
import '../pages/taskMainPage.dart';
import '../pages/taskPageAll.dart';
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
                    MaterialPageRoute(builder: (context) => DashManin()),
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
                    MaterialPageRoute(builder: (context) => TaskPageAll()),
                  );
                },
                child: SizedBox(
                  height: 45,
                  width: 240,
                  child: Image.asset('images/task.png'),
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: SizedBox(
                  height: 45,
                  width: 240,
                  child: Image.asset('images/mail.png'),
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
              GestureDetector(
                onTap: (){},
                child: SizedBox(
                  height: 45,
                  width: 240,
                  child: Image.asset('images/meet.png'),
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: SizedBox(
                  height: 45,
                  width: 240,
                  child: Image.asset('images/apps.png'),
                ),
              ),
            ],
          ),
        ));
  }
}
