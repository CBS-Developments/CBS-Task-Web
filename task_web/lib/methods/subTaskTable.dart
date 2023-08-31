import 'package:flutter/material.dart';

class SubTaskTable extends StatefulWidget {
  const SubTaskTable({super.key});

  @override
  State<SubTaskTable> createState() => _SubTaskTableState();
}

class _SubTaskTableState extends State<SubTaskTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 100,
      color: Colors.grey.shade200,
    );
  }
}
