enum AuthenticationFormType { authentication, register, forgottenPassword }

class AuthenticationModel {
  AuthenticationModel({
    this.email: '',
    this.password: '',
    this.formType: AuthenticationFormType.authentication,
  });

  final String email;
  final String password;
  final AuthenticationFormType formType;

  AuthenticationModel copyWith({
    String email,
    String password,
    AuthenticationFormType formType,
  }) {
    return AuthenticationModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
    );
  }
}
