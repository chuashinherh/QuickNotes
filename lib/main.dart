import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     AuthService service = AuthService.firebase();
//     return FutureBuilder(
//       future: service.initialize(),
//       builder: (context, asyncSnapshot) {
//         switch (asyncSnapshot.connectionState) {
//           case ConnectionState.done:
//             final user = service.currentUser;
//             if (user != null) {
//               if (user.isEmailVerified) {
//                 return const NotesView();
//               } else {
//                 return const VerifyEmailView();
//               }
//             } else {
//               return const LoginView();
//             }
//           default:
//             return Scaffold(
//               body: Center(child: const CircularProgressIndicator()),
//             );
//         }
//       },
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Testing bloc")),
        body: BlocConsumer<CounterBloc, CounterState>(
          builder: (context, state) {
            final invalidValue = (state is CounterStateInvalidNumber)
                ? state.invalidValue
                : "";

            return Column(
              children: [
                Text("Current value => ${state.value}"),
                Visibility(
                  visible: state is CounterStateInvalidNumber,
                  child: Text("Invalid input: $invalidValue"),
                ),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Enter a number here",
                  ),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        context.read<CounterBloc>().add(
                          DecrementEvent(_controller.text),
                        );
                      },
                      child: const Text("-"),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<CounterBloc>().add(
                          IncrementEvent(_controller.text),
                        );
                      },
                      child: const Text("+"),
                    ),
                  ],
                ),
              ],
            );
          },
          listener: (context, state) {
            _controller.clear();
          },
        ),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;

  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(super.value);
}

class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;
  const CounterStateInvalidNumber({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(super.value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(super.value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(
          CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(CounterStateValid(state.value + integer));
      }
    });
    on<DecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(
          CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(CounterStateValid(state.value - integer));
      }
    });
  }
}
