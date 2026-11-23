import 'package:flutter/material.dart';

/// Barra de progresso "x de N" do checklist.
class ProgressoVisita extends StatelessWidget {
  const ProgressoVisita({super.key, required this.feitos, required this.total});

  final int feitos;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Progresso: $feitos de $total itens'),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: total == 0 ? 0 : feitos / total),
        ],
      ),
    );
  }
}
