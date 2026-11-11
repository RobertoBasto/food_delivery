import 'package:flutter/material.dart';
import '../widgets/widget_support.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.5,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFff5c30), Color(0xFFe74b1a)],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            child: const Text(""),
          ),
          Container(
            margin: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
            child: Column(
              children: [
                Center(child: Image.asset("images/logo.png", width: MediaQuery.of(context).size.width / 2.5, fit: BoxFit.cover)),
                const SizedBox(height: 50.0),
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.8,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        const SizedBox(height: 30.0),
                        Text("Sign Up", style: AppWidget.headerTextFieldStyle()),
                        const SizedBox(height: 30.0),
                        TextField(
                          decoration: InputDecoration(hintText: 'Name', hintStyle: AppWidget.semiBoldTextFieldStyle(), prefixIcon: const Icon(Icons.person_outlined)),
                        ),
                        const SizedBox(height: 30.0),
                        TextField(
                          decoration: InputDecoration(hintText: 'Email', hintStyle: AppWidget.semiBoldTextFieldStyle(), prefixIcon: const Icon(Icons.email_outlined)),
                        ),
                        const SizedBox(height: 30.0),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(hintText: 'Password', hintStyle: AppWidget.semiBoldTextFieldStyle(), prefixIcon: const Icon(Icons.password_outlined)),
                        ),
                        const SizedBox(height: 40.0),
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            width: 200,
                            decoration: BoxDecoration(color: const Color(0Xffff5722), borderRadius: BorderRadius.circular(20)),
                            child: const Center(
                              child: Text("SIGN UP", style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: Text("Already have an account? Login", style: AppWidget.semiBoldTextFieldStyle()),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}