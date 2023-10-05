import 'package:flutter/material.dart';
import 'package:task_web/drawers/userDrawer.dart';

import '../../drawers/adminDrawer.dart';
import '../../drawers/adminSubDrawer.dart';
import '../../methods/appBar.dart';
import '../../methods/userTable.dart';

class CurrentUser extends StatefulWidget {
  const CurrentUser({Key? key}) : super(key: key);

  @override
  State<CurrentUser> createState() => _CurrentUserState();
}

class _CurrentUserState extends State<CurrentUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppBar(),
      ),

      body: Row(
        children: [
          UserDrawer(),
          AdminSubDrawer(),

          Column(
            children: [
              UserTable()
            ],
          )
        ],
      ),
    );
  }
}
