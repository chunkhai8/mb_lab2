

import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'mainpage.dart';
import 'register.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double screenHeight,screenWidth;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
      screenHeight = MediaQuery.of(context).size.height;
      screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                    height: screenHeight/2.5,
                    width: screenWidth,
                    child: Image.asset('assets/images/logo1.png')),
                    const Text(
                      "Login",
                       style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter valid email';
                          }
                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);
                          if (!emailValid) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          // if (value.length < 6) {
                          //   return "Password must be at least 6 characters";
                          // }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: screenWidth,
                        height: 50,
                        child:  ElevatedButton(
                          child: const Text("Login"),
                          onPressed: _loginUser,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: screenWidth,
                        height: 50,
                        child:  ElevatedButton(
                          child: const Text("Sign Up"),
                          onPressed: _RegisterUser,
                        ),
                      )
                    ],   
                )     
            )
          ],
        ),
      ),
      ),
    );
  }

void _RegisterUser(){
  Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (content) => const RegisterPage()));
}

void _loginUser(){
   String _email = _emailController.text;
    String _password = _passwordController.text;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      http.post(
          Uri.parse(CONSTANTS.server + "/mytutor/login.php"),
          body: {
            "email": _email,
            "password": _password,
            }).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (content) => const MainScreen()));
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        }
      });
    }
  
}



// void _onRememberMeChanged(bool value) {
//   remember = value;
//     setState(() {
//       if (remember) {
//         _saveRemovePref(true);
//       } else {
//         _saveRemovePref(false);
//       }
//     });
// }


}

