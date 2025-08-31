import 'package:flutter/material.dart';
import 'package:quicknotes/constants/routes.dart';
import 'package:quicknotes/services/auth/auth_exceptions.dart';
import 'package:quicknotes/services/auth/auth_service.dart';
import 'package:quicknotes/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(
              hintText: "Enter your email here",
            ),
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(
              hintText: "Enter your password here",
            ),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              AuthService service = AuthService.firebase();

              try {
                await service.createUser(email: email, password: password);
                await service.sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  "This is an invalid email address",
                );
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  "Weak password, please enter a minimum of 6 characters",
                );
              } on ChannelErrorAuthException {
                await showErrorDialog(
                  context,
                  "Please enter an email and password",
                );
              } on GenericAuthException {
                await showErrorDialog(context, "Failed to register");
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: Text("Already registered? Login here!"),
          ),
        ],
      ),
    );
  }
}
