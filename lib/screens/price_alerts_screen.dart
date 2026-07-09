import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/price_alert_provider.dart';

class PriceAlertsScreen extends StatelessWidget {
  const PriceAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alertProvider = Provider.of<PriceAlertProvider>(context);
    final alerts = alertProvider.alerts;
    final themeColor = const Color(0xFF0D47A1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Price Drop Alerts',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: alerts.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_none_rounded, size: 84, color: Colors.grey[300]),
                      const SizedBox(height: 20),
                      const Text(
                        'No Price Alerts Set',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Set alert thresholds on any product detail page. We will alert you immediately when the price drops below your target.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: Colors.blue[50],
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: themeColor, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'TIP: Click "Simulate Drop" on any card below to test the alert notifications drop simulation!',
                            style: TextStyle(fontSize: 11, color: Colors.blue[900], fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: alerts.length,
                      itemBuilder: (context, index) {
                        final alert = alerts[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                            border: Border.all(
                              color: alert.isTriggered ? Colors.green[300]! : Colors.grey[200]!,
                              width: alert.isTriggered ? 1.5 : 1.0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Header details
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      color: const Color(0xFFF8F9FA),
                                      child: Image.network(alert.imageUrl, fit: BoxFit.contain),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          alert.productName,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Platform: ${alert.platform}',
                                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                    onPressed: () => alertProvider.removeAlert(alert.id),
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                              const Divider(height: 24),

                              // Pricing index comparison
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildPricePill('Initial Price', alert.initialPrice, Colors.grey[700]!),
                                  _buildPricePill(
                                    'Target Price', 
                                    alert.targetPrice, 
                                    themeColor,
                                    isHighlight: true,
                                  ),
                                  _buildPricePill(
                                    'Current Price',
                                    alert.currentPrice,
                                    alert.isTriggered ? Colors.green[800]! : Colors.amber[800]!,
                                    isHighlight: alert.isTriggered,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Alert Status Bar / Indicator
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(3),
                                        child: LinearProgressIndicator(
                                          value: alert.isTriggered ? 1.0 : 0.4,
                                          backgroundColor: Colors.transparent,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            alert.isTriggered ? Colors.green : Colors.amber,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: alert.isTriggered ? Colors.green : Colors.amber[50],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      alert.isTriggered ? 'ALERT TRIGGERED' : 'MONITORING',
                                      style: TextStyle(
                                        color: alert.isTriggered ? Colors.white : Colors.amber[900],
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              // Interactive Simulation Controls
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (alert.isTriggered)
                                    OutlinedButton(
                                      onPressed: () => alertProvider.resetAlert(alert.id),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.grey[700],
                                        side: BorderSide(color: Colors.grey[300]!),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      ),
                                      child: const Text('Reset Price', style: TextStyle(fontSize: 11)),
                                    )
                                  else
                                    ElevatedButton(
                                      onPressed: () => alertProvider.simulatePriceDrop(alert.id),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        elevation: 0,
                                      ),
                                      child: const Text('Simulate Drop', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildPricePill(String label, double value, Color color, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 10)),
        const SizedBox(height: 4),
        Text(
          '₹${value.toStringAsFixed(0)}',
          style: TextStyle(
            color: color,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
            fontSize: isHighlight ? 15 : 13,
          ),
        ),
      ],
    );
  }
}
