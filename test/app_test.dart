import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saude360_mobile/data/repositorio.dart';
import 'package:saude360_mobile/main.dart';
import 'package:saude360_mobile/models/usuario.dart';
import 'package:saude360_mobile/models/visita.dart';

Future<Repositorio> repoNovo() async {
  final r = Repositorio(persistir: false);
  await r.carregar();
  return r;
}

void main() {
  test('usuario faz round-trip JSON', () {
    const u = Usuario(
        id: '1',
        nome: 'Teste',
        email: 'a@b.co',
        perfil: Perfil.medico,
        territorio: 'Território B');
    final volta = Usuario.fromJson(u.toJson());
    expect(volta.perfil, Perfil.medico);
    expect(volta.territorio, 'Território B');
  });

  test('repositorio: seed, salvar, editar, remover', () async {
    final r = await repoNovo();
    final n = r.usuarios.length;
    expect(r.agentes, isNotEmpty);
    await r.salvarUsuario(const Usuario(
        id: 'x',
        nome: 'Novo',
        email: 'n@x.co',
        perfil: Perfil.acs,
        territorio: 'Território A'));
    expect(r.usuarios.length, n + 1);
    await r.salvarUsuario(r.usuarios.last.copyWith(nome: 'Editado'));
    expect(r.usuarios.length, n + 1);
    expect(r.usuarios.last.nome, 'Editado');
    await r.removerUsuario('x');
    expect(r.usuarios.length, n);
  });

  test('visita conta itens concluidos', () {
    final v = Visita(
        id: '1',
        agenteId: 's2',
        morador: 'M',
        marcados: [true, false, true, false, false, false],
        observacao: '',
        data: DateTime(2026));
    expect(v.concluidos, 2);
    expect(Visita.fromJson(v.toJson()).marcados, v.marcados);
  });

  testWidgets('fluxo: home -> usuarios -> novo usuario com validacao',
      (tester) async {
    await tester.pumpWidget(Saude360App(repositorio: await repoNovo()));
    expect(find.text('Saúde360'), findsOneWidget);

    await tester.tap(find.text('Usuários').last);
    await tester.pumpAndSettle();
    expect(find.text('Ana Souza (fictícia)'), findsOneWidget);

    await tester.tap(find.text('Novo usuário'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(find.text('E-mail inválido'), findsOneWidget);

    await tester.enterText(find.byType(EditableText).at(0), 'Pessoa Teste');
    await tester.enterText(find.byType(EditableText).at(1), 'p@teste.co');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(find.text('Pessoa Teste'), findsOneWidget);
  });

  testWidgets('checklist: progresso e botao desabilitado sem agente',
      (tester) async {
    await tester.pumpWidget(Saude360App(repositorio: await repoNovo()));
    await tester.tap(find.text('Nova visita'));
    await tester.pumpAndSettle();
    expect(find.text('Progresso: 0 de 6 itens'), findsOneWidget);
    await tester.tap(find.text('Endereço localizado'));
    await tester.pump();
    expect(find.text('Progresso: 1 de 6 itens'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Escolha o agente'), 200,
        scrollable: find.byType(Scrollable).first);
    final botao = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(botao.onPressed, isNull);
  });
}
