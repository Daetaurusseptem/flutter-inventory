import 'package:flutter/material.dart';
import 'package:inventario/entities/gsheets/gsheets.dart';
import 'package:gsheets/gsheets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inventario/infrastructure/inventario.model.dart';
import 'package:inventario/presentation/screens/inventoryScreen.dart';
void main()async {
  await dotenv.load(fileName: ".env");
  await dotenv.load();
  await  GoogleSheetsService.init(); // Inicializar la comunicación con Google Sheets
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  @override
  Widget build(BuildContext context) {
      
    return  MaterialApp(
      darkTheme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(2, 22, 184, 35)
      ),
      title: 'DSM',
      home: InventoryScreen(),
      routes: {
        'inventory':(context) =>  InventoryScreen()
      },
    );
  }
}

