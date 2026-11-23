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
          Text('Olá! Grupo 07', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          const Text('Demonstração com dados fictícios, sem uso clínico.'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _Resumo('Usuários', repo.usuarios.length)),
              const SizedBox(width: 12),
              Expanded(child: _Resumo('Visitas', repo.visitas.length)),
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
            titulo: 'Nova visita',
            subtitulo: 'Checklist de visita domiciliar',
            onTap: () => Navigator.pushNamed(context, '/visita'),
          ),
        ],
      ),
    );
  }
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
