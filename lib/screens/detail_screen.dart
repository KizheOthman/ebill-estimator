import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/bill_record.dart';
import '../utils/calculator.dart';

class DetailScreen extends StatefulWidget {
  final BillRecord record;
  const DetailScreen({super.key, required this.record});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final DBHelper _dbHelper = DBHelper();
  bool _isEditing = false;
  late BillRecord _record;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _unitController;
  String? _selectedMonth;
  double _rebatePercent = 0.0;
  double? _totalCharges;
  double? _finalCost;

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    _record = widget.record;
    _unitController =
        TextEditingController(text: _record.unitUsed.toString());
    _selectedMonth = _record.month;
    _rebatePercent = _record.rebatePercent;
    _totalCharges = _record.totalCharges;
    _finalCost = _record.finalCost;
  }

  @override
  void dispose() {
    _unitController.dispose();
    super.dispose();
  }

  void _recalculate() {
    double units = double.tryParse(_unitController.text) ?? 0;
    double total = ElectricityCalculator.calculateTotalCharges(units);
    double final_ =
        ElectricityCalculator.calculateFinalCost(total, _rebatePercent);
    setState(() {
      _totalCharges = total;
      _finalCost = final_;
    });
  }

  Future<void> _saveEdit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMonth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a month')),
      );
      return;
    }
    _recalculate();

    BillRecord updated = BillRecord(
      id: _record.id,
      month: _selectedMonth!,
      unitUsed: double.parse(_unitController.text),
      totalCharges: _totalCharges!,
      rebatePercent: _rebatePercent,
      finalCost: _finalCost!,
    );

    await _dbHelper.updateBill(updated);

    setState(() {
      _record = updated;
      _isEditing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Record updated successfully!')),
      );
    }
  }

  Future<void> _deleteRecord() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Record',
            style: TextStyle(color: Color(0xFFE65100))),
        content: const Text(
            'Are you sure you want to delete this record? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _dbHelper.deleteBill(_record.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🗑️ Record deleted.')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Record' : 'Record Detail'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit',
              onPressed: () => setState(() => _isEditing = true),
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete',
            onPressed: _deleteRecord,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _isEditing ? _buildEditForm() : _buildDetail(),
      ),
    );
  }

  Widget _buildDetail() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE65100),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.receipt_long,
                      color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _record.month,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE65100),
                      ),
                    ),
                    Text(
                      'Record #${_record.id}',
                      style: const TextStyle(
                          fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Color(0xFFFFCC80)),
            _detailRow(Icons.speed, 'Units Used',
                '${_record.unitUsed.toStringAsFixed(2)} kWh'),
            _detailRow(Icons.percent, 'Rebate',
                '${_record.rebatePercent.toStringAsFixed(1)}%'),
            _detailRow(Icons.calculate, 'Total Charges',
                'RM ${_record.totalCharges.toStringAsFixed(4)}'),
            const Divider(color: Color(0xFFFFCC80)),
            _detailRow(Icons.monetization_on, 'Final Cost',
                'RM ${_record.finalCost.toStringAsFixed(4)}',
                isHighlight: true),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _isEditing = true),
                icon: const Icon(Icons.edit),
                label: const Text('Edit This Record'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value,
      {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon,
              color: isHighlight
                  ? const Color(0xFFE65100)
                  : Colors.grey,
              size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: TextStyle(
                  fontSize: 14,
                  color: isHighlight
                      ? const Color(0xFFE65100)
                      : Colors.black87,
                  fontWeight: isHighlight
                      ? FontWeight.bold
                      : FontWeight.normal,
                )),
          ),
          Text(value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isHighlight
                    ? const Color(0xFFE65100)
                    : Colors.black87,
              )),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit Record',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE65100))),
              const Divider(color: Color(0xFFFFCC80)),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: _selectedMonth,
                decoration: const InputDecoration(
                  labelText: 'Month',
                  prefixIcon: Icon(Icons.calendar_month),
                ),
                items: _months
                    .map((m) =>
                        DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _selectedMonth = val),
                validator: (val) =>
                    val == null ? 'Please select a month' : null,
                dropdownColor: Colors.white,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _unitController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Units Used (kWh)',
                  prefixIcon: Icon(Icons.speed),
                  suffixText: 'kWh',
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Required';
                  double? v = double.tryParse(val);
                  if (v == null) return 'Invalid number';
                  if (v < 1) return 'Minimum 1 kWh';
                  if (v > 1000) return 'Maximum 1000 kWh';
                  return null;
                },
                onChanged: (_) => _recalculate(),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Rebate (%)',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE65100),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_rebatePercent.toStringAsFixed(1)}%',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Slider(
                value: _rebatePercent,
                min: 0,
                max: 5,
                divisions: 50,
                activeColor: const Color(0xFFE65100),
                inactiveColor: const Color(0xFFFFCC80),
                label: '${_rebatePercent.toStringAsFixed(1)}%',
                onChanged: (val) {
                  setState(() => _rebatePercent = val);
                  _recalculate();
                },
              ),

              if (_totalCharges != null && _finalCost != null) ...[
                const Divider(color: Color(0xFFFFCC80)),
                _detailRow(Icons.calculate, 'Total Charges',
                    'RM ${_totalCharges!.toStringAsFixed(4)}'),
                _detailRow(Icons.monetization_on, 'Final Cost',
                    'RM ${_finalCost!.toStringAsFixed(4)}',
                    isHighlight: true),
              ],

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _saveEdit,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Changes'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () =>
                        setState(() => _isEditing = false),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color(0xFFE65100)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                    ),
                    child: const Text('Cancel',
                        style:
                            TextStyle(color: Color(0xFFE65100))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}