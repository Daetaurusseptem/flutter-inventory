import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inventario/entities/gsheets/gsheets.dart';

import 'package:inventario/infrastructure/inventario.model.dart';
import 'package:inventario/presentation/screens/add_inventory_item_screen.dart';
import 'package:inventario/presentation/screens/edit_inventory_screen.dart';

import '../widgets/confirmation_dialog.widget.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<InventoryItem> _inventory = [];
  List<InventoryItem> _filteredInventory = []; // Lista filtrada para mostrar elementos de acuerdo a la búsqueda


  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  FutureOr onGoBack(dynamic value) {
    _loadInventory();
    setState(() {});
  }

  Future<void> _loadInventory() async {
    final inventory = await GoogleSheetsService.getInventory();
    setState(() {
      _inventory = inventory;
    });
  }

  void _searchInventory(String query) {
  setState(() {
    if (query.isEmpty) {
      // Si el término de búsqueda está vacío, mostrar la lista completa
      _filteredInventory = _inventory;
    } else {
      // Filtrar la lista de elementos en base a la búsqueda
      _filteredInventory = _inventory.where((item) {
        final nameLower = item.nombre.toLowerCase();
        final brandLower = item.marca.toLowerCase();
        final typeLower = item.tipo  .toLowerCase();
        final searchLower = query.toLowerCase();
        return nameLower.contains(searchLower) ||
            brandLower.contains(searchLower) ||
            typeLower.contains(searchLower);
      }).toList();
    }
  });
}


  Future<void> _addNewInventoryItem() async {
    final newItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddInventoryItemScreen(),
      ),
    );

    if (newItem != null) {
      setState(() {
        _inventory.add(newItem); // Agrega el nuevo elemento a la lista _inventory
      });
    }
  }

  void _addInventoryItem(InventoryItem item) async {
    await GoogleSheetsService.addInventoryItem(item);
    _loadInventory();
  }

  void _updateInventoryItem(InventoryItem item) async {
    await GoogleSheetsService.updateInventoryItem(item);
    _loadInventory();
  }
  

  void _deleteInventoryItem(String itemId) async {

    final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (context) {
      return const ConfirmationDialog(
        title: 'Confirmar eliminación',
        message: '¿Estás seguro de que deseas eliminar este elemento?',
      );
    },
  );

  if (shouldDelete ?? false) {
    // Realizar la eliminación del elemento
    await GoogleSheetsService.deleteInventoryItem(itemId);
    _loadInventory();
  }

    

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DSM Inventario')),
      body: ListView.builder(
        itemCount: _inventory.length,
        itemBuilder: (context, index) {
          final item = _inventory[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(item.nombre),
              subtitle: Text(item.tipo),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Cantidad: ${item.cantidad}'),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditInventoryItemScreen(item: item),
                        ),
                      ).then(onGoBack);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteInventoryItem(item.id),
                  ),
                ],
              ),
              onTap: () {
                // Aquí puedes implementar la lógica para mostrar más detalles del elemento en una nueva pantalla
                // Por ejemplo, usando un AlertDialog o Navigator.push
              },
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: [
          FloatingActionButton(
        onPressed: () => _addNewInventoryItem(),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Icon(Icons.add),
        ),
      ),
        ],
      )
    );
  }
}
