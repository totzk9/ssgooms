import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nhost_sdk/nhost_sdk.dart';

import '../services/nhost_auth_service_impl.dart';
import '../services/nhost_graphql_service_impl.dart';
import 'view_model_template.dart';

class AuthViewModel extends ViewModelTemplate
    with INhostGraphQLService, INhostAuthService
    implements IAuthRepository {
  AuthViewModel() {
    if (kDebugMode) {
      emailController.text = 'test@gmail.com';
      passwordController.text = 'pass1234';
    }
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final GlobalKey<FormState> loginForm = GlobalKey<FormState>();

  bool isEmailChanged = false;
  bool isPasswordChanged = false;

  void onEmailChanged(String value) {
    if (isEmailChanged) {
      return;
    }
    isEmailChanged = true;
  }

  void onPasswordChanged(String value) {
    if (isPasswordChanged) {
      return;
    }
    isPasswordChanged = true;
  }

  @override
  Future<bool> signIn() async {
    isEmailChanged = false;
    isPasswordChanged = false;
    if (isLoading) {
      return false;
    }
    if (loginForm.currentState?.validate() == false) {
      return false;
    }
    try {
      startLoading();
      final AuthResponse res = await authClient.signInEmailPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      stopLoading();
      if (res.user?.id == null) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    super.dispose();
  }
}

abstract class IAuthRepository {
  Future<bool> signIn();
}
