import 'package:flutter/material.dart';
import '../widgets/widget_support.dart';
import '../service/database.dart'; 
import '../service/shared_pref.dart';

class Details extends StatefulWidget {
  // 1. Declaramos las variables que recibirá de la pantalla Home
  final String image;
  final String name;
  final String detail;
  final String price;

  const Details({
    super.key, 
    required this.image, 
    required this.name, 
    required this.detail, 
    required this.price
  });

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int cantidad = 1;
  String? id;

  // 2. Obtenemos el ID del usuario que inició sesión
  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getthesharedpref();
  }

  @override
  Widget build(BuildContext context) {
    // 3. Calculamos el precio total dinámicamente
    int precioBase = int.parse(widget.price);
    int total = precioBase * cantidad;

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
            ),
            
            // 4. Cambiamos Image.asset por Image.network usando la foto de ImgBB
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.image, 
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 15.0),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  // 5. Usamos el nombre real de la comida
                  child: Text(widget.name, style: AppWidget.semiBoldTextFieldStyle(), maxLines: 2),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
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
                        setState(() => cantidad++);
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
            
            // 6. Usamos el detalle real de la comida
            Text(
              widget.detail,
              style: AppWidget.lightTextFieldStyle(),
              maxLines: 3,
            ),
            const SizedBox(height: 30.0),
            
            Row(
              children: [
                const Text("Delivery Time", style: TextStyle(color: Colors.black54, fontSize: 16)),
                const SizedBox(width: 25.0),
                const Icon(Icons.alarm, color: Colors.black54),
                const SizedBox(width: 5.0),
                Text("30 min", style: AppWidget.semiBoldTextFieldStyle()),
              ],
            ),
            const Spacer(),
            
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Total Price", style: TextStyle(color: Colors.black54, fontSize: 16)),
                      // 7. Mostramos el total multiplicado
                      Text("\$$total", style: AppWidget.headerTextFieldStyle()),
                    ],
                  ),
                  
                  // 8. Botón funcional de Agregar al Carrito
                  GestureDetector(
                    onTap: () async {
                      if (id != null) {
                        Map<String, dynamic> addFoodToCart = {
                          "Name": widget.name,
                          "Quantity": cantidad.toString(),
                          "Total": total.toString(),
                          "Image": widget.image
                        };
                        
                        await DatabaseMethods().addFoodToCart(addFoodToCart, id!);
                        
                        if(!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("Food Added to Cart", style: TextStyle(fontSize: 18.0))));
                      }
                    },
                    child: Container(
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