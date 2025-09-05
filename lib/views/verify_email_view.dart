import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotes/services/auth/auth_user.dart';
import 'package:quicknotes/services/auth/bloc/auth_bloc.dart';
import 'package:quicknotes/services/auth/bloc/auth_event.dart';
import 'package:quicknotes/services/auth/bloc/auth_state.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        late final AuthUser user;
        if (state is AuthStateNeedsVerification) {
          user = state.user;
        }
        return Scaffold(
          appBar: AppBar(title: const Text("Verify Email")),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "A verification email has been sent to: ${user.email}\nClick the link in the email to verify your email address.",
                ),
                const Text(
                  "If you have not received a verification email yet, press the button below",
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      const AuthEventSendEmailVerification(),
                    );
                  },
                  child: const Text("Send email verification"),
                ),
                TextButton(
                  onPressed: () async {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  child: Text("Return to login"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
