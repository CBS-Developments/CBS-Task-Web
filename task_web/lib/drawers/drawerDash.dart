import 'package:flutter/material.dart';
import 'package:task_web/pages/dashboardPage.dart';
import 'package:task_web/pages/taskPage.dart';

import '../methods/colors.dart';
import '../sizes/pageSizes.dart';

class LeftDrawerDash extends StatefulWidget {
  const LeftDrawerDash({super.key});

  @override
  State<LeftDrawerDash> createState() => _LeftDrawerDashState();
}

class _LeftDrawerDashState extends State<LeftDrawerDash> {
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
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  );
                },
                child: SizedBox(
                  height: 45,
                  width: 240,
                  child: Image.asset('images/dash02.png'),
                ),
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TaskPage()),
                  );
                },
                child: SizedBox(
                  height: 45,
                  width: 240,
                  child: Image.asset('images/task02.png'),
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
                onTap: (){},
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
