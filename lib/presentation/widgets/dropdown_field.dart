import 'package:flutter/material.dart';

class DropdownField<T> extends StatelessWidget {
  final String labelText;
  final List<T> items;
  final T? value;
  final Function(T?) onChanged;

  const DropdownField({super.key, 
    required this.labelText,
    required this.items,
    required this.value,
    required this.onChanged,
  });
  

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<T>>((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
