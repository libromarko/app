import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/group_model.dart';
import 'bookmark_screen.dart';
import 'login_screen.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isLoading = true;
  late List<Group> _groups;
  late String _key;

  Future<void> getUserGroups(token) async {
    try {
      final Response response = await Dio().get(
          "https://api.libromarko.xyz/group/user",
          options: Options(headers: {"Authorization": "Bearer $token"}));

      setState(() {
        _groups =
            (response.data as List).map((i) => Group.fromJson(i)).toList();
        _isLoading = false;
      });
    } on DioError catch (e) {
      _isLoading = false;
      if (e.response?.statusCode == 401) {
        _prefs.then((SharedPreferences prefs) {
          prefs.remove('access_token');

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
      setState(() {
        _key = key!;
      });
      getUserGroups(key);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Groups"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              _prefs.then((SharedPreferences prefs) {
                prefs.remove('access_token');

                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
              });
            },
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _groups.isNotEmpty
              ? RefreshIndicator(
                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                  onRefresh: () async {
                    await getUserGroups(_key);
                  },
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final group = _groups[index];

                      return ListTile(
                        title: Text(group.name),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => BookmarkScreen(
                                      name: group.name,
                                      id: group.id,
                                    )),
                          )
                        },
                      );
                    },
                    itemCount: _groups.length,
                  ),
                )
              : const Center(
                  child: Text("There are no groups."),
                ),
    );
  }
}
