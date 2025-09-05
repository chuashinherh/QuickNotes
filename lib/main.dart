import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotes/constants/routes.dart';
import 'package:quicknotes/helpers/loading/loading_screen.dart';
import 'package:quicknotes/services/auth/bloc/auth_bloc.dart';
import 'package:quicknotes/services/auth/bloc/auth_event.dart';
import 'package:quicknotes/services/auth/bloc/auth_state.dart';
import 'package:quicknotes/services/auth/firebase_auth_provider.dart';
import 'package:quicknotes/views/forgot_password_view.dart';
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
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
    routes: {
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  );

  runApp(app);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? "Please wait a moment",
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
