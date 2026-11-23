/// Itens do checklist de visita domiciliar (neutros, sem conteúdo clínico).
const itensChecklist = [
  'Identidade do morador confirmada',
  'Endereço localizado',
  'Morador presente na visita',
  'Orientações entregues',
  'Acompanhamento pendente revisado',
  'Necessidade de retorno marcada',
];

/// Moradores fictícios usados na demonstração.
const moradoresSinteticos = [
  'Morador Fictício 01',
  'Morador Fictício 02',
  'Morador Fictício 03',
  'Morador Fictício 04',
];

class Visita {
  const Visita({
    required this.id,
    required this.agenteId,
    required this.morador,
    required this.marcados,
    required this.observacao,
    required this.data,
  });

  final String id;
  final String agenteId;
  final String morador;

  /// Mesmo tamanho de [itensChecklist]; true = item cumprido.
  final List<bool> marcados;
  final String observacao;
  final DateTime data;

  int get concluidos => marcados.where((m) => m).length;

  Map<String, dynamic> toJson() => {
        'id': id,
        'agenteId': agenteId,
        'morador': morador,
        'marcados': marcados,
        'observacao': observacao,
        'data': data.toIso8601String(),
      };

  factory Visita.fromJson(Map<String, dynamic> j) => Visita(
        id: j['id'] as String,
        agenteId: j['agenteId'] as String,
        morador: j['morador'] as String,
        marcados: (j['marcados'] as List).cast<bool>(),
        observacao: j['observacao'] as String? ?? '',
        data: DateTime.parse(j['data'] as String),
      );
}
