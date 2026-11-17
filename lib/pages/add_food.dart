import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../service/database.dart';
import '../widgets/app_constant.dart'; // Ajusta la ruta si es necesario

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final List<String> fooditems = ['Ice-cream', 'Burger', 'Pizza', 'Salad'];
  String? value;
  
  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();
  
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool isUploading = false; // Para mostrar indicador de carga

  // Función para abrir la galería
  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  // Función combinada: Sube a ImgBB y luego guarda en Firebase
  Future<void> uploadItem() async {
    if (selectedImage != null &&
        namecontroller.text.isNotEmpty &&
        pricecontroller.text.isNotEmpty &&
        detailcontroller.text.isNotEmpty &&
        value != null) {
          
      setState(() {
        isUploading = true; // Inicia la carga
      });

      try {
        // 1. Enviar imagen a ImgBB vía HTTP
        String apiUrl = "https://api.imgbb.com/1/upload";
        var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
        request.fields['key'] = AppConstant.imgbbApiKey;
        request.files.add(await http.MultipartFile.fromPath('image', selectedImage!.path));

        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var result = String.fromCharCodes(responseData);
        var jsonResult = jsonDecode(result);

        if (jsonResult['success']) {
          // 2. Obtener el link público que nos dio ImgBB
          String downloadUrl = jsonResult['data']['url'];

          // 3. Crear el mapa de datos para Firebase
          Map<String, dynamic> addItem = {
            "Image": downloadUrl,
            "Name": namecontroller.text,
            "Price": pricecontroller.text,
            "Detail": detailcontroller.text
          };

          // 4. Guardar en Firestore bajo la categoría elegida
          await DatabaseMethods().addFoodItem(addItem, value!);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.green,
              content: Text("Food Item has been added Successfully", style: TextStyle(fontSize: 18.0))));
          
          // Limpiar el formulario
          setState(() {
            selectedImage = null;
            namecontroller.clear();
            pricecontroller.clear();
            detailcontroller.clear();
            value = null;
          });
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("Error: $e")));
      } finally {
        setState(() {
          isUploading = false; // Detiene la carga
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text("Please fill all the fields and select an image", style: TextStyle(fontSize: 18.0))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new_outlined, color: Color(0xFF373866))),
        centerTitle: true,
        title: const Text(
          "Add Item",
          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Upload the Item Picture", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20.0),
              
              // Selector de Imagen
              selectedImage == null
                  ? GestureDetector(
                      onTap: getImage,
                      child: Center(
                        child: Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.camera_alt_outlined, color: Colors.black, size: 50),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 30.0),
              
              // Campos de Texto
              const Text("Item Name", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: const Color(0xFFececf8), borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: namecontroller,
                  decoration: const InputDecoration(border: InputBorder.none, hintText: "Enter Item Name", hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(height: 30.0),
              
              const Text("Item Price", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: const Color(0xFFececf8), borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: pricecontroller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(border: InputBorder.none, hintText: "Enter Item Price", hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(height: 30.0),
              
              const Text("Item Detail", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: const Color(0xFFececf8), borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  maxLines: 4,
                  controller: detailcontroller,
                  decoration: const InputDecoration(border: InputBorder.none, hintText: "Enter Item Detail", hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(height: 20.0),
              
              const Text("Select Category", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: const Color(0xFFececf8), borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: fooditems
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item, style: const TextStyle(fontSize: 18, color: Colors.black)),
                            ))
                        .toList(),
                    onChanged: ((value) => setState(() {
                          this.value = value;
                        })),
                    dropdownColor: Colors.white,
                    hint: const Text("Select Category"),
                    iconSize: 36,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                    value: value,
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              
              // Botón de Subida
              GestureDetector(
                onTap: isUploading ? null : uploadItem,
                child: Center(
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      width: 150,
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: isUploading
                            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text(
                                "Add",
                                style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}