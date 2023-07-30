import 'package:gsheets/gsheets.dart';
import 'package:inventario/infrastructure/inventario.model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleSheetsService {
  
  static final _spreadsheetId = dotenv.get('SPREAD_SHEET_ID');
  static final _credentials = dotenv.get('GOOGLE_JSON');

  // Reemplaza esto con tus credenciales generadas para la API de Google Sheets

  static final _gsheets = GSheets(_credentials);
  
  static late Worksheet _worksheet;

  static Future<void> init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Inventario') ??
        await ss.addWorksheet('Inventario');
  }

  static Future<List<InventoryItem>> getInventory() async {
    final rawValues = await _worksheet.values.allRows(fromRow: 2);
    return rawValues.map((row) {
      return InventoryItem(
        id: row[0],
        nombre: row[1],
        marca: row[2],
        cantidad:row[3],
        precio: row[4],
        tipo: row[5],
      );
    }).toList();
  }

  static Future<void> addInventoryItem(InventoryItem item) async {
    await _worksheet.values.appendRow([
      item.id,
      item.nombre,
      item.marca,
      item.cantidad.toString(),
      item.precio.toString(),
      item.tipo,
    ]);
  }

  static Future<void> updateInventoryItem(InventoryItem item) async {
    final index = await _findItemIndex(item.id);
    if (index != null) {
      final updatedRow = [
        item.id,
        item.nombre,
        item.marca,
        item.cantidad.toString(),
        item.precio,
        item.tipo,
      ];

      await _worksheet.values.insertRow(index + 1, updatedRow);
    }
  }
   
  static Future<void> deleteInventoryItem(String itemId) async {
    final index = await _findItemIndex(itemId);
    if (index != null) {
      await _worksheet.deleteRow(index + 1);
    }
  }
  //
  static Future<int?> _findItemIndex(String itemId) async {
    final rawValues = await _worksheet.values.column(1);
    return rawValues.indexOf(itemId);
  }
}
