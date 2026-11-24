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

App Flutter (Dart) com 4 telas do projeto Saúde360 IA do Bootcamp
([repositório do grupo](https://github.com/Saude360-IA/Software_Project_Saude360_Impacta_MBA)).
**Todos os dados são fictícios.** Não há diagnóstico, prescrição nem uso clínico.

## Telas

| Tela | Arquivo | O que faz |
| --- | --- | --- |
| Home | `lib/screens/home_screen.dart` | Resumo (nº de usuários/visitas) e navegação |
| Lista de usuários | `lib/screens/usuarios_screen.dart` | Busca, editar (toque), excluir (swipe + confirmação) |
| Cadastro/edição | `lib/screens/usuario_form_screen.dart` | Formulário validado: nome, e-mail, perfil, território, ativo |
| Checklist de visita | `lib/screens/checklist_visita_screen.dart` | Escolhe agente e morador, marca 6 itens, progresso, observação |

## Conceitos exigidos

| Conceito | Onde |
| --- | --- |
| **Componentes** | `lib/widgets/`: `AppCard`, `UsuarioTile`, `ChecklistItemTile`, `ProgressoVisita` |
| **Estado** | `setState` nas telas; `Repositorio` (`ChangeNotifier`) + `EscopoRepositorio` (`InheritedNotifier`) para estado compartilhado |
| **Eventos** | `onTap`, `onChanged`, `onPressed`, `Dismissible`, diálogo de confirmação, validação de `Form` |
| **Navegação** | `Navigator` com rotas nomeadas em `lib/main.dart`; argumentos (`Usuario` a editar) e `pop` com resultado |

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
  models/              # Usuario, Perfil, Visita, itens do checklist
  data/                # Repositorio (estado + persistência), EscopoRepositorio
  screens/             # 4 telas
  widgets/             # componentes reutilizáveis
test/app_test.dart     # modelos, repositório e fluxos de widget
```
