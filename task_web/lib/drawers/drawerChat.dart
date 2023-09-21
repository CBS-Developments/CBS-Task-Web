import 'package:flutter/material.dart';
import 'package:task_web/pages/chatPage.dart';

import '../pages/taskMainPage.dart';
import '../pages/taskPageOne.dart';
import '../sizes/pageSizes.dart';

class DrawerChat extends StatelessWidget {
  const DrawerChat({super.key});

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
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatPage()),
                  );
                },
                child: SizedBox(
                  height: 45,
                  width: 240,
                  child: Image.asset('images/cht.png'),
                ),
              ),
            ],
          ),
        ));
  }
}
