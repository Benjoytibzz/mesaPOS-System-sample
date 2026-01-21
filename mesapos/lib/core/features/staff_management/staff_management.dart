import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../platform/routes.dart';
import '../widgets/admin_layout.dart';
import '../../services/user_dao.dart';
import '../../models/user_model.dart';

class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  final UserDao _userDao = UserDao();
  final ImagePicker _picker = ImagePicker();
  List<UserModel> _staff = [];

  @override
  void initState() {
    super.initState();
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    final data = await _userDao.getStaff();
    if (!mounted) return;
    setState(() => _staff = data);
  }

  Future<String> _persistImage(String sourcePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(dir.path, 'staff_images'));

    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}${p.extension(sourcePath)}';
    final newPath = p.join(imagesDir.path, fileName);

    return (await File(sourcePath).copy(newPath)).path;
  }

  void _openDialog({UserModel? user}) {
    final usernameCtrl = TextEditingController(text: user?.username ?? '');
    final firstNameCtrl = TextEditingController(text: user?.firstName ?? '');
    final lastNameCtrl = TextEditingController(text: user?.lastName ?? '');
    final passwordCtrl = TextEditingController();

    String role = user?.role ?? 'staff';
    String? imagePath = user?.imagePath;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: AlertDialog(
          title: Text(user == null ? 'Add Staff' : 'Edit Staff'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final picked = await _picker.pickImage(
                        source: ImageSource.gallery);
                    if (picked != null) {
                      final safePath = await _persistImage(picked.path);
                      setState(() => imagePath = safePath);
                    }
                  },
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: imagePath != null &&
                            File(imagePath!).existsSync()
                        ? Image.file(File(imagePath!), fit: BoxFit.cover)
                        : const Icon(Icons.person, size: 48),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: usernameCtrl,
                  enabled: user == null,
                  decoration:
                      const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: firstNameCtrl,
                  decoration:
                      const InputDecoration(labelText: 'First Name'),
                ),
                TextField(
                  controller: lastNameCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Last Name'),
                ),
                TextField(
                  controller: passwordCtrl,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Password'),
                ),
                DropdownButtonFormField(
                  value: role,
                  items: const [
                    DropdownMenuItem(
                        value: 'staff', child: Text('Staff')),
                    DropdownMenuItem(
                        value: 'cashier', child: Text('Cashier')),
                  ],
                  onChanged: (v) => role = v!,
                  decoration:
                      const InputDecoration(labelText: 'Role'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (user == null) {
                  await _userDao.insert(
                    UserModel(
                      username: usernameCtrl.text.trim(),
                      passwordHash:
                          UserDao.hashPassword(passwordCtrl.text),
                      role: role,
                      firstName: firstNameCtrl.text.trim(),
                      lastName: lastNameCtrl.text.trim(),
                      imagePath: imagePath,
                    ),
                  );
                } else {
                  await _userDao.update(
                    UserModel(
                      id: user.id,
                      username: user.username,
                      passwordHash: passwordCtrl.text.isEmpty
                          ? user.passwordHash
                          : UserDao.hashPassword(passwordCtrl.text),
                      role: role,
                      firstName: firstNameCtrl.text.trim(),
                      lastName: lastNameCtrl.text.trim(),
                      imagePath: imagePath,
                      isActive: user.isActive,
                    ),
                  );
                }

                await _loadStaff();
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
      activeRoute: AppRoutes.staffManagement,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Staff Management'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _openDialog(),
            ),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _staff.length,
          itemBuilder: (_, i) {
            final user = _staff[i];
            return Card(
              child: ListTile(
                leading: user.imagePath != null &&
                        File(user.imagePath!).existsSync()
                    ? Image.file(File(user.imagePath!),
                        width: 48, height: 48, fit: BoxFit.cover)
                    : const Icon(Icons.person),
                title: Text(user.username),
                subtitle: Text(
                    '${user.firstName} ${user.lastName}\nRole: ${user.role}'),
                isThreeLine: true,
                trailing: Switch(
                  value: user.isActive == 1,
                  onChanged: (_) async {
                    await _userDao.toggleActive(
                        user.id!, user.isActive == 1 ? 0 : 1);
                    _loadStaff();
                  },
                ),
                onTap: () => _openDialog(user: user),
              ),
            );
          },
        ),
      ),
    );
  }
}
