import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saude360_mobile/data/agenda.dart';
import 'package:saude360_mobile/data/repositorio.dart';
import 'package:saude360_mobile/main.dart';
import 'package:saude360_mobile/models/usuario.dart';
import 'package:saude360_mobile/models/visita.dart';

Future<Repositorio> repoNovo() async {
  final r = Repositorio(persistir: false);
  await r.carregar();
  return r;
}

Usuario acs(String id, String territorio, GrupoPrioritario? grupo) => Usuario(
    id: id,
    nome: 'ACS $id',
    email: '$id@x.co',
    perfil: Perfil.acs,
    territorio: territorio,
    grupo: grupo);

/// Tela alta o bastante para não precisar rolar nas listas.
void telaAlta(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  group('modelos', () {
    test('usuario faz round-trip JSON com grupo', () {
      final u = acs('1', 'Território B', GrupoPrioritario.gestantes);
      final volta = Usuario.fromJson(u.toJson());
      expect(volta.perfil, Perfil.acs);
      expect(volta.territorio, 'Território B');
      expect(volta.grupo, GrupoPrioritario.gestantes);
    });

    test('JSON antigo sem grupo carrega (ACS vira Idosos, outros sem grupo)',
        () {
      final antigo = {
        'id': '1',
        'nome': 'N',
        'email': 'a@b.co',
        'perfil': 'acs',
        'territorio': 'Território A',
        'ativo': true,
      };
      expect(Usuario.fromJson(antigo).grupo, GrupoPrioritario.idosos);
      expect(Usuario.fromJson({...antigo, 'perfil': 'gestor'}).grupo, isNull);
    });

    test('copyWith limpa o grupo só quando pedido', () {
      final u = acs('1', 'Território A', GrupoPrioritario.idosos);
      expect(u.copyWith(nome: 'X').grupo, GrupoPrioritario.idosos);
      expect(u.copyWith(grupo: null).grupo, isNull);
    });

    test('itens do checklist = 3 comuns + 2 do grupo', () {
      for (final g in GrupoPrioritario.values) {
        expect(g.itens.length, 5);
        expect(g.itens.take(3), itensComuns);
      }
      expect(GrupoPrioritario.gestantes.itens,
          isNot(equals(GrupoPrioritario.idosos.itens)));
    });

    test('visita conta itens concluidos e faz round-trip', () {
      final v = Visita(
          id: '1',
          agenteId: 's2',
          morador: 'M',
          grupo: GrupoPrioritario.criancas,
          marcados: [true, false, true, false, false],
          observacao: '',
          data: DateTime(2026));
      expect(v.concluidos, 2);
      final volta = Visita.fromJson(v.toJson());
      expect(volta.marcados, v.marcados);
      expect(volta.grupo, GrupoPrioritario.criancas);
    });
  });

  group('agenda gerada pelo perfil do agente', () {
    test('é determinística e tem 4 visitas', () {
      final a = acs('a', 'Território A', GrupoPrioritario.idosos);
      final x = gerarAgenda(a), y = gerarAgenda(a);
      expect(x.length, visitasPorAgenda);
      expect(x.map((v) => v.id), y.map((v) => v.id));
    });

    test('varia com território e com grupo', () {
      final base = gerarAgenda(acs('a', 'Território A', GrupoPrioritario.idosos));
      final outroTerr =
          gerarAgenda(acs('a', 'Território B', GrupoPrioritario.idosos));
      final outroGrupo =
          gerarAgenda(acs('a', 'Território A', GrupoPrioritario.gestantes));
      expect(outroTerr.first.territorio, 'Território B');
      expect(outroTerr.first.morador, isNot(base.first.morador));
      expect(outroGrupo.first.grupo, GrupoPrioritario.gestantes);
      expect(outroGrupo.first.itens, isNot(base.first.itens));
    });

    test('quem não é ACS ou não tem grupo não gera visitas', () {
      expect(gerarAgenda(acs('a', 'Território A', null)), isEmpty);
      const gestor = Usuario(
          id: 'g',
          nome: 'G',
          email: 'g@x.co',
          perfil: Perfil.gestor,
          territorio: 'Território A',
          grupo: GrupoPrioritario.idosos);
      expect(gerarAgenda(gestor), isEmpty);
    });
  });

  group('repositorio', () {
    test('seed, salvar, editar, remover', () async {
      final r = await repoNovo();
      final n = r.usuarios.length;
      expect(r.agentes, isNotEmpty);
      await r.salvarUsuario(acs('x', 'Território A', GrupoPrioritario.idosos));
      expect(r.usuarios.length, n + 1);
      await r.salvarUsuario(r.usuarios.last.copyWith(nome: 'Editado'));
      expect(r.usuarios.length, n + 1);
      expect(r.usuarios.last.nome, 'Editado');
      await r.removerUsuario('x');
      expect(r.usuarios.length, n);
    });

    test('concluir uma visita reduz pendentes e aumenta concluídas', () async {
      final r = await repoNovo();
      final bruno = r.agentes.firstWhere((a) => a.nome.startsWith('Bruno'));
      final primeira = r.pendentes(bruno).first;
      expect(r.pendentes(bruno).length, 4);
      expect(r.concluidas(bruno), isEmpty);

      await r.registrarVisita(Visita(
          id: primeira.id,
          agenteId: bruno.id,
          morador: primeira.morador,
          grupo: primeira.grupo,
          marcados: List.filled(primeira.itens.length, true),
          observacao: '',
          data: DateTime(2026)));

      expect(r.pendentes(bruno).length, 3);
      expect(r.pendentes(bruno).map((p) => p.id), isNot(contains(primeira.id)));
      expect(r.concluidas(bruno).length, 1);
    });
  });

  group('telas', () {
    testWidgets('home -> usuarios -> novo usuario com validacao e grupo',
        (tester) async {
      telaAlta(tester);
      await tester.pumpWidget(Saude360App(repositorio: await repoNovo()));
      expect(find.text('Saúde360'), findsOneWidget);

      await tester.tap(find.text('Usuários').last);
      await tester.pumpAndSettle();
      expect(find.text('Ana Souza (fictícia)'), findsOneWidget);

      await tester.tap(find.text('Novo usuário'));
      await tester.pumpAndSettle();
      // Perfil padrão é ACS, então o grupo aparece.
      expect(find.textContaining('Grupo prioritário'), findsOneWidget);

      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();
      expect(find.text('E-mail inválido'), findsOneWidget);

      await tester.enterText(find.byType(EditableText).at(0), 'Pessoa Teste');
      await tester.enterText(find.byType(EditableText).at(1), 'p@teste.co');
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();
      expect(find.text('Pessoa Teste'), findsOneWidget);
    });

    testWidgets('grupo some quando o perfil não é ACS', (tester) async {
      telaAlta(tester);
      await tester.pumpWidget(Saude360App(repositorio: await repoNovo()));
      await tester.tap(find.text('Usuários').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Novo usuário'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownButtonFormField<Perfil>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Gestor').last);
      await tester.pumpAndSettle();
      expect(find.textContaining('Grupo prioritário'), findsNothing);
    });

    testWidgets('agenda -> checklist -> concluir atualiza a agenda',
        (tester) async {
      telaAlta(tester);
      await tester.pumpWidget(Saude360App(repositorio: await repoNovo()));

      await tester.tap(find.text('Agenda de visitas'));
      await tester.pumpAndSettle();
      expect(find.text('Escolha um agente para gerar a agenda dele.'),
          findsOneWidget);

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bruno Lima (fictício)').last);
      await tester.pumpAndSettle();
      expect(find.text('Grupo prioritário: Idosos'), findsOneWidget);
      expect(find.text('4 pendentes · 0 concluídas'), findsOneWidget);

      await tester.tap(find.text('Morador Fictício A-Idosos-01'));
      await tester.pumpAndSettle();
      expect(find.text('Progresso: 0 de 5 itens'), findsOneWidget);
      expect(find.text('Riscos de queda na casa observados'), findsOneWidget);

      await tester.tap(find.text('Endereço localizado'));
      await tester.pump();
      expect(find.text('Progresso: 1 de 5 itens'), findsOneWidget);

      await tester.tap(find.text('Concluir visita'));
      await tester.pumpAndSettle();

      expect(find.text('3 pendentes · 1 concluídas'), findsOneWidget);
      expect(find.text('Concluídas'), findsOneWidget);
      expect(find.text('1 de 5 itens · Idosos'), findsOneWidget);
    });

    testWidgets('agente de outro território/grupo gera outra agenda',
        (tester) async {
      telaAlta(tester);
      await tester.pumpWidget(Saude360App(repositorio: await repoNovo()));
      await tester.tap(find.text('Agenda de visitas'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Carla Dias (fictícia)').last);
      await tester.pumpAndSettle();
      expect(find.text('Território B'), findsOneWidget);
      expect(find.text('Morador Fictício B-Gestantes-01'), findsOneWidget);
    });
  });
}
