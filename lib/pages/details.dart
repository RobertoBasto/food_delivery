import 'package:flutter/material.dart';
import '../widgets/widget_support.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  int cantidad = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Botón de regresar
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
            ),
            
            // Imagen del platillo (Ajustada al tamaño de pantalla)
            Image.asset(
              "images/salad2.png", // o .jpg según lo que guardaste
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3, // Ocupa 1/3 de la pantalla
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 15.0),
            
            // Título y Controles de Cantidad
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text("Veggie Taco Hash", style: AppWidget.semiBoldTextFieldStyle(), maxLines: 2),
                ),
                // Controles de Menos y Más
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // LÓGICA DEFENSIVA: Solo resta si es mayor a 1
                        if (cantidad > 1) {
                          setState(() => cantidad--);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.remove, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    Text(cantidad.toString(), style: AppWidget.semiBoldTextFieldStyle()),
                    const SizedBox(width: 15.0),
                    GestureDetector(
                      onTap: () {
                        setState(() => cantidad++); // Aumenta sin límite
                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20.0),
            
            // Descripción del platillo
            Text(
              "A delicious and healthy veggie taco hash made with fresh ingredients, perfect for a balanced meal.",
              style: AppWidget.lightTextFieldStyle(),
              maxLines: 3,
            ),
            const SizedBox(height: 30.0),
            
            // Tiempo de entrega
            Row(
              children: [
                const Text("Delivery Time", style: TextStyle(color: Colors.black54, fontSize: 16)),
                const SizedBox(width: 25.0),
                const Icon(Icons.alarm, color: Colors.black54),
                const SizedBox(width: 5.0),
                Text("30 min", style: AppWidget.semiBoldTextFieldStyle()),
              ],
            ),
            const Spacer(), // Empuja el botón al fondo de la pantalla
            
            // Botón de Precio Total y Añadir al Carrito
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Total Price", style: TextStyle(color: Colors.black54, fontSize: 16)),
                      // Calculamos el precio dinámicamente multiplicando por la cantidad
                      Text("\$${(25 * cantidad)}", style: AppWidget.headerTextFieldStyle()),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Add to cart", style: TextStyle(color: Colors.white, fontSize: 16)),
                        Icon(Icons.shopping_cart_outlined, color: Colors.white),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}