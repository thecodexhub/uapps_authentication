import 'dart:async';

import 'package:uapps_authentication/app/authentication_model.dart';

class AuthenticationBloc {
  final StreamController<AuthenticationModel> _modelController =
      StreamController<AuthenticationModel>();

  Stream<AuthenticationModel> get modelStream => _modelController.stream;

  AuthenticationModel _model = AuthenticationModel();

  void dispose() {
    _modelController.close();
  }

  void toggleForm(AuthenticationFormType formType) => updateWith(
      email: '', password: '', formType: formType);

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String email,
    String password,
    AuthenticationFormType formType,
  }) {
    // Update the model
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
    );

    // Add the updated model to the _modelController Stream
    _modelController.add(_model);
  }
}
