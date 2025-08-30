import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quicknotes/firebase_options.dart';
import 'package:quicknotes/views/login_view.dart';
import 'package:quicknotes/views/register_view.dart';

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
      "/login/": (context) => const LoginView(),
      "/register/": (context) => const RegisterView(),
    },
  );

  runApp(app);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, asyncSnapshot) {
        switch (asyncSnapshot.connectionState) {
          case ConnectionState.done:
            // final user = FirebaseAuth.instance.currentUser;
            // if (user?.emailVerified ?? false) {
            //   return const Text("Done");
            // } else {
            //   return const VerifyEmailView();
            // }
            return const LoginView();
          default:
            return Scaffold(
              body: Center(child: const CircularProgressIndicator()),
            );
        }
      },
    );
  }
}
