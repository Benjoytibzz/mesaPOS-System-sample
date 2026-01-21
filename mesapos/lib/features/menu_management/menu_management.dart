import 'package:flutter/material.dart';
import '../../core/models/menu_item_model.dart';
import '../../core/services/menu_service.dart';
import '../widgets/admin_layout.dart';

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  _menuService.deleteItem(item.id);
                });
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    }
    
  final MenuService _menuService = MenuService();

  void _openDialog({MenuItemModel? item}) {
    final nameCtrl = TextEditingController(text: item?.name ?? '');
    final priceCtrl =
        TextEditingController(text: item?.price.toString() ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item == null ? 'Add Menu Item' : 'Edit Menu Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (item == null) {
                  _menuService.addItem(
                    nameCtrl.text,
                    double.parse(priceCtrl.text),
                  );
                } else {
                  _menuService.updateItem(
                    item.copyWith(
                      name: nameCtrl.text,
                      price: double.parse(priceCtrl.text),
                    ),
                  );
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    final items = _menuService.getAll();

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
          itemCount: items.length,
          itemBuilder: (_, index) {
            final item = items[index];
            return Card(
              child: ListTile(
                title: Text(item.name),
                subtitle: Text('₱${item.price.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: item.isActive,
                      onChanged: (_) {
                        setState(() {
                          _menuService.toggleStatus(item.id);
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _openDialog(item: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
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
