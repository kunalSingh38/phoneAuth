import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth_firebase/cubit/auth_cubit/auth_cubit.dart';
import 'package:phone_auth_firebase/cubit/auth_cubit/auth_state.dart';
import 'package:phone_auth_firebase/home.dart';
import 'package:phone_auth_firebase/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {},
            builder: ((context, state) {
              Timer(Duration(seconds: 2), () {
                if (state is AuthLoggedInState) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                } else if (state is AuthLoggedoutState) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }
              });

              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.teal,
                child: Center(
                  child: Text(
                    "Splash Screen",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              );
            })));
  }
}
