import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/lib/services/auth/auth_exceptions.dart';
import 'package:mynotes/lib/services/auth/auth_service.dart';
import 'package:mynotes/lib/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/lib/services/auth/bloc/auth_event.dart';
import 'package:mynotes/lib/services/auth/bloc/auth_state.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/utilities/dialogs/error_dialog.dart';

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
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
                context, 'The password provided is too weak.');
          } else if (state.exception is EmailAlreadyUseAuthException) {
            await showErrorDialog(
                context, 'The account already exists for that email.');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'The email address is not valid.');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed to register');
          } else {
            await showErrorDialog(context, "Something went wrong");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
        ),
        body: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email here',
              ),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Enter your password here',
              ),
            ),
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
               context.read<AuthBloc>().add(const AuthEventLogout());
              },
              child: Text('Already registered? Log in here'),
            )
          ],
        ),
      ),
    );
  }
}
