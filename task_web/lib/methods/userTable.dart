import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_web/pages/users/editUser.dart';

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

  Future<void> _showUserDetailsDialog(User user) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: ${user.firstName} ${user.lastName}'),
              Text('Email: ${user.email}'),
              Text('Mobile Number: 0${user.phone}'),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
      width: 800,
      height: 233,
      child: Column(
        children: [
          Container(
            width: 800,
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
                    '$userCount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 800,
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
                        fontSize: 11,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Email',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Edit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
                rows: userList.map((user) {
                  return DataRow(cells: [
                    DataCell(Text(
                      user.userName,
                      style: TextStyle(fontSize: 10, color: Colors.black),
                    )),
                    DataCell(
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                      onTap: () {
                        _showUserDetailsDialog(user);
                        getUserList();
                      },
                    ),
                    DataCell(Text(
                      user.email,
                      style: TextStyle(fontSize: 10, color: Colors.black),
                    )),
                    DataCell(
                      Text(
                        user.activate == '1' ? 'Active' : 'Deactivated',
                        style: TextStyle(
                          fontSize: 10,
                          color:
                              user.activate == '1' ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                    DataCell(
                      Switch(
                        value: user.activate == '1' ? true : false,
                        onChanged: (value) {
                          setState(() {
                            user.activate = value ? '1' : '0';
                          });
                          userStatusToggle(user.userName, value);
                        },
                        activeColor: Colors.green,
                        inactiveTrackColor: Colors.redAccent.withOpacity(0.5),
                      ),
                    ),
                    DataCell(
                      Icon(Icons.edit_note_rounded),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditUserPage(
                                    firstName: user.firstName,
                                    lastName: user.lastName,
                                    email: user.email,
                                    password: user.password,
                                    phone: user.phone,
                                    employeeID: user.employeeID,
                                    designation: user.designation,
                                    company: user.company, userName: user.userName,
                                  )),
                        );
                      },
                    ),
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
    final res = await http.post(
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
      userCount = userList.length;
      print("User Count: $userCount");
    } else {
      throw Exception('Failed to load users from API');
    }
  }

  Future<void> userStatusDeactivate(String userName) async {
    var data = {
      "user_name": userName,
      "activate": '0',
    };

    const url = "http://dev.workspace.cbs.lk/userStatus.php";
    final res = await http.post(
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

  Future<void> userStatusActivate(String userName) async {
    var data = {
      "user_name": userName,
      "activate": '1',
    };

    const url = "http://dev.workspace.cbs.lk/userStatus.php";
    final res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );

    if (res.statusCode.toString() == "true") {
      Map<String, dynamic> result = jsonDecode(res.body);
      print(result);
    }
  }
}

Future<void> userStatusToggle(String userName, bool activate) async {
  var data = {
    "user_name": userName,
    "activate": activate ? '1' : '0',
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

  if (res.statusCode == 200) {
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
  String employeeID = '';
  String designation = '';
  String company = '';
  String userRole = '';
  String activate = '';

  User({
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
    required this.employeeID,
    required this.designation,
    required this.company,
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
      employeeID: json['employee_ID'],
      designation: json['designation'],
      company: json['company'],
      userRole: json['user_role'],
      activate: json['activate'],
    );
  }
}
