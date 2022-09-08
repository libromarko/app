import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void getUserGroups(token) async {
    final Response response = await Dio().get("http://192.168.2.242:3001/group/user",
        options: Options(
          headers: { "Authorization": "Bearer $token" }
        )
    );

    print(response);
  }

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      var key = prefs.getString('access_token');
      getUserGroups(key);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Groups")),
        body: const SafeArea(
          child: Text('Groups'),
        )
    );
  }
}
