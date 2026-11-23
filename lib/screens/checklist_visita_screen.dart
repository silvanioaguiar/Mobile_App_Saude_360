import 'package:flutter/material.dart';

import '../data/escopo.dart';
import '../models/visita.dart';
import '../widgets/checklist_item_tile.dart';
import '../widgets/progresso_visita.dart';

class ChecklistVisitaScreen extends StatefulWidget {
  const ChecklistVisitaScreen({super.key});

  @override
  State<ChecklistVisitaScreen> createState() => _ChecklistVisitaScreenState();
}

class _ChecklistVisitaScreenState extends State<ChecklistVisitaScreen> {
  String? _agenteId;
  String _morador = moradoresSinteticos.first;
  final _marcados = List<bool>.filled(itensChecklist.length, false);
  final _obs = TextEditingController();

  int get _feitos => _marcados.where((m) => m).length;

  @override
  void dispose() {
    _obs.dispose();
    super.dispose();
  }

  Future<void> _concluir() async {
    final repo = EscopoRepositorio.of(context);
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await repo.registrarVisita(Visita(
      id: repo.novoId(),
      agenteId: _agenteId!,
      morador: _morador,
      marcados: List.of(_marcados),
      observacao: _obs.text.trim(),
      data: DateTime.now(),
    ));
    messenger.showSnackBar(
        SnackBar(content: Text('Visita registrada ($_feitos/${_marcados.length}).')));
    nav.pop();
  }

  @override
  Widget build(BuildContext context) {
    final agentes = EscopoRepositorio.of(context).agentes;
    final pronto = _agenteId != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Checklist de visita')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              DropdownButtonFormField<String>(
                value: _agenteId,
                decoration: const InputDecoration(
                    labelText: 'Agente (ACS ativo)',
                    border: OutlineInputBorder()),
                items: [
                  for (final a in agentes)
                    DropdownMenuItem(
                        value: a.id, child: Text('${a.nome} · ${a.territorio}')),
                ],
                onChanged: (v) => setState(() => _agenteId = v),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _morador,
                decoration: const InputDecoration(
                    labelText: 'Morador (fictício)',
                    border: OutlineInputBorder()),
                items: [
                  for (final m in moradoresSinteticos)
                    DropdownMenuItem(value: m, child: Text(m)),
                ],
                onChanged: (v) => setState(() => _morador = v!),
              ),
            ]),
          ),
          ProgressoVisita(feitos: _feitos, total: _marcados.length),
          for (var i = 0; i < itensChecklist.length; i++)
            ChecklistItemTile(
              rotulo: itensChecklist[i],
              marcado: _marcados[i],
              onChanged: (v) => setState(() => _marcados[i] = v),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _obs,
              maxLines: 3,
              decoration: const InputDecoration(
                  labelText: 'Observação', border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton(
              onPressed: pronto ? _concluir : null,
              child: Text(pronto ? 'Concluir visita' : 'Escolha o agente'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
