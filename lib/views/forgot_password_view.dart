import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotes/services/auth/auth_exceptions.dart';
import 'package:quicknotes/services/auth/bloc/auth_bloc.dart';
import 'package:quicknotes/services/auth/bloc/auth_event.dart';
import 'package:quicknotes/services/auth/bloc/auth_state.dart';
import 'package:quicknotes/utilities/dialogs/error_dialog.dart';
import 'package:quicknotes/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            if (state.exception is InvalidEmailAuthException) {
              await showErrorDialog(context, "Please enter a valid email.");
            } else if (state.exception is ChannelErrorAuthException) {
              await showErrorDialog(
                context,
                "Please enter your email address.",
              );
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(
                context,
                "We could not process your request. Please make sure that you are a registered user, or if not, register a user now by going back one step.",
              );
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Forgot Password")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "If you forgot your password, simply enter your email and we will send you a password reset link.",
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Enter your email address",
                ),
              ),
              TextButton(
                onPressed: () {
                  final email = _controller.text;
                  context.read<AuthBloc>().add(
                    AuthEventForgotPassword(email: email),
                  );
                },
                child: Text("Send me a password reset link"),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: Text("Back to login page"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
