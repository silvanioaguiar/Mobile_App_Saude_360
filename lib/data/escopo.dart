import 'package:flutter/widgets.dart';

import 'repositorio.dart';

/// Disponibiliza o [Repositorio] para toda a árvore e reconstrói
/// os widgets dependentes quando ele notifica mudanças.
class EscopoRepositorio extends InheritedNotifier<Repositorio> {
  const EscopoRepositorio({
    super.key,
    required Repositorio repositorio,
    required super.child,
  }) : super(notifier: repositorio);

  static Repositorio of(BuildContext context) {
    final escopo =
        context.dependOnInheritedWidgetOfExactType<EscopoRepositorio>();
    assert(escopo != null, 'EscopoRepositorio não encontrado');
    return escopo!.notifier!;
  }
}
