import 'package:flutter/material.dart';
import 'package:task_web/sizes/pageSizes.dart';

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
      child: Column(

      )
    );

  }
}
