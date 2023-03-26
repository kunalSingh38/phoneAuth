// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:phone_auth_firebase/cubit/auth_cubit/auth_cubit.dart';
import 'package:phone_auth_firebase/cubit/auth_cubit/auth_state.dart';
import 'package:phone_auth_firebase/otp_page.dart';
import 'package:phone_auth_firebase/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController loginPhone = TextEditingController();
  List code = [];
  String _selectedCountryCode = '+91';
  bool loading = true;
  Future<void> loadCountryCodeJson() async {
    List temp = jsonDecode(await rootBundle.loadString("assets/code.json"));
    setState(() {
      code.clear();

      code.addAll(temp);
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCountryCodeJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      // SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: TextFormField(
                              // onTap: () {
                              //   getPhoneNumber();
                              // },
                              onChanged: (value) {
                                if (value.length == 10) {
                                  FocusScope.of(context).unfocus();
                                }
                              },
                              controller: loginPhone,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding: EdgeInsets.all(2),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                hintText: "Enter mobile number*",
                                hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButton<String>(
                                      value: _selectedCountryCode,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedCountryCode =
                                              value.toString();
                                        });
                                      },
                                      elevation: 9,
                                      items: code
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e['dial_code'].toString(),
                                              child: Text(
                                                e['dial_code'].toString(),
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )
                                          .toList()),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                    if (state is AuthCodeSentState) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => OTPVerify()));
                    }
                  }, builder: ((context, state) {
                    if (state is AuthLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.25,
                          height: 45,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.green[700])),
                              onPressed: () async {
                                bool isConnected =
                                    await InternetConnectionChecker()
                                        .hasConnection;

                                if (isConnected) {
                                  String phoneNo =
                                      _selectedCountryCode.toString() +
                                          loginPhone.text.toString();
                                  BlocProvider.of<AuthCubit>(context)
                                      .sentOTP(phoneNo);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("No Internet Connection")));
                                }
                              },
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 16),
                              ))),
                    );
                  })),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.25,
                        height: 45,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.green[700])),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyForm()));
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16),
                            ))),
                  )
                ],
              ));
  }
}
