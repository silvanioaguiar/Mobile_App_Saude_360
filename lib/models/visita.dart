import 'usuario.dart';

/// Visita gerada pela agenda do agente (ainda não realizada).
class VisitaPlanejada {
  const VisitaPlanejada({
    required this.id,
    required this.agenteId,
    required this.morador,
    required this.territorio,
    required this.grupo,
  });

  final String id;
  final String agenteId;
  final String morador;
  final String territorio;
  final GrupoPrioritario grupo;

  /// Itens do checklist: comuns + específicos do grupo.
  List<String> get itens => grupo.itens;
}

/// Visita concluída, com o checklist preenchido.
class Visita {
  const Visita({
    required this.id,
    required this.agenteId,
    required this.morador,
    required this.grupo,
    required this.marcados,
    required this.observacao,
    required this.data,
  });

  /// Mesmo id da [VisitaPlanejada] que originou esta visita.
  final String id;
  final String agenteId;
  final String morador;
  final GrupoPrioritario grupo;

  /// Mesmo tamanho de `grupo.itens`; true = item cumprido.
  final List<bool> marcados;
  final String observacao;
  final DateTime data;

  int get concluidos => marcados.where((m) => m).length;

  Map<String, dynamic> toJson() => {
        'id': id,
        'agenteId': agenteId,
        'morador': morador,
        'grupo': grupo.name,
        'marcados': marcados,
        'observacao': observacao,
        'data': data.toIso8601String(),
      };

  factory Visita.fromJson(Map<String, dynamic> j) => Visita(
        id: j['id'] as String,
        agenteId: j['agenteId'] as String,
        morador: j['morador'] as String,
        grupo: GrupoPrioritario.values
            .byName(j['grupo'] as String? ?? GrupoPrioritario.idosos.name),
        marcados: (j['marcados'] as List).cast<bool>(),
        observacao: j['observacao'] as String? ?? '',
        data: DateTime.parse(j['data'] as String),
      );
}
