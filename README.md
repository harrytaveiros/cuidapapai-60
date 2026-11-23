<h1 align="center">
  💛 CuidaPapai+60
</h1>

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white">
  <img alt="Dart" src="https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white">
  <img alt="Status" src="https://img.shields.io/badge/Status-Em%20Desenvolvimento-success?style=for-the-badge">
</p>

## 📖 Sobre o Projeto

O **CuidaPapai+60** é um aplicativo móvel criado para devolver autonomia e segurança às pessoas da terceira idade. Ele centraliza a organização da rotina diária, envia alertas de medicamentos, permite o registro rápido de métricas de saúde e mantém uma rede de apoio (familiares e cuidadores profissionais) a apenas um toque de distância. 

O projeto foi construído pensando exclusivamente nas limitações cognitivas e motoras do público idoso, eliminando navegações complexas e priorizando a legibilidade.

---

## ♿ Foco em Acessibilidade e UI/UX

- **Design System Inclusivo:** Temas geridos via Singleton com suporte imediato a Alto Contraste (Modo claro com tons suaves de verde/amarelo e Modo escuro em vermelho vibrante para alertas visuais).
- **Tipografia Adaptada:** Textos descritivos em escala maior (Headline/BodyLarge) para facilitar a leitura sem forçar a visão.
- **Navegação Previsível:** `BottomNavigationBar` estática acoplada a um `IndexedStack`. Elimina o gesto de "arrastar" (swipe) que frequentemente causa desorientação espacial em usuários idosos.
- **Áreas de Toque Generosas:** Botões de confirmação e cartões espaçados com *padding* amplo para evitar toques acidentais.

---

## ✨ Funcionalidades Principais

📱 **Início (Home):**
- Saudação personalizada e visualização imediata do próximo medicamento do dia com botão de confirmação fácil.
- Grade de acesso rápido para registro de cuidados e contato com a rede de apoio.
- Resumo dinâmico do próximo compromisso da agenda.

📅 **Minha Agenda (Timeline):**
- Linha do tempo visual (Timeline) para acompanhar consultas médicas, sessões de fisioterapia e almoços em família.
- Indicadores coloridos por categoria de evento.

💚 **Cuidados Diários:**
- Checklist de acompanhamento diário (Pressão arterial, Alimentação, Humor, Atividade física).
- Barra de progresso interativa que motiva o preenchimento da rotina de saúde.

👥 **Rede de Apoio:**
- Central de contatos emergenciais e cotidianos categorizados (Familiares e Cuidadores Profissionais).
- Identificação clara de quem está "Disponível Hoje" com botões diretos para ligação.

---

## 🛠️ Tecnologias e Arquitetura

O aplicativo foi desenvolvido seguindo boas práticas de **Clean Code** e separação de responsabilidades:

- **Framework:** Flutter / Dart
- **Injeção de Dependências:** `get_it`
- **Gerenciamento de Estado Global:** `ChangeNotifier` (ThemeManager)
- **Gerenciamento de Estado Local:** `StatefulWidgets` e `setState` para reatividade local controlada.
- **Camada de Dados:** Uso de Models limpos e Services Singleton atuando com dados *mockados* que preparam o terreno para o consumo de API REST.

---
1. Clone este repositório:
```bash
git clone [https://github.com/seu-usuario/cuidapapai-60.git](https://github.com/seu-usuario/cuidapapai-60.git)
