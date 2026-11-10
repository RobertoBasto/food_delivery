import 'package:flutter/material.dart';
import '../widgets/widget_support.dart';
import 'details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String categoriaSeleccionada = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Saludo y Carrito
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Hello Shivam", style: AppWidget.boldTextFieldStyle()),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.shopping_cart, color: Colors.white),
                )
              ],
            ),
            const SizedBox(height: 20.0),
            
            // Textos principales
            Text("Delicious Food", style: AppWidget.headerTextFieldStyle()),
            Text("Discover and Get Great Food", style: AppWidget.lightTextFieldStyle()),
            const SizedBox(height: 20.0),

            // Fila de Categorías (Llamando a nuestro método optimizado)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCategoriaItem("ice-cream", "images/ice-cream.png"),
                _buildCategoriaItem("pizza", "images/pizza.png"),
                _buildCategoriaItem("salad", "images/salad.png"),
                _buildCategoriaItem("burger", "images/burger.png"),
              ],
            ),
            const SizedBox(height: 30.0),

            // Carrusel horizontal de productos
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildProductoCard("Veggie Taco Hash", "Fresh and Healthy", "\$25", "images/salad2.png"),
                  _buildProductoCard("Mix Veg Salad", "Spicy with Onion", "\$28", "images/salad2.png"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // MÉTODO PARA CREAR CATEGORÍAS
  Widget _buildCategoriaItem(String idCategoria, String imagePath) {
    bool isSelected = categoriaSeleccionada == idCategoria;

    return GestureDetector(
      onTap: () {
        setState(() {
          categoriaSeleccionada = idCategoria; // Actualiza el estado
        });
      },
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(10)),
          child: Image.asset(
            imagePath,
            height: 40,
            width: 40,
            fit: BoxFit.cover,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // MÉTODO PARA CREAR TARJETAS DE PRODUCTOS (2. ACTUALIZADO CON NAVEGACIÓN)
  Widget _buildProductoCard(String titulo, String subtitulo, String precio, String imagePath) {
    return GestureDetector(
      onTap: () {
        // Navega a la pantalla Details cuando tocan la tarjeta
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Details()));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20.0, bottom: 5.0),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(imagePath, height: 150, width: 150, fit: BoxFit.cover),
                Text(titulo, style: AppWidget.semiBoldTextFieldStyle()),
                const SizedBox(height: 5.0),
                Text(subtitulo, style: AppWidget.lightTextFieldStyle()),
                const SizedBox(height: 5.0),
                Text(precio, style: AppWidget.semiBoldTextFieldStyle()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}