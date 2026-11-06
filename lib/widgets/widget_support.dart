import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppWidget {
  static TextStyle boldTextFieldStyle() {
    return GoogleFonts.poppins(
        color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold);
  }

  static TextStyle headerTextFieldStyle() {
    return GoogleFonts.poppins(
        color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold);
  }

  static TextStyle lightTextFieldStyle() {
    return GoogleFonts.poppins(
        color: Colors.black38, fontSize: 15.0, fontWeight: FontWeight.w500);
  }

  static TextStyle semiBoldTextFieldStyle() {
    return GoogleFonts.poppins(
        color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600);
  }
}