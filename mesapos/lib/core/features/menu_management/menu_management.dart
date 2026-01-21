import 'dart:io';
import 'package:flutter/material.dart';

import '../../services/menu_dao.dart';
import '../../models/menu_model.dart';
import '../widgets/admin_layout.dart';

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  final MenuDao _menuDao = MenuDao();
  List<MenuItemModel> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final data = await _menuDao.getAll();
    if (!mounted) return;
    setState(() => _items = data);
  }

  void _confirmDelete(MenuItemModel item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Menu Item'),
        content: Text(
          'Are you sure you want to delete "${item.name}"?\n\n'
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _menuDao.delete(item.id!);
              await _loadItems();
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _openDialog({MenuItemModel? item}) {
    final nameCtrl = TextEditingController(text: item?.name ?? '');
    final descCtrl = TextEditingController(text: item?.description ?? '');
    final priceCtrl =
        TextEditingController(text: item?.price.toString() ?? '');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: AlertDialog(
          title: Text(item == null ? 'Add Menu Item' : 'Edit Menu Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Item Name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration:
                      const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: priceCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameCtrl.text.trim();
                final price = double.tryParse(priceCtrl.text);

                if (name.isEmpty || price == null || price <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Please enter a valid name and price'),
                    ),
                  );
                  return;
                }

                if (item == null) {
                  await _menuDao.insert(
                    MenuItemModel(
                      name: name,
                      description: descCtrl.text.trim(),
                      price: price,
                      category: 'General',
                    ),
                  );
                } else {
                  await _menuDao.update(
                    MenuItemModel(
                      id: item.id,
                      name: name,
                      description: descCtrl.text.trim(),
                      price: price,
                      category: item.category,
                      imagePath: item.imagePath,
                      isAvailable: item.isAvailable,
                    ),
                  );
                }

                await _loadItems();
                if (mounted) Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      activeRoute: 'menu',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Menu Management'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _openDialog(),
            ),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _items.length,
          itemBuilder: (_, index) {
            final item = _items[index];

            return Card(
              child: ListTile(
                leading: item.imagePath != null
                    ? Image.file(
                        File(item.imagePath!),
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.fastfood),
                title: Text(item.name),
                subtitle: Text(
                  '${item.description}\n₱${item.price.toStringAsFixed(2)}',
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: item.isAvailable == 1,
                      onChanged: (v) async {
                        await _menuDao.update(
                          MenuItemModel(
                            id: item.id,
                            name: item.name,
                            description: item.description,
                            price: item.price,
                            category: item.category,
                            imagePath: item.imagePath,
                            isAvailable: v ? 1 : 0,
                          ),
                        );
                        _loadItems();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _openDialog(item: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete,
                          color: Colors.redAccent),
                      onPressed: () => _confirmDelete(item),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
