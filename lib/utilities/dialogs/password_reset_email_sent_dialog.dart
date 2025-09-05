import 'package:flutter/material.dart';
import 'package:quicknotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Password Reset",
    content: "We have sent you a password reset link. Please check your email.",
    optionsBuilder: () => {"OK": null},
  );
}
