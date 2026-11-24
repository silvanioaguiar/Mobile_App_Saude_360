import 'package:flutter/material.dart';

import '../data/escopo.dart';
import '../widgets/app_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = EscopoRepositorio.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Saúde360')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _Logo(),
          const SizedBox(height: 16),
          Text('Bem-vindo!', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          const Text('Demonstração com dados fictícios, sem uso clínico.'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _Resumo('Usuários', repo.usuarios.length)),
              const SizedBox(width: 12),
              Expanded(child: _Resumo('Visitas concluídas', repo.visitas.length)),
            ],
          ),
          const SizedBox(height: 16),
          AppCard(
            icone: Icons.people,
            titulo: 'Usuários',
            subtitulo: 'Listar, cadastrar e editar',
            onTap: () => Navigator.pushNamed(context, '/usuarios'),
          ),
          AppCard(
            icone: Icons.fact_check,
            titulo: 'Agenda de visitas',
            subtitulo: 'Visitas geradas pelo perfil do agente',
            onTap: () => Navigator.pushNamed(context, '/agenda'),
          ),
        ],
      ),
    );
  }
}

/// Logo em PNG com fundo transparente, direto sobre o fundo do tema.
class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) => Image.asset(
        'assets/images/Logo_360_fundo_transparente.png',
        height: 160,
        fit: BoxFit.contain,
        semanticLabel: 'Logo Saúde360',
      );
}

class _Resumo extends StatelessWidget {
  const _Resumo(this.rotulo, this.valor);
  final String rotulo;
  final int valor;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Text('$valor', style: Theme.of(context).textTheme.headlineMedium),
            Text(rotulo),
          ]),
        ),
      );
}
