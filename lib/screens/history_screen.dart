import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/bill_record.dart';
import 'detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<BillRecord> _records = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _loading = true);
    final data = await _dbHelper.getAllBills();
    setState(() {
      _records = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history, size: 20),
            SizedBox(width: 8),
            Text('Bill History'),
          ],
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFE65100)))
          : _records.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inbox_outlined,
                          size: 64,
                          color: const Color(0xFFE65100).withOpacity(0.4)),
                      const SizedBox(height: 16),
                      const Text(
                        'No records yet.',
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Calculate and save a bill to see it here.',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: const Color(0xFFE65100),
                  onRefresh: _loadRecords,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _records.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final record = _records[index];
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE65100),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.electric_bolt,
                                color: Colors.amber, size: 24),
                          ),
                          title: Text(
                            record.month,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFFE65100),
                            ),
                          ),
                          subtitle: Text(
                            'Final Cost: RM ${record.finalCost.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right,
                              color: Color(0xFFE65100)),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DetailScreen(record: record),
                              ),
                            );
                            _loadRecords();
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}