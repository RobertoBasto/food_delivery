import 'package:flutter/material.dart';
import '../widgets/widget_support.dart';
import 'signup.dart';
import 'bottomnav.dart'; // Para entrar a la app

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
          // Formulario central
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
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        const SizedBox(height: 30.0),
                        Text("Login", style: AppWidget.headerTextFieldStyle()),
                        const SizedBox(height: 30.0),
                        // Campo Email
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: AppWidget.semiBoldTextFieldStyle(),
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        // Campo Contraseña (texto oculto)
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: AppWidget.semiBoldTextFieldStyle(),
                            prefixIcon: const Icon(Icons.password_outlined),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          alignment: Alignment.topRight,
                          child: Text("Forgot Password?", style: AppWidget.semiBoldTextFieldStyle()),
                        ),
                        const SizedBox(height: 40.0),
                        // Botón de Entrar (Temporalmente nos lleva al BottomNav)
                        GestureDetector(
                          onTap: () {
                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNav()));
                          },
                          child: Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              width: 200,
                              decoration: BoxDecoration(color: const Color(0Xffff5722), borderRadius: BorderRadius.circular(20)),
                              child: const Center(
                                child: Text("LOGIN", style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                // Botón para ir a registro
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));
                  },
                  child: Text("Don't have an account? Sign up", style: AppWidget.semiBoldTextFieldStyle()),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}