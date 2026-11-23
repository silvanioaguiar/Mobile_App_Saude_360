import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/usuario.dart';
import '../models/visita.dart';

/// Estado compartilhado do app (ChangeNotifier) com persistência local.
class Repositorio extends ChangeNotifier {
  Repositorio({this.persistir = true});

  final bool persistir;
  static const _chaveUsuarios = 'usuarios';
  static const _chaveVisitas = 'visitas';

  final List<Usuario> _usuarios = [];
  final List<Visita> _visitas = [];

  List<Usuario> get usuarios => List.unmodifiable(_usuarios);
  List<Visita> get visitas => List.unmodifiable(_visitas);
  List<Usuario> get agentes =>
      _usuarios.where((u) => u.perfil == Perfil.acs && u.ativo).toList();

  /// Carrega do armazenamento local; se vazio, usa dados sintéticos.
  Future<void> carregar() async {
    if (persistir) {
      final prefs = await SharedPreferences.getInstance();
      final u = prefs.getString(_chaveUsuarios);
      final v = prefs.getString(_chaveVisitas);
      if (u != null) {
        _usuarios.addAll((jsonDecode(u) as List)
            .map((e) => Usuario.fromJson(e as Map<String, dynamic>)));
      }
      if (v != null) {
        _visitas.addAll((jsonDecode(v) as List)
            .map((e) => Visita.fromJson(e as Map<String, dynamic>)));
      }
      if (u != null) {
        notifyListeners();
        return;
      }
    }
    _usuarios.addAll(_seed);
    await _salvar();
    notifyListeners();
  }

  Future<void> salvarUsuario(Usuario usuario) async {
    final i = _usuarios.indexWhere((u) => u.id == usuario.id);
    if (i >= 0) {
      _usuarios[i] = usuario;
    } else {
      _usuarios.add(usuario);
    }
    await _salvar();
    notifyListeners();
  }

  Future<void> removerUsuario(String id) async {
    _usuarios.removeWhere((u) => u.id == id);
    await _salvar();
    notifyListeners();
  }

  Future<void> registrarVisita(Visita visita) async {
    _visitas.add(visita);
    await _salvar();
    notifyListeners();
  }

  String novoId() => DateTime.now().microsecondsSinceEpoch.toString();

  Future<void> _salvar() async {
    if (!persistir) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _chaveUsuarios, jsonEncode(_usuarios.map((u) => u.toJson()).toList()));
    await prefs.setString(
        _chaveVisitas, jsonEncode(_visitas.map((v) => v.toJson()).toList()));
  }

  static const _seed = [
    Usuario(
        id: 's1',
        nome: 'Ana Souza (fictícia)',
        email: 'ana@exemplo.test',
        perfil: Perfil.enfermeiro,
        territorio: 'Território A'),
    Usuario(
        id: 's2',
        nome: 'Bruno Lima (fictício)',
        email: 'bruno@exemplo.test',
        perfil: Perfil.acs,
        territorio: 'Território A'),
    Usuario(
        id: 's3',
        nome: 'Carla Dias (fictícia)',
        email: 'carla@exemplo.test',
        perfil: Perfil.acs,
        territorio: 'Território B'),
    Usuario(
        id: 's4',
        nome: 'Daniel Rocha (fictício)',
        email: 'daniel@exemplo.test',
        perfil: Perfil.gestor,
        territorio: 'Território C',
        ativo: false),
  ];
}
