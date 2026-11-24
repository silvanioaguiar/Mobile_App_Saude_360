import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Item da agenda: morador, grupo e situação (pendente ou concluída).
class VisitaTile extends StatelessWidget {
  const VisitaTile({
    super.key,
    required this.morador,
    required this.subtitulo,
    required this.concluida,
    this.onTap,
  });

  final String morador;
  final String subtitulo;
  final bool concluida;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        concluida ? Icons.check_circle : Icons.radio_button_unchecked,
        color: concluida ? Cores.success : null,
      ),
      title: Text(morador),
      subtitle: Text(subtitulo),
      trailing: concluida ? null : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
