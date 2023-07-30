import 'package:flutter/material.dart';
import 'package:inventario/entities/gsheets/gsheets.dart';
import 'package:gsheets/gsheets.dart';

import 'package:inventario/infrastructure/inventario.model.dart';
import 'package:inventario/presentation/screens/inventoryScreen.dart';
import 'package:inventario/presentation/widgets/confirmation_dialog.widget.dart';
import 'package:inventario/presentation/widgets/dropdown_field.dart';

class EditInventoryItemScreen extends StatefulWidget {
  final InventoryItem item;

  EditInventoryItemScreen({required this.item});

  @override
  _EditInventoryItemScreenState createState() =>
      _EditInventoryItemScreenState();
}

class _EditInventoryItemScreenState extends State<EditInventoryItemScreen> {
  // Define los controladores de texto para los campos de edición
  TextEditingController _nameController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _unitPriceController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
  String? _selectedTipo;

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

  Future<bool?> _showConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const ConfirmationDialog(
          title: 'Confirmar cambios',
          message: '¿Estás seguro de que deseas guardar los cambios?',
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Llena los campos del formulario con los detalles actuales del elemento seleccionado
    _nameController.text = widget.item.nombre;
    _brandController.text = widget.item.marca;
    _quantityController.text = widget.item.cantidad.toString();
    _unitPriceController.text = widget.item.precio.toString();
    _typeController.text = widget.item.tipo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Elemento')),
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
                value: _typeController.text,
                onChanged: (newValue) {
                  setState(() {
                    _typeController.text = newValue ?? _typeController.text;
                   
                  });
                }),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final shouldSave = await _showConfirmationDialog(context);
                // Aquí puedes implementar la lógica para guardar los cambios y actualizar el elemento en Google Sheets
                // Por ejemplo, puedes llamar a una función en GoogleSheetsService para actualizar el elemento
                // Luego, puedes regresar a la pantalla anterior usando Navigator.pop
                // Ejemplo:
                if (shouldSave ?? false) {
                  final updatedItem = InventoryItem(
                    id: widget.item.id,
                    nombre: _nameController.text,
                    marca: _brandController.text,
                    cantidad: _quantityController.text,
                    precio: _unitPriceController.text,
                    tipo: _typeController.text,
                  );
                  print('TIPO XD :${updatedItem.tipo}');
                  await GoogleSheetsService.updateInventoryItem(updatedItem);
                }
              },
              child: const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
