// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth_firebase/cubit/auth_cubit/auth_cubit.dart';
import 'package:phone_auth_firebase/cubit/auth_cubit/auth_state.dart';
import 'package:phone_auth_firebase/login_page.dart';
import 'package:phone_auth_firebase/splash.dart';
import 'package:phone_auth_firebase/update_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data = [];
  final db = FirebaseFirestore.instance;
  Future<void> getAllUsers() async {
    QuerySnapshot querySnapshot = await db.collection("Users").get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      data.clear();
      data.addAll(allData);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
            if (state is AuthLoggedoutState) {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SplashScreen()));
            }
          }, builder: (context, state) {
            return IconButton(
                onPressed: () {
                  BlocProvider.of<AuthCubit>(context).logout();
                },
                icon: Icon(Icons.logout));
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: data
                .map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Text("First Name : " + e["first"].toString()),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Last Name : " + e["last"].toString()),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Email ID : " + e["email"].toString()),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Phone No : " + e["phone"].toString()),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Address : " + e["address"].toString()),
                            SizedBox(
                              height: 5,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateUser(m: e)));
                                },
                                child: Text("Edit"))
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
      // body: Center(
      //   child: BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
      //     if (state is AuthLoggedoutState) {
      //       Navigator.popUntil(context, (route) => route.isFirst);
      //       Navigator.pushReplacement(context,
      //           MaterialPageRoute(builder: (context) => SplashScreen()));
      //     }
      //   }, builder: (context, state) {
      //     return Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 30),
      //       child: SizedBox(
      //           width: MediaQuery.of(context).size.width / 1.25,
      //           height: 45,
      //           child: ElevatedButton(
      //               style: ButtonStyle(
      //                   backgroundColor:
      //                       MaterialStateProperty.all(Colors.green[700])),
      //               onPressed: () {
      //                 BlocProvider.of<AuthCubit>(context).logout();
      //               },
      //               child: Text(
      //                 "Logout",
      //                 style:
      //                     TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
      //               ))),
      //     );
      //   }),
      // ),
    );
  }
}
