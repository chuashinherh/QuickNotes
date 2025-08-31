import 'package:flutter/material.dart';
import 'package:quicknotes/constants/routes.dart';
import 'package:quicknotes/services/auth/auth_service.dart';
import 'package:quicknotes/views/login_view.dart';
import 'package:quicknotes/views/notes/create_update_note_view.dart';
import 'package:quicknotes/views/notes/notes_view.dart';
import 'package:quicknotes/views/register_view.dart';
import 'package:quicknotes/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  MaterialApp app = MaterialApp(
    title: 'Quick Notes',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      notesRoute: (context) => const NotesView(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  );

  runApp(app);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService service = AuthService.firebase();
    return FutureBuilder(
      future: service.initialize(),
      builder: (context, asyncSnapshot) {
        switch (asyncSnapshot.connectionState) {
          case ConnectionState.done:
            final user = service.currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return Scaffold(
              body: Center(child: const CircularProgressIndicator()),
            );
        }
      },
    );
  }
}
