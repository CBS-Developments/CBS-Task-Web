import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


import '../components.dart';

class TaskLog extends StatefulWidget {
  TaskLog({Key? key}) : super(key: key ?? ValueKey<String>('taskLog'));

  @override
  State<TaskLog> createState() => _TaskLogState();
}

class _TaskLogState extends State<TaskLog> {
  List<taskLog> taskLogList = [];

  @override
  void initState() {
    super.initState();
    getTaskLogList();
  }
  Future<List<taskLog>> getTaskLogList() async {
    final now = DateTime.now();
    final s_year = DateFormat('yyyy').format(now);
    final s_month = DateFormat('MM').format(now);

    final data = {
      "log_create_by_year": "$s_year",
      "log_create_by_month": "$s_month"
    };

    const url = "http://dev.connect.cbs.lk/taskLogListByMonth.php";
    final http.Response res = await http.post(
      url,
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      encoding: Encoding.getByName("utf-8"),
    );

    if (res.statusCode == 200) {
      final jsonResponse = jsonDecode(res.body);
      if (jsonResponse != "Error") {
        final taskLogs = (jsonResponse as List<dynamic>?)
            ?.map((sec) => taskLog.fromJson(sec))
            .toList() ?? [];

        // Sort taskLogs by logCreateByTimestamp in descending order
        taskLogs.sort((a, b) =>
            b.logCreateByTimestamp.compareTo(a.logCreateByTimestamp));

        setState(() {
          taskLogList = taskLogs;
        });

        return taskLogs;
      }
    } else {
      throw Exception('Failed to load task logs from API');
    }

    return [];
  }


  Widget rowDataAsTaskLog(BuildContext context, taskLog? taskLogItem, int index) {
    if (taskLogItem == null) {
      // Handle the case where taskLogItem is null
      return Container(); // Or display an error message
    }

    final double textFontSmall =12;

    final int? time = int.tryParse(taskLogItem.logCreateByTimestamp ?? '0');

    if (time != null) {
      final DateTime a = DateTime.fromMillisecondsSinceEpoch(time);
      final DateTime b = DateTime.now();

      final Duration difference = b.difference(a);

      final int days = difference.inDays % 365 % 30;
      final int hours = difference.inHours % 24;
      final int minutes = difference.inMinutes % 60;
      final int seconds = difference.inSeconds % 60;

      if (difference.inMinutes <= 15) {
        return Container(
          height: (MediaQuery.of(context).size.height * 0.06),
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Flexible(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          taskLogItem.logSummary,
                          style: TextStyle(
                              fontSize: textFontSmall,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SelectableText(
                          taskLogItem.taskId ?? '',
                          style: TextStyle(
                              fontSize: textFontSmall,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "$minutes minute(s) $seconds second(s).",
                          style: TextStyle(
                              fontSize: textFontSmall,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      } else if (difference.inMinutes >= 16 && difference.inMinutes < 1440) {
        return Container(
          height: (MediaQuery.of(context).size.height * 0.05),
          width: MediaQuery.of(context).size.width,
          color: const Color.fromARGB(255, 245, 244, 181),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Container(
                      child: Flexible(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            taskLogItem.logSummary,
                            style: TextStyle(
                                fontSize: textFontSmall,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SelectableText(
                          taskLogItem.taskId ?? '',
                          style: TextStyle(
                              fontSize: textFontSmall,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "$hours hour(s) $minutes minute(s) $seconds second(s).",
                          style: TextStyle(
                              fontSize: textFontSmall,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        return Container(
          height: (MediaQuery.of(context).size.height * 0.05),
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Container(
                      child: Flexible(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            taskLogItem.logSummary ?? '',
                            style: TextStyle(fontSize: textFontSmall),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SelectableText(
                          taskLogItem.taskId ?? '',
                          style: TextStyle(
                              fontSize: textFontSmall,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          taskLogItem.logCreateByDate ?? '',
                          style: TextStyle(
                              fontSize: textFontSmall,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    } else {
      // Handle the case where time is null (invalid format)
      return Container(); // Or display an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 200,
      width: 600,
      child: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<taskLog>>(
              future: getTaskLogList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text("No data available");
                } else {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: rowDataAsTaskLog(
                          context,
                          snapshot.data![index],
                          (index + 1),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
