import 'package:LoginUi/Services/auth.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class LoginSecreen extends StatefulWidget {
  @override
  _LoginSecreenState createState() => _LoginSecreenState();
}

class _LoginSecreenState extends State<LoginSecreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String _device_name;
  @override
  void initState() {
    _emailController.text = "abdessamed@gmail.com";
    _passwordController.text = "password";
    getDeviceName();
    super.initState();
  }

  void getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        _device_name = androidInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        _device_name = iosInfo.utsname.machine;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                validator: (value) =>
                    value.isEmpty ? 'Please enter valide email !!' : null,
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _passwordController,
                validator: (value) =>
                    value.isEmpty ? 'Please enter valide password !! ' : null,
              ),
              SizedBox(
                height: 30,
              ),
              FlatButton(
                hoverColor: Colors.blue,
                color: Colors.redAccent,
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 25, color: Colors.greenAccent),
                ),
                onPressed: () {
                  Map creds = {
                    'email': _emailController.text,
                    'password': _passwordController.text,
                    'device_name': _device_name ?? 'Unknown',
                  };

                  if (_formKey.currentState.validate()) {
                    Provider.of<Auth>(context, listen: false).Login(creds);
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
