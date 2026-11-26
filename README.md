# Saúde360 Mobile — Trabalho Prático em Grupo (Opção 1)

**Grupo 07 · Faculdade Impacta · Prof. Dr. Uedson Reis**
Entrega: 03/12/2026, apenas via repositório.

## Integrantes

| Integrante | Papel no POD |
| --- | --- |
| Silvanio Aguiar | Tech Lead |
| Wellington Lima | Product Owner |
| Lucas llech | Quality & Ops |

Plataformas: **Android** (APK) e **Web instalável (PWA)**. A explicação do PWA está na
seção [PWA: o app instalável pelo navegador](#pwa-o-app-instalável-pelo-navegador).

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

## PWA: o app instalável pelo navegador

### O que é um PWA?

**PWA** (*Progressive Web App*) é um site que se comporta como um aplicativo: dá para
**instalar** na tela inicial do celular ou do computador, abre em **tela cheia** (sem barra de
endereço), tem **ícone e nome próprios** e **continua abrindo sem internet**.
Não é uma tecnologia nova, e sim um conjunto de recursos do navegador usados em conjunto.

Comparação rápida com o APK:

| | APK (Android nativo) | PWA |
| --- | --- | --- |
| Como o usuário instala | Recebe o arquivo `.apk` ou baixa da loja | Abre o link e toca em "Instalar" |
| Funciona em | Só Android | Android, Windows, macOS, Linux, ChromeOS (e iOS com limitações) |
| Atualização | Instalar um APK novo | Automática: basta publicar de novo |
| Acesso a recursos do aparelho | Total | Limitado ao que o navegador permite |
| Esse projeto | `flutter build apk` | `flutter build web` |

### Os 3 ingredientes de um PWA

Para o navegador oferecer "Instalar app", o site precisa de três coisas. Pense numa loja:

1. **HTTPS** (a porta de entrada segura). O service worker só funciona em endereço seguro
   (`https://...`). A única exceção é `localhost`, para desenvolvimento.
2. **Manifesto** (o cartão de visitas do app). Um arquivo JSON com nome, ícones, cores e modo de
   exibição. É ele que diz ao sistema "este site é um app chamado Saúde360, com este ícone".
3. **Service worker** (o funcionário que guarda o estoque). Um script que o navegador roda em
   segundo plano, entre o app e a internet. Ele guarda cópias dos arquivos (cache) e, quando a
   rede cai, entrega as cópias. É ele que permite abrir **offline**.

### Como cada ingrediente foi feito neste projeto

O Flutter Web já gera boa parte do PWA sozinho. O grupo configurou e personalizou o resto:

| Ingrediente | Arquivo | Quem faz | O que foi feito |
| --- | --- | --- | --- |
| Manifesto | [`web/manifest.json`](web/manifest.json) | Grupo | Nome "Saúde360", `display: standalone` (tela cheia), cores do tema (`#002B4B` e `#E8F5FA`), idioma `pt-BR` e os ícones |
| Ícones | `web/icons/` e `web/favicon.png` | Grupo | Gerados a partir do logo. O ícone `maskable` tem margem de segurança, porque o Android recorta em círculo ou quadrado arredondado |
| Página de entrada | [`web/index.html`](web/index.html) | Grupo | Liga o manifesto, define `theme-color`, ajustes para iOS e uma tela de carregamento com o logo enquanto o Flutter inicia |
| Service worker | `flutter_service_worker.js` | **Flutter**, no build | Criado automaticamente por `flutter build web`, com a lista de arquivos e uma versão de cada um |
| HTTPS | Hospedagem | Quem publica | O GitHub Pages, por exemplo, já entrega HTTPS |

O arquivo do service worker **não está no repositório**: ele nasce em `build/web/` a cada build.

### O que acontece quando alguém usa o app

```
1ª visita (online)   O navegador baixa o app e registra o service worker.
                     O service worker guarda os arquivos essenciais no cache.
2ª visita (online)   Agora o service worker "assume" a página e guarda também a tela inicial.
Sem internet         O service worker responde com as cópias do cache. O app abre normalmente.
Nova versão          Ao publicar um build novo, o service worker percebe que os arquivos
                     mudaram, baixa as novidades e as aplica na visita seguinte.
```

Por isso o app só funciona offline **a partir da segunda visita**. Isso é comportamento normal
do Flutter, não um defeito.

### Onde ficam os dados?

O armazenamento local usa o pacote `shared_preferences`. No celular Android ele grava no
próprio aparelho; na **web grava no `localStorage` do navegador**. Na prática:

- os dados persistem ao fechar e reabrir o app, e funcionam offline;
- ficam **só naquele navegador e naquele aparelho** (não sincronizam entre dispositivos);
- se a pessoa limpar os dados do site, eles voltam ao padrão fictício.

Isso é suficiente para a demonstração. Compartilhar dados entre aparelhos exigiria um backend,
que está fora do escopo deste trabalho.

### Mudanças feitas no app para a web

- **Largura máxima de 600 px.** Em tela de computador, o conteúdo fica numa coluna centralizada,
  parecida com a do celular (`builder` do `MaterialApp` em `lib/main.dart`). No celular nada muda.
- **Mesmo código para tudo.** As telas, o estado e os testes são os mesmos do Android. Só a pasta
  `web/` é específica do PWA.

### Como testar o PWA

```bash
flutter build web --release          # gera build/web (inclui o service worker)
```

Sirva a pasta `build/web` com qualquer servidor estático e abra em `http://localhost:<porta>`
(o `localhost` é aceito sem HTTPS). Exemplos:

```bash
cd build/web
npx http-server -p 8080              # precisa do Node.js
# ou: python -m http.server 8080     # precisa do Python
```

No Chrome, abra as **Ferramentas do desenvolvedor (F12) → Application**:

- **Manifest**: confere nome, cores e ícones.
- **Service Workers**: deve aparecer `flutter_service_worker.js` como *activated*.
- Marque **Offline**, recarregue a página e veja o app abrir.

Para instalar: no Chrome do computador, clique no ícone de instalar na barra de endereço; no
Android, use o menu ⋮ → **Instalar app** (ou **Adicionar à tela inicial**).

> Não use `flutter run -d chrome` para testar o PWA: no modo de desenvolvimento o service
> worker fica desligado. Teste sempre o build de release.

### Publicação (GitHub Pages)

**Endereço do app:** <https://silvanioaguiar.github.io/Mobile_App_Saude_360/>

O GitHub Pages hospeda os arquivos gerados e já entrega HTTPS. O código-fonte fica no branch
`main` e o site pronto fica no branch `gh-pages` (só arquivos gerados, não se edita à mão).

Como o endereço fica num subcaminho (`/Mobile_App_Saude_360/`), o build precisa saber qual é:

```bash
flutter build web --release --base-href "/Mobile_App_Saude_360/"
```

O `--base-href` tem de começar e terminar com `/` e repetir o nome do repositório; se estiver
errado, a página abre em branco.

> **Git Bash no Windows:** o terminal converte `/Mobile_App_Saude_360/` em um caminho do Windows e o
> Flutter recusa o valor. Rode antes `export MSYS_NO_PATHCONV=1`, ou use o PowerShell.

**Para publicar uma nova versão:**

1. Rode o build acima.
2. Copie o conteúdo de `build/web/` para uma pasta vazia e crie nela um arquivo `.nojekyll`
   (impede o GitHub de processar os arquivos como site Jekyll).
3. Nessa pasta: `git init -b gh-pages`, `git add -A`, `git commit`, e
   `git push --force origin gh-pages` (substitui só o branch `gh-pages`).

**Ligar o Pages (uma única vez, feito pelo dono do repositório):**
*Settings → Pages → Build and deployment → Source: **Deploy from a branch** → Branch:
**gh-pages** / **(root)** → Save.* Em 1 a 2 minutos o endereço acima passa a responder.

### Limitações conhecidas

- **iPhone/iPad:** o Safari instala PWAs por **Compartilhar → Adicionar à Tela de Início** e
  limita parte dos recursos. Por isso `index.html` tem meta tags específicas para iOS.
- **Primeira visita precisa de internet.** Só depois de carregar uma vez o app passa a funcionar
  offline.
- **Cache pode mostrar versão antiga.** Depois de publicar uma atualização, pode ser preciso
  fechar e reabrir o app uma vez para a nova versão aparecer.
- **Dados locais:** ver a seção "Onde ficam os dados?".

## Estrutura

```
lib/
  main.dart            # MaterialApp, tema, rotas
  models/              # Usuario, Perfil, GrupoPrioritario, Visita, VisitaPlanejada
  data/                # Repositorio (estado + persistência), EscopoRepositorio, gerarAgenda
  screens/             # 5 telas
  widgets/             # componentes reutilizáveis
web/                   # PWA: manifest.json, index.html, ícones
test/app_test.dart     # modelos, repositório e fluxos de widget
```
