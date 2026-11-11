import 'package:flutter/material.dart';
import '../widgets/widget_support.dart';
import '../widgets/content_model.dart';
import 'signup.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(contents[i].image, height: 300, fit: BoxFit.contain),
                      const SizedBox(height: 40.0),
                      Text(contents[i].title, style: AppWidget.headerTextFieldStyle(), textAlign: TextAlign.center),
                      const SizedBox(height: 20.0),
                      Text(contents[i].description, style: AppWidget.lightTextFieldStyle(), textAlign: TextAlign.center)
                    ],
                  ),
                );
              },
            ),
          ),
          // Indicador de Puntos (Dots)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              contents.length,
              (index) => Container(
                height: 10.0,
                width: currentIndex == index ? 18.0 : 7.0, // El punto activo es más ancho
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.black38,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40.0),
          // Botón Next / Start
          GestureDetector(
            onTap: () {
              if (currentIndex == contents.length - 1) {
                // Si es la última página, vamos a Registro
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUp()));
              }
              _controller.nextPage(duration: const Duration(milliseconds: 100), curve: Curves.bounceIn);
            },
            child: Container(
              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
              height: 60,
              margin: const EdgeInsets.all(40),
              width: double.infinity,
              child: Center(
                child: Text(
                  currentIndex == contents.length - 1 ? "Start" : "Next",
                  style: const TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}