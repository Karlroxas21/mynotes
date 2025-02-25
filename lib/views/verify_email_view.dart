import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/lib/services/auth/auth_service.dart';
import 'package:mynotes/lib/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/lib/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Verify Email')),
        body: Column(children: [
          const Text("We've sent you an email to verify your email address"),
          const Text(
              "If you haven't received the email, please check your spam folder"),
          TextButton(
              onPressed: () async {
                // await AuthService.firebase().sendEmailVerification();
                context
                    .read<AuthBloc>()
                    .add(const AuthEventSendEmailVerification());
              },
              child: const Text('Send verification email')),
          TextButton(
            onPressed: () async {
              // await AuthService.firebase().logout();
              // Navigator.of(context)
              //     .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                context
                    .read<AuthBloc>()
                    .add(const AuthEventLogout());
            },
            child: const Text('Restart'),
          ),
        ]));
  }
}
