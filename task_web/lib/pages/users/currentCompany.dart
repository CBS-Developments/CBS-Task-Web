import 'package:flutter/material.dart';
import 'package:task_web/methods/companyTable.dart';

import '../../drawers/adminSubDrawer.dart';
import '../../drawers/userDrawer.dart';
import '../../methods/appBar.dart';
import '../../methods/userTable.dart';

class CurrentCompany extends StatefulWidget {
  const CurrentCompany({Key? key}) : super(key: key);

  @override
  State<CurrentCompany> createState() => _CurrentCompanyState();
}

class _CurrentCompanyState extends State<CurrentCompany> {
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
          UserDrawer(),
          AdminSubDrawer(),
          Column(
            children: [
              CompanyTable()
            ],
          )

        ],
      ),

    );
  }
}
