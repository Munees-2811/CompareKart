import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/price_alert_provider.dart';

class PriceAlertDialog extends StatefulWidget {
  final Product product;

  const PriceAlertDialog({super.key, required this.product});

  @override
  State<PriceAlertDialog> createState() => _PriceAlertDialogState();
}

class _PriceAlertDialogState extends State<PriceAlertDialog> {
  late TextEditingController _priceController;
  double _targetPercent = 0.90; // Default: 10% drop

  @override
  void initState() {
    super.initState();
    final defaultTarget = widget.product.price * _targetPercent;
    _priceController = TextEditingController(text: defaultTarget.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _updateTargetPrice(double percent) {
    setState(() {
      _targetPercent = percent;
      final targetVal = widget.product.price * _targetPercent;
      _priceController.text = targetVal.toStringAsFixed(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Set Price Alert',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF0D47A1),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product mini card
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[100],
                    child: Image.network(
                      widget.product.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        'Current Price: ₹${widget.product.price.toStringAsFixed(0)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            
            const Text(
              'Target Price (₹)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: '₹ ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            
            // Preset Buttons
            const Text(
              'Or set quick target price drop:',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickDropButton(0.95, '-5%'),
                _buildQuickDropButton(0.90, '-10%'),
                _buildQuickDropButton(0.85, '-15%'),
                _buildQuickDropButton(0.80, '-20%'),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'We will notify you immediately inside the app when the price falls below your target price.',
              style: TextStyle(fontSize: 10, color: Colors.grey, height: 1.4),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            final target = double.tryParse(_priceController.text);
            if (target != null && target > 0) {
              if (target >= widget.product.price) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Target price must be lower than current price!')),
                );
                return;
              }
              
              Provider.of<PriceAlertProvider>(context, listen: false)
                  .addAlert(widget.product, target);
                  
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Price alert set at ₹${target.toStringAsFixed(0)}!'),
                  backgroundColor: const Color(0xFF0D47A1),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D47A1),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Set Alert', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildQuickDropButton(double multiplier, String label) {
    final active = (widget.product.price * multiplier).toStringAsFixed(0) == _priceController.text;
    return InkWell(
      onTap: () => _updateTargetPrice(multiplier),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF0D47A1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: active ? const Color(0xFF0D47A1) : Colors.transparent),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
