import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:mynotes/lib/services/auth/auth_provider.dart';
import 'package:mynotes/lib/services/auth/bloc/auth_event.dart';
import 'package:mynotes/lib/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(const AuthStateNeedsVerification());
      emit(state);
    });

    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;

      try {
        await provider.createUser(email: email, password: password);

        await provider.sendEmailVerification();
      } on Exception catch (e) {
        emit(AuthStateRegistering(e));
      }
    });

    on<AuthEventInitialize>((event, emit) async {
      provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    on<AuthEventLogIn>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.login(email: email, password: password);

        if (!user.isEmailVerified) {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(const AuthStateNeedsVerification());
        }else{
            emit(const AuthStateLoggedOut(exception: null, isLoading: false));
            emit(AuthStateLoggedIn(user));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    on<AuthEventLogout>((event, emit) async {
      try{
        await provider.logout();
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      }on Exception catch(e){
        emit(AuthStateLoggedOut(exception: e, isLoading: false));  
      }
    });
  }
}
