import 'package:flutter/material.dart';
import 'package:task_web/sizes/pageSizes.dart';

class TaskTable extends StatefulWidget {
  final List<DataRow> generateRows; // Pass the list through the widget's constructor

  const TaskTable({Key? key, required this.generateRows}) : super(key: key);

  @override
  State<TaskTable> createState() => _TaskTableState();
}

class _TaskTableState extends State<TaskTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: getPageWidth(context) - 260,
      height: 450,
      color: Colors.white,
      child: SingleChildScrollView(
        child: DataTable(columns: [
          DataColumn(
            label: Text(
              'Task',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          DataColumn(
            label: Text('Start Date',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          DataColumn(
            label: Text('End Date',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          DataColumn(
            label: Text('Description',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          DataColumn(
            label: Text('Status',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          DataColumn(
            label: Text(''),
          ),
        ], rows: widget.generateRows), // Access the generateRows list from widget
      ),
    );
  }
}
