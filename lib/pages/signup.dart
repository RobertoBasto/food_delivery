import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/widget_support.dart';
import 'login.dart';
import 'bottomnav.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Variables y Controladores
  String email = "", password = "", name = "";
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();
  
  final _formkey = GlobalKey<FormState>();

  // Función para registrar en Firebase
  Future<void> registration() async {
    if (password.isNotEmpty && email.isNotEmpty) {
      try {
        // 1. Crea el usuario en Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
            
        // 2. Guarda los datos en Firestore Database
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .set({
          "Name": namecontroller.text,
          "Email": mailcontroller.text,
          "Id": userCredential.user!.uid,
        });
            
        // Validamos que la pantalla siga activa antes de usar 'context'
        if (!mounted) return; 
        
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Registered Successfully", style: TextStyle(fontSize: 20.0))));
            
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNav()));
      } on FirebaseAuthException catch (e) {
        
        // Validamos también aquí por si falla
        if (!mounted) return; 

        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text("Password Provided is too Weak", style: TextStyle(fontSize: 18.0))));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text("Account Already exists", style: TextStyle(fontSize: 18.0))));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo degradado superior
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
          // Contenedor blanco curvo
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
          // Formulario central envuelto en SingleChildScrollView
          SingleChildScrollView(
            child: Container(
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
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            const SizedBox(height: 30.0),
                            Text("Sign Up", style: AppWidget.headerTextFieldStyle()),
                            const SizedBox(height: 30.0),
                            TextFormField(
                              controller: namecontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Please Enter Name';
                                return null;
                              },
                              decoration: InputDecoration(hintText: 'Name', hintStyle: AppWidget.semiBoldTextFieldStyle(), prefixIcon: const Icon(Icons.person_outlined)),
                            ),
                            const SizedBox(height: 30.0),
                            TextFormField(
                              controller: mailcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Please Enter E-mail';
                                return null;
                              },
                              decoration: InputDecoration(hintText: 'Email', hintStyle: AppWidget.semiBoldTextFieldStyle(), prefixIcon: const Icon(Icons.email_outlined)),
                            ),
                            const SizedBox(height: 30.0),
                            TextFormField(
                              controller: passwordcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Please Enter Password';
                                return null;
                              },
                              obscureText: true,
                              decoration: InputDecoration(hintText: 'Password', hintStyle: AppWidget.semiBoldTextFieldStyle(), prefixIcon: const Icon(Icons.password_outlined)),
                            ),
                            const SizedBox(height: 40.0),
                            GestureDetector(
                              onTap: () async {
                                if (_formkey.currentState!.validate()) {
                                  setState(() {
                                    email = mailcontroller.text;
                                    name = namecontroller.text;
                                    password = passwordcontroller.text;
                                  });
                                  registration();
                                }
                              },
                              child: Material(
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
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LogIn()));
                    },
                    child: Text("Already have an account? Login", style: AppWidget.semiBoldTextFieldStyle()),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}