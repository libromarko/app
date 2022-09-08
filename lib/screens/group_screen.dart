import 'package:app/screens/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/group_model.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isLoading = true;
  late List<Group> _groups;

  void getUserGroups(token) async {
    try {
      final Response response = await Dio().get(
          "http://192.168.2.242:3001/group/user",
          options: Options(headers: {"Authorization": "Bearer $token"}));

      setState(() {
        _groups =
            (response.data as List).map((i) => Group.fromJson(i)).toList();
        _isLoading = false;
      });
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        _prefs.then((SharedPreferences prefs) {
          prefs.remove('counter');

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        });
      }
    }
  }

  @override
  void initState() {
    _prefs.then((SharedPreferences prefs) {
      var key = prefs.getString('access_token');
      getUserGroups(key);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Groups")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _groups.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    final group = _groups[index];

                    return ListTile(
                      title: Text(group.name),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () => {print(group.id)},
                    );
                  },
                  itemCount: _groups.length,
                )
              : const Center(
                  child: Text("No User Object"),
                ),
    );
  }
}
