import 'package:flutter/material.dart';

/// Linha de checklist: checkbox + rótulo.
class ChecklistItemTile extends StatelessWidget {
  const ChecklistItemTile({
    super.key,
    required this.rotulo,
    required this.marcado,
    required this.onChanged,
  });

  final String rotulo;
  final bool marcado;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: marcado,
      onChanged: (v) => onChanged(v ?? false),
      title: Text(rotulo),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
