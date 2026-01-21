import 'package:flutter/material.dart';

class ActiveTablesCard extends StatelessWidget {
  const ActiveTablesCard({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with live table data
    const int activeTables = 6;
    const int totalTables = 12;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Active Tables',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              '$activeTables / $totalTables',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tables currently occupied',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
