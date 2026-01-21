class SettingsModel {
  final int id;
  final String storeName;
  final String address;
  final String contactNumber;
  final String? storeImagePath; // NEW
  final double taxPercent;
  final double serviceCharge;
  final DateTime updatedAt;

  SettingsModel({
    this.id = 1,
    required this.storeName,
    required this.address,
    required this.contactNumber,
    this.storeImagePath,
    required this.taxPercent,
    required this.serviceCharge,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'store_name': storeName,
      'address': address,
      'contact_number': contactNumber,
      'store_image_path': storeImagePath,
      'tax_percent': taxPercent,
      'service_charge': serviceCharge,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      id: map['id'],
      storeName: map['store_name'],
      address: map['address'],
      contactNumber: map['contact_number'],
      storeImagePath: map['store_image_path'],
      taxPercent: map['tax_percent'],
      serviceCharge: map['service_charge'],
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
