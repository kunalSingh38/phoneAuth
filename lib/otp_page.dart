import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth_firebase/cubit/auth_cubit/auth_cubit.dart';
import 'package:phone_auth_firebase/cubit/auth_cubit/auth_state.dart';
import 'package:phone_auth_firebase/home.dart';

class OTPVerify extends StatefulWidget {
  const OTPVerify({Key? key}) : super(key: key);

  @override
  _OTPVerifyState createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  TextEditingController otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verification"),
      ),
      backgroundColor: Color(0xFFe7e5ee),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
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

                controller: otp,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding: EdgeInsets.all(5),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Enter OTP*",
                  hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                  // prefixIcon: Padding(
                  //   padding: const EdgeInsets.only(top: 14),
                  //   child: Text(
                  //     "+91",
                  //     textAlign: TextAlign.center,
                  //     style:
                  //         TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  //   ),
                  // ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
            if (state is AuthLoggedInState) {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            } else if (state is AuthErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
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
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green[700])),
                      onPressed: () {
                        BlocProvider.of<AuthCubit>(context).verifyOTP(otp.text);
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ))),
            );
          })),
        ],
      ),
    );
  }
}
