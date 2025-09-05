import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotes/services/auth/auth_exceptions.dart';
import 'package:quicknotes/services/auth/bloc/auth_bloc.dart';
import 'package:quicknotes/services/auth/bloc/auth_event.dart';
import 'package:quicknotes/services/auth/bloc/auth_state.dart';
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, "This is an invalid email address");
          } else if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              "Weak password, please enter a minimum of 6 characters",
            );
          } else if (state.exception is ChannelErrorAuthException) {
            await showErrorDialog(
              context,
              "Please enter an email and password",
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Failed to register");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Register")),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Enter your email and password to see your notes!"),
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                    hintText: "Enter your email here",
                  ),
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
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
                Center(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          context.read<AuthBloc>().add(
                            AuthEventRegister(email, password),
                          );
                        },
                        child: const Text("Register"),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(const AuthEventLogOut());
                        },
                        child: Text("Already registered? Login here!"),
                      ),
                    ],
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
