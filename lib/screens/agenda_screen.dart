import 'package:flutter/material.dart';

import '../data/escopo.dart';
import '../models/usuario.dart';
import '../widgets/visita_tile.dart';

/// Agenda de visitas: o app gera as visitas do agente escolhido a partir
/// do perfil dele (território + grupo prioritário).
class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  String? _agenteId;

  @override
  Widget build(BuildContext context) {
    final repo = EscopoRepositorio.of(context);
    final agentes = repo.agentes;
    // Se o agente escolhido foi removido/desativado, limpa a seleção.
    final agente = agentes.where((a) => a.id == _agenteId).firstOrNull;
    final pendentes = agente == null ? [] : repo.pendentes(agente);
    final concluidas = agente == null ? [] : repo.concluidas(agente);

    return Scaffold(
      appBar: AppBar(title: const Text('Agenda de visitas')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              value: agente?.id,
              decoration: const InputDecoration(
                  labelText: 'Agente (ACS ativo)',
                  border: OutlineInputBorder()),
              items: [
                for (final a in agentes)
                  DropdownMenuItem(value: a.id, child: Text(a.nome)),
              ],
              onChanged: (v) => setState(() => _agenteId = v),
            ),
          ),
          if (agente == null)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                  child: Text('Escolha um agente para gerar a agenda dele.')),
            )
          else ...[
            _Cabecalho(
                agente: agente,
                pendentes: pendentes.length,
                concluidas: concluidas.length),
            const _Secao('Pendentes'),
            if (pendentes.isEmpty)
              const ListTile(title: Text('Nenhuma visita pendente.')),
            for (final p in pendentes)
              VisitaTile(
                morador: p.morador,
                subtitulo: '${p.territorio} · ${p.grupo.rotulo}',
                concluida: false,
                onTap: () =>
                    Navigator.pushNamed(context, '/visita', arguments: p),
              ),
            if (concluidas.isNotEmpty) const _Secao('Concluídas'),
            for (final c in concluidas)
              VisitaTile(
                morador: c.morador,
                subtitulo:
                    '${c.concluidos} de ${c.marcados.length} itens · ${c.grupo.rotulo}',
                concluida: true,
              ),
          ],
        ],
      ),
    );
  }
}

class _Cabecalho extends StatelessWidget {
  const _Cabecalho(
      {required this.agente, required this.pendentes, required this.concluidas});

  final Usuario agente;
  final int pendentes;
  final int concluidas;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(agente.territorio,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('Grupo prioritário: ${agente.grupo?.rotulo ?? '—'}'),
            const SizedBox(height: 4),
            Text('$pendentes pendentes · $concluidas concluídas'),
          ],
        ),
      ),
    );
  }
}

class _Secao extends StatelessWidget {
  const _Secao(this.titulo);
  final String titulo;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child:
            Text(titulo, style: Theme.of(context).textTheme.titleSmall),
      );
}
