import 'package:flutter/material.dart';

class DailySalesCard extends StatelessWidget {
  const DailySalesCard({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with SQLite/API
    const double totalSales = 8450.00;
    const int totalOrders = 42;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Sales Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              '₱${totalSales.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$totalOrders orders today',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
