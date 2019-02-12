import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return new Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              TabBar(
                tabs: [
                  Tab(text: 'Sign In'),
                  Tab(text: 'Sign Up'),
                ],
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                labelPadding: const EdgeInsets.symmetric(vertical: 4.0),
              ),
              Expanded(
                child: TabBarView(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 16.0),
                    child: Column(
                      children: <Widget>[
                        _buildEmailTextField(),
                        SizedBox(
                          height: 8.0,
                        ),
                        _buildPasswordTextField(),
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ]),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Email  address / Phone Number',
        suffixIcon: Icon(
          Icons.email,
          size: 16.0,
        ),
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
      ),
    );
  }

  _buildPasswordTextField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        suffixIcon: Icon(
          Icons.remove_red_eye,
          size: 16.0,
        ),
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
      ),
    );
  }
}
