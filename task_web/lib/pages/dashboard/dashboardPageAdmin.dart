import 'package:flutter/material.dart';
import 'package:task_web/methods/userTable.dart';

import '../../drawers/drawerDash.dart';
import '../../methods/appBar.dart';

class DashboardPageAdmin extends StatefulWidget {
  const DashboardPageAdmin({super.key});

  @override
  State<DashboardPageAdmin> createState() => _DashboardPageAdminState();
}

class _DashboardPageAdminState extends State<DashboardPageAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppBar(),
      ),

      body: Row(
        children: [
          LeftDrawerDash(),
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
