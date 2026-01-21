import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../platform/routes.dart';
import '../widgets/admin_layout.dart';
import '../../services/settings_dao.dart';

class SettingsManagementScreen extends StatelessWidget {
  const SettingsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      activeRoute: AppRoutes.settingsManagement,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Settings Management',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),

              StoreInfoSection(),
              SizedBox(height: 32),

              TaxServiceSection(),
              SizedBox(height: 32),

              SyncBackupSection(),
            ],
          ),
        ),
      ),
    );
  }
}

/* ───────────────────────── STORE INFO ───────────────────────── */

class StoreInfoSection extends StatefulWidget {
  const StoreInfoSection({super.key});

  @override
  State<StoreInfoSection> createState() => _StoreInfoSectionState();
}

class _StoreInfoSectionState extends State<StoreInfoSection> {
  final _storeNameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();

  final _dao = SettingsDao();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _storeNameCtrl.dispose();
    _addressCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final settings = await _dao.getSettings();
    if (settings != null) {
      _storeNameCtrl.text = settings.storeName;
      _addressCtrl.text = settings.address;
      _contactCtrl.text = settings.contactNumber;
      _imagePath = settings.storeImagePath;
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final fileName = p.basename(picked.path);
    final saved =
        await File(picked.path).copy('${dir.path}/$fileName');

    setState(() => _imagePath = saved.path);
  }

  Future<void> _save() async {
    await _dao.updateSettings({
      'store_name': _storeNameCtrl.text,
      'address': _addressCtrl.text,
      'contact_number': _contactCtrl.text,
      'store_image_path': _imagePath,
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Store information saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Store Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage:
                      _imagePath != null ? FileImage(File(_imagePath!)) : null,
                  child: _imagePath == null
                      ? const Icon(Icons.store, size: 40)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _storeNameCtrl,
              decoration: const InputDecoration(
                labelText: 'Store Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _addressCtrl,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _contactCtrl,
              decoration: const InputDecoration(
                labelText: 'Contact Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────────────────── TAX / SERVICE ───────────────────────── */

class TaxServiceSection extends StatefulWidget {
  const TaxServiceSection({super.key});

  @override
  State<TaxServiceSection> createState() => _TaxServiceSectionState();
}

class _TaxServiceSectionState extends State<TaxServiceSection> {
  final _taxCtrl = TextEditingController();
  final _serviceCtrl = TextEditingController();
  final _dao = SettingsDao();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _taxCtrl.dispose();
    _serviceCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final s = await _dao.getSettings();
    if (s != null) {
      _taxCtrl.text = s.taxPercent.toString();
      _serviceCtrl.text = s.serviceCharge.toString();
      setState(() {});
    }
  }

  Future<void> _save() async {
    await _dao.updateSettings({
      'tax_percent': double.tryParse(_taxCtrl.text) ?? 0,
      'service_charge': double.tryParse(_serviceCtrl.text) ?? 0,
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tax & service charge updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tax & Service Charge',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _taxCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tax Percentage (%)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _serviceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Service Charge (%)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────────────────── SYNC & BACKUP ───────────────────────── */

class SyncBackupSection extends StatelessWidget {
  const SyncBackupSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sync & Backup',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.cloud_upload),
              title: const Text('Sync data to server'),
              subtitle: const Text('Upload offline changes'),
              trailing: ElevatedButton(
                onPressed: () {
                  // TODO: API sync
                },
                child: const Text('Sync'),
              ),
            ),
            const Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.backup),
              title: const Text('Backup local database'),
              subtitle: const Text('Export offline data'),
              trailing: ElevatedButton(
                onPressed: () {
                  // TODO: Backup export
                },
                child: const Text('Backup'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
