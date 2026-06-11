import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/bill_record.dart';
import '../database/db_helper.dart';
import '../utils/calculator.dart';
import 'history_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _unitController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  String? _selectedMonth;
  double _rebatePercent = 0.0;
  double? _totalCharges;
  double? _finalCost;
  bool _hasResult = false;

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMonth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Please select a month')),
      );
      return;
    }

    double units = double.parse(_unitController.text.trim());
    double total = ElectricityCalculator.calculateTotalCharges(units);
    double final_ = ElectricityCalculator.calculateFinalCost(total, _rebatePercent);

    setState(() {
      _totalCharges = total;
      _finalCost = final_;
      _hasResult = true;
    });
  }

  Future<void> _saveToDB() async {
    if (!_hasResult || _totalCharges == null || _finalCost == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Please calculate first before saving.')),
      );
      return;
    }

    BillRecord record = BillRecord(
      month: _selectedMonth!,
      unitUsed: double.parse(_unitController.text.trim()),
      totalCharges: _totalCharges!,
      rebatePercent: _rebatePercent,
      finalCost: _finalCost!,
    );

    await _dbHelper.insertBill(record);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Record saved successfully!')),
      );
      _resetForm();
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _unitController.clear();
    setState(() {
      _selectedMonth = null;
      _rebatePercent = 0.0;
      _totalCharges = null;
      _finalCost = null;
      _hasResult = false;
    });
  }

  @override
  void dispose() {
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.electric_bolt, color: Colors.amber, size: 22),
            SizedBox(width: 8),
            Text('E-Bill Estimator'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'View History',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE65100), Color(0xFFFF8F00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE65100).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber, size: 28),
                      SizedBox(width: 10),
                      Text(
                        'Monthly Bill Estimator',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Enter your electricity usage details below to estimate your bill.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Form card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bill Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE65100),
                        ),
                      ),
                      const Divider(color: Color(0xFFFFCC80)),
                      const SizedBox(height: 12),

                      // Month dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedMonth,
                        decoration: const InputDecoration(
                          labelText: 'Select Month',
                          prefixIcon: Icon(Icons.calendar_month),
                          helperText: 'Choose the billing month',
                        ),
                        items: _months
                            .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedMonth = val),
                        validator: (val) => val == null ? 'Please select a month' : null,
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      const SizedBox(height: 16),

                      // Units input
                      TextFormField(
                        controller: _unitController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Units Used (kWh)',
                          prefixIcon: Icon(Icons.speed),
                          suffixText: 'kWh',
                          helperText: 'Enter value between 1 and 1000',
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Please enter units used';
                          double? v = double.tryParse(val);
                          if (v == null) return 'Enter a valid number';
                          if (v < 1) return 'Minimum is 1 kWh';
                          if (v > 1000) return 'Maximum is 1000 kWh';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Rebate slider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Rebate (%)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5D4037),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE65100),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_rebatePercent.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
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
                        onChanged: (val) => setState(() => _rebatePercent = val),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('0%', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text('Drag to set rebate (0% – 5%)',
                              style: TextStyle(fontSize: 11, color: Colors.grey)),
                          Text('5%', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Rate info collapsible
                      ExpansionTile(
                        leading: const Icon(Icons.info_outline, color: Color(0xFFE65100)),
                        title: const Text(
                          'View Rate Table',
                          style: TextStyle(
                            color: Color(0xFFE65100),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        collapsedIconColor: const Color(0xFFE65100),
                        iconColor: const Color(0xFFE65100),
                        children: [
                          _buildRateTable(),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _calculate,
                              icon: const Icon(Icons.calculate),
                              label: const Text('Calculate'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton.icon(
                            onPressed: _resetForm,
                            icon: const Icon(Icons.refresh, color: Color(0xFFE65100)),
                            label: const Text(
                              'Reset',
                              style: TextStyle(color: Color(0xFFE65100)),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFE65100)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Result card
            if (_hasResult) ...[
              const SizedBox(height: 16),
              _buildResultCard(),
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRateTable() {
    const rows = [
      ['1 – 200 kWh', '21.8 sen/kWh'],
      ['201 – 300 kWh', '33.4 sen/kWh'],
      ['301 – 600 kWh', '51.6 sen/kWh'],
      ['601 – 1000 kWh', '54.6 sen/kWh'],
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFFFCC80)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFE65100),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(9),
                topRight: Radius.circular(9),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Text('Block',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ),
                Text('Rate',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ],
            ),
          ),
          ...rows.asMap().entries.map((e) => Container(
                color: e.key.isEven
                    ? const Color(0xFFFFF3E0)
                    : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(e.value[0],
                            style: const TextStyle(fontSize: 13))),
                    Text(e.value[1],
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Color(0xFFE65100))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      color: const Color(0xFFFFF3E0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFFFCC80), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: const [
                Icon(Icons.receipt_long, color: Color(0xFFE65100)),
                SizedBox(width: 8),
                Text(
                  'Calculation Result',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE65100),
                  ),
                ),
              ],
            ),
            const Divider(color: Color(0xFFFFCC80), height: 20),
            _resultRow('Month', _selectedMonth ?? '-', isHighlight: false),
            _resultRow('Units Used', '${_unitController.text} kWh', isHighlight: false),
            _resultRow('Rebate Applied', '${_rebatePercent.toStringAsFixed(1)}%',
                isHighlight: false),
            const Divider(color: Color(0xFFFFCC80), height: 16),
            _resultRow('Total Charges', 'RM ${_totalCharges!.toStringAsFixed(4)}',
                isHighlight: false),
            _resultRow('Final Cost (after rebate)',
                'RM ${_finalCost!.toStringAsFixed(4)}',
                isHighlight: true),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveToDB,
                icon: const Icon(Icons.save),
                label: const Text('Save Record'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultRow(String label, String value, {required bool isHighlight}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 14,
                color: isHighlight
                    ? const Color(0xFFE65100)
                    : const Color(0xFF5D4037),
                fontWeight:
                    isHighlight ? FontWeight.bold : FontWeight.normal,
              )),
          Text(value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isHighlight
                    ? const Color(0xFFE65100)
                    : Colors.black87,
              )),
        ],
      ),
    );
  }
}