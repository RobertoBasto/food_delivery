import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../widgets/widget_support.dart';
import '../widgets/app_constant.dart';
import '../service/database.dart';
import '../service/shared_pref.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  Map<String, dynamic>? paymentIntent;

  // Variables para guardar tu ID y tu Saldo
  String? wallet, id;

  // Función para leer cuánto dinero tienes al abrir la pantalla
  getthesharedpref() async {
    wallet = await SharedPreferenceHelper().getUserWallet();
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  onTheLoad() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    onTheLoad();
  }

  // Función principal para iniciar el cobro
  makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!['client_secret'],
              merchantDisplayName: 'Food App'));

      displayPaymentSheet(amount);
    } catch (e, s) {
      debugPrint('exception:$e$s');
    }
  }

  // Función para dibujar el recuadro de la tarjeta y ACTUALIZAR EL SALDO
  displayPaymentSheet(String amount) async {
    try {
      // Agregamos 'async' aquí adentro para poder guardar en la base de datos
      await Stripe.instance.presentPaymentSheet().then((value) async {
        
        // --- AQUÍ SUCEDE LA MAGIA DEL SALDO ---
        // 1. Leemos el saldo actual (si está vacío, asumimos 0)
        int currentWallet = int.tryParse(wallet ?? '0') ?? 0;
        // 2. Sumamos lo que recargaste
        int add = currentWallet + int.parse(amount);
        
        // 3. Lo guardamos en el celular
        await SharedPreferenceHelper().saveUserWallet(add.toString());
        // 4. Lo subimos a Firebase (solo si hay un usuario logueado)
        if (id != null) {
          await DatabaseMethods().updateUserWallet(id!, add.toString());
        }
        
        // 5. Refrescamos la pantalla para ver el nuevo número
        await getthesharedpref(); 
        // --------------------------------------

        if (!mounted) return;

        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 50.0),
                      SizedBox(height: 10.0),
                      Text("Payment Successful!",
                          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                    ],
                  ),
                ));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        debugPrint('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      debugPrint('Error is:---> $e');

      if (!mounted) return;

      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Payment Cancelled"),
              ));
    } catch (e) {
      debugPrint('$e');
    }
  }

  // Se comunica con el servidor de Stripe 
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${AppConstant.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      return jsonDecode(response.body);
    } catch (err) {
      debugPrint('err charging user: ${err.toString()}');
      return null;
    }
  }

  // Stripe procesa el dinero en centavos, así que multiplicamos por 100
  String calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount) * 100);
    return calculatedAmount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2.0,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Center(
                  child: Text("Wallet", style: AppWidget.headerTextFieldStyle()),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Color(0xFFF2F2F2)),
              child: Row(
                children: [
                  Image.asset("images/wallet.png", height: 60, width: 60, fit: BoxFit.cover),
                  const SizedBox(width: 40.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Your Wallet", style: AppWidget.semiBoldTextFieldStyle()),
                      const SizedBox(height: 5.0),
                      // ¡AQUÍ ESTÁ EL TEXTO DINÁMICO QUE MOSTRARÁ TU SALDO REAL!
                      Text("\$ ${wallet ?? '0'}", style: AppWidget.headerTextFieldStyle())
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text("Add money", style: AppWidget.semiBoldTextFieldStyle()),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => makePayment("100"),
                  child: makeMoneyContainer("\$100"),
                ),
                GestureDetector(
                  onTap: () => makePayment("500"),
                  child: makeMoneyContainer("\$500"),
                ),
                GestureDetector(
                  onTap: () => makePayment("1000"),
                  child: makeMoneyContainer("\$1000"),
                ),
                GestureDetector(
                  onTap: () => makePayment("2000"),
                  child: makeMoneyContainer("\$2000"),
                ),
              ],
            ),
            const SizedBox(height: 50.0),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: const Color(0xFF008080), borderRadius: BorderRadius.circular(8)),
                child: const Center(
                  child: Text(
                    "Add Money",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget makeMoneyContainer(String amount) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE9E2E2)),
          borderRadius: BorderRadius.circular(5)),
      child: Text(
        amount,
        style: AppWidget.semiBoldTextFieldStyle(),
      ),
    );
  }
}