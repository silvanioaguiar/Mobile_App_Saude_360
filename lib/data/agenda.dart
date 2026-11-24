import '../models/usuario.dart';
import '../models/visita.dart';

const visitasPorAgenda = 4;

/// Gera a agenda do agente a partir do perfil dele (território + grupo).
/// Função pura e determinística: o mesmo agente sempre gera os mesmos ids,
/// o que permite saber quais visitas já foram concluídas.
List<VisitaPlanejada> gerarAgenda(Usuario acs) {
  final grupo = acs.grupo;
  if (acs.perfil != Perfil.acs || grupo == null) return const [];
  // "Território A" -> "A"
  final letra = acs.territorio.split(' ').last;
  return [
    for (var n = 1; n <= visitasPorAgenda; n++)
      VisitaPlanejada(
        id: '${acs.id}-$letra-${grupo.name}-$n',
        agenteId: acs.id,
        morador:
            'Morador Fictício $letra-${grupo.rotulo}-${n.toString().padLeft(2, '0')}',
        territorio: acs.territorio,
        grupo: grupo,
      ),
  ];
}
