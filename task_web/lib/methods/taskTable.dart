import 'package:flutter/material.dart';
import 'package:task_web/sizes/pageSizes.dart';

class TaskTable extends StatefulWidget {
  const TaskTable({super.key});

  @override
  State<TaskTable> createState() => _TaskTableState();
}

class _TaskTableState extends State<TaskTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: getPageWidth(context)-260,
      height: 500,
      color: Colors.blueGrey,
    );
  }
}
