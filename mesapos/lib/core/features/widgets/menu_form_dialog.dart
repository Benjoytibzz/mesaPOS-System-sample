import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/menu_model.dart';

class MenuFormDialog extends StatefulWidget {
  final Function(MenuItemModel) onSave;

  const MenuFormDialog({super.key, required this.onSave});

  @override
  State<MenuFormDialog> createState() => _MenuFormDialogState();
}

class _MenuFormDialogState extends State<MenuFormDialog> {
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  final _category = TextEditingController();
  String? _imagePath;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _imagePath = picked.path);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Menu Item'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _imagePath == null
                  ? Container(
                      height: 120,
                      color: Colors.grey.shade300,
                      child: const Center(child: Text('Tap to add image')),
                    )
                  : Image.file(File(_imagePath!), height: 120),
            ),
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: _desc, decoration: const InputDecoration(labelText: 'Description')),
            TextField(
              controller: _price,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(controller: _category, decoration: const InputDecoration(labelText: 'Category')),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            widget.onSave(
              MenuItemModel(
                name: _name.text,
                description: _desc.text,
                price: double.parse(_price.text),
                category: _category.text,
                imagePath: _imagePath,
              ),
            );
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
