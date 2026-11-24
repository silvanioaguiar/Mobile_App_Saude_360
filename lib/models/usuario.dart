enum Perfil {
  enfermeiro('Enfermeiro'),
  medico('Médico'),
  acs('Agente comunitário de saúde'),
  gestor('Gestor');

  const Perfil(this.rotulo);
  final String rotulo;
}

/// Itens comuns a toda visita domiciliar (neutros, sem conteúdo clínico).
const itensComuns = [
  'Identidade do morador confirmada',
  'Endereço localizado',
  'Morador presente na visita',
];

/// Grupo prioritário acompanhado pelo agente. Define os itens específicos
/// do checklist (neutros: conferem registros, não orientam conduta clínica).
enum GrupoPrioritario {
  gestantes('Gestantes', [
    'Cartão da gestante conferido',
    'Data da próxima consulta lembrada',
  ]),
  criancas('Crianças', [
    'Caderneta de vacinação conferida',
    'Data da próxima consulta lembrada',
  ]),
  idosos('Idosos', [
    'Uso de medicamentos conferido (sem orientar dose)',
    'Riscos de queda na casa observados',
  ]),
  hipertensos('Hipertensos', [
    'Aferição agendada na unidade',
    'Acompanhamento pendente revisado',
  ]);

  const GrupoPrioritario(this.rotulo, this.itensEspecificos);
  final String rotulo;
  final List<String> itensEspecificos;

  List<String> get itens => [...itensComuns, ...itensEspecificos];
}

const territorios = ['Território A', 'Território B', 'Território C'];

class Usuario {
  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.perfil,
    required this.territorio,
    this.grupo,
    this.ativo = true,
  });

  final String id;
  final String nome;
  final String email;
  final Perfil perfil;
  final String territorio;

  /// Só faz sentido para o perfil [Perfil.acs]; nulo nos demais.
  final GrupoPrioritario? grupo;
  final bool ativo;

  /// Passe `grupo: null` explicitamente para limpar o grupo.
  Usuario copyWith({
    String? nome,
    String? email,
    Perfil? perfil,
    String? territorio,
    Object? grupo = _semMudanca,
    bool? ativo,
  }) =>
      Usuario(
        id: id,
        nome: nome ?? this.nome,
        email: email ?? this.email,
        perfil: perfil ?? this.perfil,
        territorio: territorio ?? this.territorio,
        grupo: identical(grupo, _semMudanca)
            ? this.grupo
            : grupo as GrupoPrioritario?,
        ativo: ativo ?? this.ativo,
      );

  static const _semMudanca = Object();

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'email': email,
        'perfil': perfil.name,
        'territorio': territorio,
        'grupo': grupo?.name,
        'ativo': ativo,
      };

  factory Usuario.fromJson(Map<String, dynamic> j) {
    final perfil = Perfil.values.byName(j['perfil'] as String);
    final nomeGrupo = j['grupo'] as String?;
    return Usuario(
      id: j['id'] as String,
      nome: j['nome'] as String,
      email: j['email'] as String,
      perfil: perfil,
      territorio: j['territorio'] as String,
      // Dados salvos antes do campo existir: ACS ganha Idosos como padrão.
      grupo: nomeGrupo != null
          ? GrupoPrioritario.values.byName(nomeGrupo)
          : (perfil == Perfil.acs ? GrupoPrioritario.idosos : null),
      ativo: j['ativo'] as bool? ?? true,
    );
  }
}
