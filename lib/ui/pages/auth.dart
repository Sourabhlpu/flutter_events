import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_events/blocs/application_bloc/bloc.dart';
import 'package:flutter_events/models/users/user.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:flutter_events/blocs/auth_bloc/bloc.dart';


import '../widgets/loading_info.dart';
import '../widgets/primary_btn.dart';
import '../widgets/primary_btn_white.dart';

class Authentication extends StatefulWidget {
  final AppRepository repository;
  final ApplicationBloc applicationBloc;

  Authentication({@required this.repository, @required this.applicationBloc});

  @override
  _AuthenticationState createState() {
    return _AuthenticationState();
  }
}

class _AuthenticationState extends State<Authentication>
    with TickerProviderStateMixin {
  final _signInformKey = GlobalKey<FormState>();
  final _signupformKey = GlobalKey<FormState>();
  String _userName;
  String _email;
  String _phone;
  String _password;
  String _emailOrPhone;

  AuthBloc _bloc;
  bool obsecurePasswordField = true;
  TabController tabController;

  final List<Tab> tabs = <Tab>[
    Tab(text: 'Sign In'),
    Tab(text: 'Sign Up'),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: BlocListener(
                    bloc: _bloc,
                    listener: (context, state) {
                      if (state is SignupSuccess) {
                        Navigator.pushReplacementNamed(context, '/interests');
                      }

                      if (state is SigninSuccess) {
                        if (state.shouldInterests)
                          Navigator.pushReplacementNamed(context, '/interests');
                        else
                          Navigator.pushReplacementNamed(context, '/home');
                      }

                      if (state is AuthError) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('${state.error}'),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    child: BlocBuilder<AuthenticationEvents,
                            AuthenticationStates>(
                        bloc: _bloc,
                        builder:
                            (BuildContext context, AuthenticationStates state) {
                          return LoadingInfo(
                            isLoading: state is Loading,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TabBar(
                                  controller: tabController,
                                  tabs: tabs,
                                  labelColor: Theme.of(context).primaryColor,
                                  unselectedLabelColor: Colors.grey,
                                  indicatorPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  labelPadding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.loose,
                                  child: TabBarView(
                                    children: [
                                      _buildSignInForm(),
                                      _buildSignupForm()
                                    ],
                                    controller: tabController,
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  )),
            ),
          );
        },
      ),
      backgroundColor: Colors.white,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = AuthBloc(repository: widget.repository, applicationBloc: widget.applicationBloc);

    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(() {
      setState(() {
        obsecurePasswordField = true;
      });
    });
  }


  @override
  void dispose() {
     super.dispose();
    _bloc.dispose();
  }

  _buildEmailTextField(String hint) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: _getFormFieldInputDecoration(hint, Icons.email),
      validator: (value) => value.isEmpty ? 'please enter email' : null,
      onSaved: (value) => _emailOrPhone = value,
    );
  }

  _buildNameTextField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: _getFormFieldInputDecoration('Name', Icons.account_box),
      validator: (value) => value.isEmpty ? 'please enter name' : null,
      onSaved: (value) => _userName = value,
    );
  }

  _buildPasswordTextField(bool obscureText) {
    IconData iconData = obscureText ? Icons.remove_red_eye : Icons.lock;
    return TextFormField(
      obscureText: obscureText,
      decoration: _getFormFieldInputDecoration('Password', iconData),
      validator: (value) => value.isEmpty ? 'please enter password' : null,
      onSaved: (value) => _password = value,
    );
  }

  _buildPhoneTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: _getFormFieldInputDecoration('Phone', Icons.phone),
      validator: (value) => value.isEmpty ? 'please enter phone' : null,
      onSaved: (value) => _phone = value,
    );
  }

  Widget _buildSignInForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
      child: Form(
        key: _signInformKey,
        child: Column(
          children: <Widget>[
            _buildEmailTextField('Email  address / Phone Number'),
            SizedBox(
              height: 8.0,
            ),
            _buildPasswordTextField(obsecurePasswordField),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12.0),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            PrimaryGradientButton('Sign In', _doSignIn, false),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Or',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12.0),
                ),
              ),
            ),
            PrimaryWhiteButton('Sign In with google', _doSignInWithGoogle),
          ],
        ),
      ),
    );
  }

  Widget _buildSignupForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
      child: Form(
        key: _signupformKey,
        child: Column(
          children: <Widget>[
            _buildNameTextField(),
            SizedBox(
              height: 8.0,
            ),
            _buildEmailTextField('Email Address'),
            SizedBox(
              height: 8.0,
            ),
            _buildPhoneTextField(),
            SizedBox(
              height: 8.0,
            ),
            _buildPasswordTextField(obsecurePasswordField),
            SizedBox(
              height: 20.0,
            ),
            PrimaryGradientButton('Sign Up', _doSignUp, false),
          ],
        ),
      ),
    );
  }

  void _doSignIn() {
    if (_signInformKey.currentState.validate()) {
      _signInformKey.currentState.save();

      if (_emailOrPhone.contains('@')) {
        _email = _emailOrPhone;
      } else {
        _phone = _emailOrPhone;
      }
      User _user = User(
          name: _userName,
          email: _email,
          phoneNumber: _phone,
          password: _password);

      _bloc.dispatch(LoginButtonPressed(user: _user));
    }
  }

  void _doSignInWithGoogle() {
    _bloc.dispatch(SignInWithGooglePressed());
  }

  void _doSignUp() {
    if (_signupformKey.currentState.validate()) {
      _signupformKey.currentState.save();
      User _user = User(
          name: _userName,
          email: _emailOrPhone,
          phoneNumber: _phone,
          password: _password);

      _bloc.dispatch(SignupPressed(user: _user));
    }
  }

  InputDecoration _getFormFieldInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: IconButton(
          icon: Icon(
            icon,
            size: 16,
          ),
          onPressed: () {
            if (icon == Icons.remove_red_eye || icon == Icons.lock) {
              setState(() {
                obsecurePasswordField = !obsecurePasswordField;
              });
            }
          }),
      hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey[400]),
      hasFloatingPlaceholder: false,
      border: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Colors.grey[400])),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: const Color(0xFFED5D66))),
      disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Colors.grey[400])),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Colors.grey[400])),
      errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Colors.grey[400])),
      focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Colors.grey[400])),
    );
  }
}
