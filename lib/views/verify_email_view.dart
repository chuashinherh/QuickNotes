import 'package:flutter/material.dart';
import 'package:quicknotes/constants/routes.dart';
import 'package:quicknotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    final service = AuthService.firebase();
    final user = service.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Column(
        children: [
          Text(
            "A verification email has been sent to: ${user?.email}\nClick the link in the email to verify your email address.",
          ),
          const Text(
            "If you have not received a verification email yet, press the button below",
          ),
          TextButton(
            onPressed: () async {
              await service.sendEmailVerification();
            },
            child: const Text("Send email verification"),
          ),
          TextButton(
            onPressed: () async {
              await service.logOut();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: Text("Return to account registration"),
          ),
        ],
      ),
    );
  }
}
