import 'package:flutter/material.dart';
import '/models/userModel.dart';
import '/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  String? _seessionToken;
  bool get isLoading => _isLoading;
  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  String? get error => _error;
  String? get token => _user?.token;
  String? get sessionToken => _seessionToken;

  Future<void> login(String phoneNumber, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _authService.login(phoneNumber, password);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _user = null;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(
    String firstName,
    String lastName,
    String phoneNumber,
    String password,
    String nationalId,
    String dateOfBirth,
    String? address,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.register(
        firstName,
        lastName,
        phoneNumber,
        password,
        nationalId,
        dateOfBirth,
        address,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _authService.verifyOtp(phoneNumber, otp);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _user = null;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSessionToken(String token) {
    _seessionToken = token;
    notifyListeners();
  }

  void deleteSessionToken() {
    _seessionToken = null;
    notifyListeners();
  }


  void logout() {
    _user = null;
    _seessionToken = null;
    _error = null;
    // notifyListeners();
  }
}
