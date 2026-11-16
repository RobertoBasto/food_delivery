import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'widgets/app_constant.dart';
import '/pages/onboard.dart';
import 'firebase_options.dart';

void main() async {
  // Esto asegura que los widgets estén listos antes de iniciar Firebase o Stripe
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // sirve para inicializar Stripe con tu clave publicable
  Stripe.publishableKey = AppConstant.publishableKey;
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food App',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: { PointerDeviceKind.mouse, PointerDeviceKind.touch },
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Onboard(), 
    );
  }
}