import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:time_tracker/auth-page/email-signin-model.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({@required this.auth});
  final AuthBase auth;

  StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  EmailSignInModel _model = EmailSignInModel();

  void dispose() => _modelController.close();

  Future<void> onSubmit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmail(_model.email, _model.password);
      } else {
        await auth.createUserWithEmail(_model.email, _model.password);
      }
      // Navigator.of(context).pop();
    } catch (e) {
      debugPrint("FirebaseAuthException :" + e.toString());
      rethrow;
      // PlatformExceptionAwareDialog(
      //   title: "Sign in failed",
      //   firebaseAuthException: e,
      // ).show(context);
    } finally {
      updateWith(isLoading: false);
    }
  }

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
    bool isVisible,
  }) {
    //update model
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
      isVisible: isVisible,
    );
    //add updated model to _modelController
    _modelController.add(_model);
    // modelStream.last;
  }
}
