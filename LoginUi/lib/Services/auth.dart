import 'package:LoginUi/Models/user.dart';
import 'package:LoginUi/Services/dio.dart';
import 'package:dio/dio.dart ' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth extends ChangeNotifier {
  bool _isLoggdin = false;
  User _user;
  String _token;
  User get user => _user;
  final storage = new FlutterSecureStorage();
  bool get authenticated => _isLoggdin;
  // ignore: non_constant_identifier_names
  void Login(Map creds) async {
    print(creds);
    print({_isLoggdin.toString()});
    try {
      Dio.Response response = await dio().post("/sanctum/token", data: creds);
      print(response.data);
      String token = response.data.toString();
      this.tryToken(token: token);
    } catch (e) {
      print(e);
    }
  }

  void tryToken({String token}) async {
    if (token == null) {
      return;
    } else {
      try {
        Dio.Response response = await dio().get('/user',
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        this._isLoggdin = true;
        this._token = token;
        this._user = User.fromJson(response.data);
        this.storeToken(token: token);
        notifyListeners();
        print(_user);
      } catch (e) {
        print(e);
      }
    }
  }

  void storeToken({String token}) async {
    //pour garder les token dans le stockage interne sans connecter a chaque fois
    this.storage.write(key: 'token', value: token);
  }

  // ignore: non_constant_identifier_names
  void Logout() async {
    try {
      Dio.Response response = await dio().get("/user/revoke",
          options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));
      cleanUp();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void cleanUp() async {
    this._user = null;
    this._isLoggdin = false;
    this._token = null;
    await storage.delete(key: 'token');
  }
}
