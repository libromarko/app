import 'dart:async';
import 'package:app/screens/group_screen.dart';
import 'package:app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const LoadingPage(),
    );
  }
}

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> getMe(token) async {
    try {
      await Dio().get("http://192.168.2.242:3001/user/me",
          options: Options(headers: {"Authorization": "Bearer $token"}));

      return true;
    } on DioError catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      var key = prefs.getString('access_token');
      if (key != null) {
        getMe(key).then((value) => {
              if (value)
                {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const GroupScreen()))
                }
              else
                {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginScreen()))
                }
            });
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6b40b9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/ic_launcher_adaptive_fore.png')
          ],
        ),
      ),
    );
  }
}
