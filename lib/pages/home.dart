import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/widget_support.dart';
import '../service/database.dart';
import 'details.dart';
import 'add_food.dart'; //prueba del panel, quitar depues

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Cambiamos el valor inicial a "Pizza" respetando la mayúscula de Firebase
  String categoriaSeleccionada = "Pizza";
  Stream? fooditemStream;

  ontheload() async {
    fooditemStream = await DatabaseMethods().getFoodItem(categoriaSeleccionada);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  // Widget dinámico que reemplaza tu carrusel estático
  Widget allItems() {
    return StreamBuilder(
      stream: fooditemStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return _buildProductoCard(
                    ds["Name"], 
                    ds["Detail"], 
                    "\$" + ds["Price"], 
                    ds["Image"] // Descarga la imagen desde la web
                  );
                })
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


   // --- INICIO DEL BOTÓN TEMPORAL DE PRUEBA ---/////////////////////////////////////////////////////
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFood()));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    // --- FIN DEL BOTÓN TEMPORAL ---////////////////////////////////////////////////////////////////

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
                // Ajustamos las mayúsculas iniciales para que coincidan con la base de datos
                _buildCategoriaItem("Ice-cream", "images/ice-cream.png"),
                _buildCategoriaItem("Pizza", "images/pizza.png"),
                _buildCategoriaItem("Salad", "images/salad.png"),
                _buildCategoriaItem("Burger", "images/burger.png"),
              ],
            ),
            const SizedBox(height: 30.0),

            // Carrusel horizontal de productos (Ahora conectado a la nube)
            SizedBox(
              height: 270,
              child: allItems(),
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
      onTap: () async {
        categoriaSeleccionada = idCategoria; // Actualiza el estado
        fooditemStream = await DatabaseMethods().getFoodItem(categoriaSeleccionada);
        setState(() {});
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
  Widget _buildProductoCard(String titulo, String subtitulo, String precio, String imageUrl) {
    return GestureDetector(
      onTap: () {

  Navigator.push(context, MaterialPageRoute(builder: (context) => Details(
  name: titulo,
  detail: subtitulo,
  price: precio.replaceAll("\$", ""),
  image: imageUrl,
  )));
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(imageUrl, height: 150, width: 150, fit: BoxFit.cover),
                ),
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