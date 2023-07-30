import 'package:flutter/material.dart';
import 'package:inventario/entities/gsheets/gsheets.dart';
import 'package:inventario/infrastructure/inventario.model.dart';

import '../../helpers/genuuid.dart';
import '../widgets/dropdown_field.dart';

class AddInventoryItemScreen extends StatefulWidget {
  @override
  _AddInventoryItemScreenState createState() => _AddInventoryItemScreenState();
}

class _AddInventoryItemScreenState extends State<AddInventoryItemScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

    Set<String> tipoOptions = {
  'herramienta',
  'consumibles',
  'antena',
  'componente de red',
  'cargador',
  'pieza drone',
  'electronica',
  'bateria',
  'cable',
};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Nuevo Elemento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre de la pieza'),
            ),
            TextFormField(
              controller: _brandController,
              decoration: InputDecoration(labelText: 'Marca'),
            ),
            TextFormField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Cantidad disponible'),
            ),
            TextFormField(
              controller: _unitPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Precio unitario'),
            ),
            DropdownField<String>(
                labelText: 'Tipo',
                items: tipoOptions.toList(),
                value: 'bateria',
                onChanged: (newValue) {
                  setState(() {
                    _typeController.text = newValue ?? _typeController.text;
                   
                  });
                }),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final newItem = InventoryItem(
                  id: generateUniqueId(), // Debes definir una función para generar un ID único
                  nombre: _nameController.text,
                  marca: _brandController.text,
                  cantidad: _quantityController.text,
                  precio: _unitPriceController.text,
                  tipo: _typeController.text,
                );

                await GoogleSheetsService.addInventoryItem(newItem);
                Navigator.pop(context, newItem); // Regresa el nuevo objeto al cerrar la pantalla
              },
              child: Text('Agregar elemento'),
            ),
          ],
        ),
      ),
    );
  }
}
