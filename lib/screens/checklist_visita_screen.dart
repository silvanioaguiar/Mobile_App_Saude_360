import 'package:flutter/material.dart';

import '../data/escopo.dart';
import '../models/visita.dart';
import '../widgets/checklist_item_tile.dart';
import '../widgets/progresso_visita.dart';

/// Checklist de uma visita gerada pela agenda. Recebe a [VisitaPlanejada]
/// pelos arguments da rota e devolve `true` ao concluir.
class ChecklistVisitaScreen extends StatefulWidget {
  const ChecklistVisitaScreen({super.key});

  @override
  State<ChecklistVisitaScreen> createState() => _ChecklistVisitaScreenState();
}

class _ChecklistVisitaScreenState extends State<ChecklistVisitaScreen> {
  late final VisitaPlanejada _visita;
  late final List<bool> _marcados;
  final _obs = TextEditingController();
  bool _inicializado = false;

  int get _feitos => _marcados.where((m) => m).length;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inicializado) return;
    _inicializado = true;
    _visita = ModalRoute.of(context)!.settings.arguments as VisitaPlanejada;
    _marcados = List<bool>.filled(_visita.itens.length, false);
  }

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
      id: _visita.id,
      agenteId: _visita.agenteId,
      morador: _visita.morador,
      grupo: _visita.grupo,
      marcados: List.of(_marcados),
      observacao: _obs.text.trim(),
      data: DateTime.now(),
    ));
    messenger.showSnackBar(SnackBar(
        content: Text('Visita registrada ($_feitos/${_marcados.length}).')));
    nav.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final itens = _visita.itens;
    return Scaffold(
      appBar: AppBar(title: const Text('Checklist de visita')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_visita.morador,
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text('${_visita.territorio} · ${_visita.grupo.rotulo}'),
              ],
            ),
          ),
          ProgressoVisita(feitos: _feitos, total: _marcados.length),
          for (var i = 0; i < itens.length; i++)
            ChecklistItemTile(
              rotulo: itens[i],
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
                onPressed: _concluir, child: const Text('Concluir visita')),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
