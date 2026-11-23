import 'package:flutter/material.dart';

import '../models/usuario.dart';

/// Item da lista de usuários, com swipe para excluir e toque para editar.
class UsuarioTile extends StatelessWidget {
  const UsuarioTile({
    super.key,
    required this.usuario,
    required this.onTap,
    required this.onExcluir,
  });

  final Usuario usuario;
  final VoidCallback onTap;
  final Future<bool> Function() onExcluir;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(usuario.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => onExcluir(),
      background: Container(
        color: Theme.of(context).colorScheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete),
      ),
      child: ListTile(
        leading: CircleAvatar(child: Text(usuario.nome[0])),
        title: Text(usuario.nome),
        subtitle: Text('${usuario.perfil.rotulo} · ${usuario.territorio}'),
        trailing: Text(usuario.ativo ? 'Ativo' : 'Inativo'),
        onTap: onTap,
      ),
    );
  }
}
