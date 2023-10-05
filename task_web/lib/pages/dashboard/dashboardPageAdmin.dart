import 'package:flutter/material.dart';
import 'package:task_web/drawers/adminDrawer.dart';
import 'package:task_web/drawers/adminSubDrawer.dart';
import 'package:task_web/methods/userTable.dart';

import '../../drawers/drawerDash.dart';
import '../../methods/appBar.dart';
import '../../methods/colors.dart';

class DashboardPageAdmin extends StatefulWidget {
  const DashboardPageAdmin({super.key});

  @override
  State<DashboardPageAdmin> createState() => _DashboardPageAdminState();
}

class _DashboardPageAdminState extends State<DashboardPageAdmin> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.grey,

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppBar(),
      ),

      body: Row(
        children: [
          AdminDrawer(),

        ],
      ),
    );
  }
}
