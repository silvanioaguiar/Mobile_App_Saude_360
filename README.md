# Saúde360 Mobile — Trabalho Prático em Grupo (Opção 1)

**Grupo 07 · Faculdade Impacta · Prof. Dr. Uedson Reis**
Entrega: 03/12/2026, apenas via repositório.

## Integrantes

| Integrante | Papel no POD |
| --- | --- |
| Silvanio Aguiar | Tech Lead |
| Wellington Lima | Product Owner |
| Lucas llech | Quality & Ops |

Plataforma alvo: **Android**.

App Flutter (Dart) com 5 telas do projeto Saúde360 IA do Bootcamp
([repositório do grupo](https://github.com/Saude360-IA/Software_Project_Saude360_Impacta_MBA)).
**Todos os dados são fictícios.** Não há diagnóstico, prescrição nem uso clínico.

## Telas

| Tela | Arquivo | O que faz |
| --- | --- | --- |
| Home | `lib/screens/home_screen.dart` | Resumo (nº de usuários e de visitas concluídas) e navegação |
| Lista de usuários | `lib/screens/usuarios_screen.dart` | Busca, editar (toque), excluir (swipe + confirmação) |
| Cadastro/edição | `lib/screens/usuario_form_screen.dart` | Formulário validado: nome, e-mail, perfil, território, ativo e, para ACS, grupo prioritário |
| Agenda de visitas | `lib/screens/agenda_screen.dart` | Escolhe o agente e o app **gera** as visitas dele; mostra pendentes e concluídas |
| Checklist de visita | `lib/screens/checklist_visita_screen.dart` | Recebe a visita da agenda, marca 5 itens (3 comuns + 2 do grupo), progresso, observação |

> **Nota sobre o número de telas:** o enunciado prevê de 2 a 4 telas. O grupo optou por 5
> (a Agenda é a tela extra). **A confirmar com o Prof. Uedson.**

## Identidade visual

Tema em `lib/theme/app_theme.dart`, com a paleta do Saúde360: primária `#002B4B`,
secundária `#087DCE`, teal `#00A6B2`, sucesso `#19C65A` (visitas e itens concluídos),
fundo `#E8F5FA` e branco `#FFFFFF`. O logo fica em `assets/images/Logo_360_fundo_transparente.png`
e aparece na Home.

## Como as visitas são geradas

O perfil do agente comunitário de saúde (ACS) combina **território** e **grupo prioritário**
(gestantes, crianças, idosos ou hipertensos), definidos no cadastro de usuário.
`gerarAgenda` (`lib/data/agenda.dart`) cria 4 visitas fictícias para esse perfil:

- o **território** define os moradores fictícios (ex.: `Morador Fictício A-Idosos-01`);
- o **grupo** define os 2 itens específicos do checklist, somados a 3 itens comuns.

Os itens só conferem registros (cartão, caderneta, agendamentos); não orientam conduta clínica.
A geração é determinística, então o app sabe quais visitas já foram concluídas.

## Conceitos exigidos

| Conceito | Onde |
| --- | --- |
| **Componentes** | `lib/widgets/`: `AppCard`, `UsuarioTile`, `VisitaTile`, `ChecklistItemTile`, `ProgressoVisita` |
| **Estado** | `setState` nas telas; `Repositorio` (`ChangeNotifier`) + `EscopoRepositorio` (`InheritedNotifier`) para estado compartilhado |
| **Eventos** | `onTap`, `onChanged` (agente, checkboxes), `onPressed`, `Dismissible`, diálogo de confirmação, validação de `Form` |
| **Navegação** | `Navigator` com rotas nomeadas em `lib/main.dart`; argumentos (`Usuario` a editar, `VisitaPlanejada` para o checklist) e `pop` com resultado |

Persistência local com `shared_preferences` (JSON), equivalente ao AsyncStorage do enunciado.

## Como rodar

```bash
flutter pub get
flutter test
flutter devices           # lista emuladores e aparelhos conectados
flutter run -d android    # emulador Android ou aparelho com depuração USB
```

Para gerar o APK: `flutter build apk --debug` (saída em `build/app/outputs/flutter-apk/`).

> No Windows, o **Modo Desenvolvedor** precisa estar ativo
> (`start ms-settings:developers`) para o Flutter instalar os plugins.

## Estrutura

```
lib/
  main.dart            # MaterialApp, tema, rotas
  models/              # Usuario, Perfil, GrupoPrioritario, Visita, VisitaPlanejada
  data/                # Repositorio (estado + persistência), EscopoRepositorio, gerarAgenda
  screens/             # 5 telas
  widgets/             # componentes reutilizáveis
test/app_test.dart     # modelos, repositório e fluxos de widget
```
