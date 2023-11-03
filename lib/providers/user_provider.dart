// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:omar/models/user.dart';
import 'package:omar/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
// the _user has to be private field
  User? _user;

  final AuthMethods _authMethods = new AuthMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
