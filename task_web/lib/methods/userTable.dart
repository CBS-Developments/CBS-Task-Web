import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:task_web/methods/colors.dart';

class UserTable extends StatefulWidget {
  @override
  _UserTableState createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  List<User> userList = [];
  int userCount = 0;

  @override
  void initState() {
    super.initState();
    getUserList();
  }

  // Method to show user details dialog
  void _showUserDetailsDialog(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('Name: ${user.firstName} ${user.lastName}'),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('Email: ${user.email}'),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('Mobile Number: 0${user.phone}'),
              ),

              SizedBox(
                height: 10,
              ),
              Center(
                child: user.activate == "1"
                    ? TextButton(
                  onPressed: () {
                    userStatus(user.userName);
                    Navigator.of(context).pop();
                    getUserList();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Deactivate User',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                )
                    : TextButton(
                  onPressed: () {
                    // Handle activation logic here
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Activate User',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
              ),

              // Add more user details here
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();// Close the dialog
                getUserList();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      width: 500,
      height: 233,
      child: Column(
        children: [
          Container(
            width: 500,
            height: 33,
            color: Colors.grey.shade300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Users:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$userCount', // Convert userCount to a string here
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ],
            ),
          ),
          Container(
            width: 600,
            height: 200,
            color: Colors.white,
            child: SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text(
                      'ID',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColor.table,
                          fontSize: 11),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Name',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColor.table,
                          fontSize: 11),
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      'Email',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColor.table,
                          fontSize: 11),
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      'Status',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColor.table,
                          fontSize: 11),
                    ),
                  ),
                  // Add more DataColumn as needed
                ],
                rows: userList.map((user) {
                  return DataRow(cells: [
                    DataCell(Text(user.userName,
                        style: TextStyle(fontSize: 10, color: Colors.black))),
                    DataCell(
                      Text(user.firstName + ' ' + user.lastName,
                          style: TextStyle(fontSize: 10, color: Colors.black)),
                      onTap: () {
                        // Show user details dialog when the name is clicked
                        _showUserDetailsDialog(user);
                      },
                    ),
                    DataCell(Text(user.email,
                        style: TextStyle(fontSize: 10, color: Colors.black))),

                    DataCell(
                      RichText(
                        text: TextSpan(
                          text: user.activate == "1" ? 'Active' : 'Deactivated',
                          style: TextStyle(
                            fontSize: 10,
                            color: user.activate == "1" ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ),
                    // Add more DataCell with other user properties
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getUserList() async {
    userList.clear();
    var data = {};

    const url = "http://dev.workspace.cbs.lk/userList.php";
    http.Response res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );

    if (res.statusCode == 200) {
      final responseJson = json.decode(res.body) as List<dynamic>;
      setState(() {
        for (Map<String, dynamic> details in responseJson) {
          userList.add(User.fromJson(details));
        }
      });
      // Get the user count here
      userCount = userList.length;
      print("User Count: $userCount");
    } else {
      throw Exception('Failed to load users from API');
    }
  }
}

Future<void> userStatus(String userName) async {
  var data = {
    "user_name": userName,
    "activate": '0',
  };

  const url = "http://dev.workspace.cbs.lk/userStatus.php";
  http.Response res = await http.post(
    Uri.parse(url),
    body: data,
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
    },
  );

  if (res.statusCode.toString() == "200") {
    Map<String, dynamic> result = jsonDecode(res.body);
    print(result);
  }
}

class User {
  String userName = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String phone = '';
  String userRole = '';
  String activate = '';

  User({
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
    required this.userRole,
    required this.activate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['user_name'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      password: json['password_'],
      phone: json['phone'],
      userRole: json['user_role'],
      activate: json['activate'],
    );
  }
}
