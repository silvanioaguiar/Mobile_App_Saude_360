enum Perfil {
  enfermeiro('Enfermeiro'),
  medico('Médico'),
  acs('Agente comunitário de saúde'),
  gestor('Gestor');

  const Perfil(this.rotulo);
  final String rotulo;
}

const territorios = ['Território A', 'Território B', 'Território C'];

class Usuario {
  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.perfil,
    required this.territorio,
    this.ativo = true,
  });

  final String id;
  final String nome;
  final String email;
  final Perfil perfil;
  final String territorio;
  final bool ativo;

  Usuario copyWith({
    String? nome,
    String? email,
    Perfil? perfil,
    String? territorio,
    bool? ativo,
  }) =>
      Usuario(
        id: id,
        nome: nome ?? this.nome,
        email: email ?? this.email,
        perfil: perfil ?? this.perfil,
        territorio: territorio ?? this.territorio,
        ativo: ativo ?? this.ativo,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'email': email,
        'perfil': perfil.name,
        'territorio': territorio,
        'ativo': ativo,
      };

  factory Usuario.fromJson(Map<String, dynamic> j) => Usuario(
        id: j['id'] as String,
        nome: j['nome'] as String,
        email: j['email'] as String,
        perfil: Perfil.values.byName(j['perfil'] as String),
        territorio: j['territorio'] as String,
        ativo: j['ativo'] as bool? ?? true,
      );
}
