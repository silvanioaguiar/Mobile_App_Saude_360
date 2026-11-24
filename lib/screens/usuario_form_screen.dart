import 'package:flutter/material.dart';

import '../data/escopo.dart';
import '../models/usuario.dart';

/// Cadastro e edição. Recebe um [Usuario] opcional via arguments da rota.
class UsuarioFormScreen extends StatefulWidget {
  const UsuarioFormScreen({super.key});

  @override
  State<UsuarioFormScreen> createState() => _UsuarioFormScreenState();
}

class _UsuarioFormScreenState extends State<UsuarioFormScreen> {
  final _form = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _email = TextEditingController();
  Perfil _perfil = Perfil.acs;
  String _territorio = territorios.first;
  GrupoPrioritario _grupo = GrupoPrioritario.idosos;
  bool _ativo = true;
  Usuario? _editando;
  bool _inicializado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inicializado) return;
    _inicializado = true;
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is Usuario) {
      _editando = arg;
      _nome.text = arg.nome;
      _email.text = arg.email;
      _perfil = arg.perfil;
      _territorio = arg.territorio;
      _grupo = arg.grupo ?? GrupoPrioritario.idosos;
      _ativo = arg.ativo;
    }
  }

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_form.currentState!.validate()) return;
    final repo = EscopoRepositorio.of(context);
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final usuario = Usuario(
      id: _editando?.id ?? repo.novoId(),
      nome: _nome.text.trim(),
      email: _email.text.trim(),
      perfil: _perfil,
      territorio: _territorio,
      // Só o agente comunitário tem grupo prioritário (gera a agenda dele).
      grupo: _perfil == Perfil.acs ? _grupo : null,
      ativo: _ativo,
    );
    await repo.salvarUsuario(usuario);
    messenger.showSnackBar(const SnackBar(content: Text('Usuário salvo.')));
    nav.pop(usuario);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_editando == null ? 'Novo usuário' : 'Editar usuário')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nome,
              decoration: const InputDecoration(
                  labelText: 'Nome', border: OutlineInputBorder()),
              validator: (v) =>
                  (v == null || v.trim().length < 3) ? 'Informe o nome (mín. 3 letras)' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  labelText: 'E-mail (fictício)', border: OutlineInputBorder()),
              validator: (v) => (v == null || !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim()))
                  ? 'E-mail inválido'
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Perfil>(
              value: _perfil,
              decoration: const InputDecoration(
                  labelText: 'Perfil', border: OutlineInputBorder()),
              items: [
                for (final p in Perfil.values)
                  DropdownMenuItem(value: p, child: Text(p.rotulo)),
              ],
              onChanged: (v) => setState(() => _perfil = v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _territorio,
              decoration: const InputDecoration(
                  labelText: 'Território', border: OutlineInputBorder()),
              items: [
                for (final t in territorios)
                  DropdownMenuItem(value: t, child: Text(t)),
              ],
              onChanged: (v) => setState(() => _territorio = v!),
            ),
            if (_perfil == Perfil.acs) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<GrupoPrioritario>(
                value: _grupo,
                decoration: const InputDecoration(
                    labelText: 'Grupo prioritário (define a agenda de visitas)',
                    border: OutlineInputBorder()),
                items: [
                  for (final g in GrupoPrioritario.values)
                    DropdownMenuItem(value: g, child: Text(g.rotulo)),
                ],
                onChanged: (v) => setState(() => _grupo = v!),
              ),
            ],
            SwitchListTile(
              title: const Text('Usuário ativo'),
              value: _ativo,
              onChanged: (v) => setState(() => _ativo = v),
            ),
            const SizedBox(height: 8),
            FilledButton(onPressed: _salvar, child: const Text('Salvar')),
          ],
        ),
      ),
    );
  }
}
