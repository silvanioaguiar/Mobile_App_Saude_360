import 'package:flutter/material.dart';

import 'data/escopo.dart';
import 'data/repositorio.dart';
import 'screens/agenda_screen.dart';
import 'screens/checklist_visita_screen.dart';
import 'screens/home_screen.dart';
import 'screens/usuario_form_screen.dart';
import 'screens/usuarios_screen.dart';

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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
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
