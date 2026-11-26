import 'package:flutter/material.dart';

import 'data/escopo.dart';
import 'data/repositorio.dart';
import 'screens/agenda_screen.dart';
import 'screens/checklist_visita_screen.dart';
import 'screens/home_screen.dart';
import 'screens/usuario_form_screen.dart';
import 'screens/usuarios_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = Repositorio();
  await repo.carregar();
  runApp(Saude360App(repositorio: repo));
}

class Saude360App extends StatelessWidget {
  const Saude360App({super.key, required this.repositorio});

  final Repositorio repositorio;

  @override
  Widget build(BuildContext context) {
    return EscopoRepositorio(
      repositorio: repositorio,
      child: MaterialApp(
        title: 'Saúde360',
        theme: AppTheme.light,
        // Em telas largas (PWA no computador/tablet) o app fica numa coluna
        // centralizada de até 600 px, parecida com o celular.
        builder: (context, child) => ColoredBox(
          color: Cores.background,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: child,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const HomeScreen(),
          '/usuarios': (_) => const UsuariosScreen(),
          '/usuario': (_) => const UsuarioFormScreen(),
          '/agenda': (_) => const AgendaScreen(),
          '/visita': (_) => const ChecklistVisitaScreen(),
        },
      ),
    );
  }
}
