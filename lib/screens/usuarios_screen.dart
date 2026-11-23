import 'package:flutter/material.dart';

import '../data/escopo.dart';
import '../models/usuario.dart';
import '../widgets/usuario_tile.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  String _busca = '';

  Future<bool> _confirmarExclusao(Usuario u) async {
    final repo = EscopoRepositorio.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir usuário?'),
        content: Text('${u.nome} será removido.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Excluir')),
        ],
      ),
    );
    if (ok == true) await repo.removerUsuario(u.id);
    // O item sai da lista pelo notifyListeners; não deixar o Dismissible agir.
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final repo = EscopoRepositorio.of(context);
    final termo = _busca.toLowerCase();
    final lista = repo.usuarios
        .where((u) => u.nome.toLowerCase().contains(termo))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Usuários')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/usuario'),
        icon: const Icon(Icons.add),
        label: const Text('Novo usuário'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Buscar por nome',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _busca = v),
            ),
          ),
          Expanded(
            child: lista.isEmpty
                ? const Center(child: Text('Nenhum usuário encontrado.'))
                : ListView.builder(
                    itemCount: lista.length,
                    itemBuilder: (_, i) => UsuarioTile(
                      usuario: lista[i],
                      onTap: () => Navigator.pushNamed(context, '/usuario',
                          arguments: lista[i]),
                      onExcluir: () => _confirmarExclusao(lista[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
