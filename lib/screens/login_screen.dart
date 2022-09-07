import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void postLogin() async {
    try {
      var data = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      final Response response = await Dio().post("http://192.168.2.242:3001/auth/signin",
          data: data,
          options: Options(
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
          ));
      print('ora');
      print(response);
    } on DioError catch (e) {
      if(e.response?.statusCode == 400){
        print(e.response?.statusCode);
        print(e.response?.data['message']);
      }else{
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid mail';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your password',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter valid password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        postLogin();
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
