import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uapps_authentication/app/authentication_bloc.dart';
import 'package:uapps_authentication/app/authentication_model.dart';
import 'package:uapps_authentication/common_widgets/authentication_button.dart';
import 'package:uapps_authentication/utils/app_colors.dart';
import 'package:uapps_authentication/utils/strings.dart';

class AuthenticationPage extends StatefulWidget {
  AuthenticationPage({Key key, @required this.bloc}) : super(key: key);
  final AuthenticationBloc bloc;

  static Widget create(BuildContext context) {
    return Provider<AuthenticationBloc>(
      create: (_) => AuthenticationBloc(),
      dispose: (context, bloc) => bloc.dispose(),
      child: Consumer<AuthenticationBloc>(
        builder: (context, bloc, _) {
          return AuthenticationPage(bloc: bloc);
        },
      ),
    );
  }

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  List<String> _backgroundImages = [
    Strings.firstBackgroundImage,
    Strings.secondBackgroundImage,
    Strings.thirdBackgroundImage,
  ];

  AnimationController _controller;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _slideAnimation = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(_controller);

    Timer(Duration(seconds: 1), () {
      _controller.forward();
    });

    Timer.periodic(Duration(seconds: 3), (timer) async {
      if (mounted) {
        setState(() {
          if (_currentIndex + 1 == _backgroundImages.length) {
            _currentIndex = 0;
          } else {
            _currentIndex = _currentIndex + 1;
          }
        });
      }
    });
  }

  List<Widget> _showChildren(AuthenticationModel model) {
    if (model.formType == AuthenticationFormType.authentication) {
      return _buildAuthenticationChildren();
    } else if (model.formType == AuthenticationFormType.register) {
      return _buildRegisterChildren();
    } else {
      return _buildForgottenPasswordChildren();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 1000),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                child: child,
                opacity: animation,
              );
            },
            child: _buildBackgroundWidget(size),
          ),
          Positioned(
            bottom: 0,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                height: size.height * (2 / 3),
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Connection',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24.0),
                          ),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 24.0),
                        child: StreamBuilder<AuthenticationModel>(
                            stream: widget.bloc.modelStream,
                            initialData: AuthenticationModel(),
                            builder: (context, snapshot) {
                              final AuthenticationModel model = snapshot.data;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: _showChildren(model),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAuthenticationChildren() {
    return [
      Text(
        'AUTHENTICATION',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.redColor,
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextField(
        decoration: InputDecoration(
          hintText: 'Email',
        ),
        onChanged: widget.bloc.updateEmail,
      ),
      TextField(
        decoration: InputDecoration(
          hintText: 'Password',
        ),
        onChanged: widget.bloc.updatePassword,
      ),
      SizedBox(height: 16.0),
      AuthenticationButton(
        label: 'CONNECT',
        color: AppColors.blueColor,
        textColor: Colors.white,
        onPressed: () {},
      ),
      SizedBox(height: 8.0),
      FlatButton(
        onPressed: () {
          _controller.reverse().then((value) {
            widget.bloc.toggleForm(AuthenticationFormType.forgottenPassword);
            _controller.forward();
          });
        },
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        // These two lines of codes ensure that there will be no splash effect when tapping this button
        // If splash effect is needed, for betterment of UI change the shape of the button.
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Text(
          'Forgotten password',
          style: TextStyle(
            fontSize: 15.0,
            color: AppColors.blueColor,
          ),
        ),
      ),
      Spacer(),
      Text(
        '-OR-',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black38,
          fontSize: 18.0,
        ),
      ),
      SizedBox(height: 12.0),
      AuthenticationButton(
        label: 'REGISTER',
        color: AppColors.redColor,
        textColor: Colors.white,
        onPressed: () {
          _controller.reverse().then((value) {
            widget.bloc.toggleForm(AuthenticationFormType.register);
            _controller.forward();
          });
        },
      ),
    ];
  }

  List<Widget> _buildRegisterChildren() {
    return [
      Text(
        'REGISTER',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.redColor,
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      AuthenticationButton(
        label: 'BACK TO AUTHENTICATION',
        color: AppColors.redColor,
        textColor: Colors.white,
        onPressed: () {
          _controller.reverse().then((value) {
            widget.bloc.toggleForm(AuthenticationFormType.authentication);
            _controller.forward();
          });
        },
      ),
    ];
  }

  List<Widget> _buildForgottenPasswordChildren() {
    return [
      Text(
        'FORGOTTEN PASSWORD',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.redColor,
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      AuthenticationButton(
        label: 'BACK TO AUTHENTICATION',
        color: AppColors.redColor,
        textColor: Colors.white,
        onPressed: () {
          _controller.reverse().then((value) {
            widget.bloc.toggleForm(AuthenticationFormType.authentication);
            _controller.forward();
          });
        },
      ),
    ];
  }

  Widget _buildBackgroundWidget(Size size) {
    double screenWidth = size.width;
    double screenHeight = size.height;
    return Container(
      key: ValueKey<int>(_currentIndex),
      height: screenHeight,
      width: screenWidth,
      child: Image.asset(
        _backgroundImages[_currentIndex],
        fit: BoxFit.cover,
      ),
    );
  }
}
