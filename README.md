# 🎯 Prospector de Sites — v2.1.1

**Plugin para Claude (Cowork) — ciclo completo de prospecção e venda de sites com CRM local incluso.**

> **Achou → Refez → Publicou → Ofertou → Acompanhou → Fechou → Contrato.**

Gratuito, roda no seu computador, sem mensalidade. Publica via **FTP/cPanel** (qualquer hospedagem compartilhada) ou **SSH/rsync** (VPS).

---

## Sumário

- [1. O que você precisa antes](#1-o-que-você-precisa-antes)
- [2. Instalação do plugin](#2-instalação-do-plugin)
- [3. Configuração (`/setup` — uma vez só)](#3-configuração-setup--uma-vez-só)
- [4. Escolha seu método de publicação](#4-escolha-seu-método-de-publicação)
- [5. Publicador automático (opcional, mas recomendado)](#5-publicador-automático-opcional-mas-recomendado)
- [6. O ciclo completo (passo a passo)](#6-o-ciclo-completo-passo-a-passo)
- [7. O dashboard (seu CRM local)](#7-o-dashboard-seu-crm-local)
- [8. E no Mac?](#8-e-no-mac)
- [9. Estrutura da pasta](#9-estrutura-da-pasta)
- [10. Problemas comuns](#10-problemas-comuns)
- [11. Atualizar o plugin](#11-atualizar-o-plugin)

---

## 1. O que você precisa antes

- **Claude Cowork** (app do Claude pra desktop)
- **Extensão Claude in Chrome** conectada — é ela que navega no Google Maps durante a prospecção
- **Conector do Gmail** ativo (Configurações do Cowork → Conectores) — para criar rascunhos de proposta e ler respostas
- **Conector do Google Drive** — para a planilha de leads no Google Sheets
- **Python 3** instalado ([python.org](https://www.python.org/downloads/)) com a opção **"Add to PATH"** marcada — necessário para o dashboard e o publicador
- **Uma pasta conectada no Cowork** (ex.: "Clientes") — todo o projeto fica salvo nela
- **Uma hospedagem** com FTP/cPanel ou SSH (veja seção 4)

---

## 2. Instalação do plugin

### No Claude Cowork

1. Abra o Claude Cowork
2. Vá em **Plugins → Gerenciar plugins → Adicionar marketplace**
3. Cole a URL do repositório:
   ```
   https://github.com/desilascarvalho/PROSPECTOR-DE-SITES
   ```
4. Instale o plugin **prospector-de-sites**
5. No chat, rode:
   ```
   /setup
   ```

### No Claude Code

```
/plugin marketplace add desilascarvalho/PROSPECTOR-DE-SITES
/plugin install prospector-de-sites@desilascarvalho-plugins
```

---

## 3. Configuração (`/setup` — uma vez só)

O `/setup` faz tudo em 3 etapas:

### 3.1 Seus dados

Responda no chat:

- **Assinatura da proposta**: nome completo, como quer se apresentar (ex.: "Designer de páginas de alta conversão") e WhatsApp/telefone
- **Nichos padrão de prospecção**: sugestão inicial — nutricionistas, psicólogos, advogados, psiquiatras (você pode mudar depois)
- **Cidade/região padrão** — onde o plugin vai buscar leads
- **Leads por busca**: padrão 10
- **Modo de envio**: "criar rascunho no Gmail para revisão" (recomendado) ou "enviar direto"

### 3.2 Dados da hospedagem (FAÇA NO DASHBOARD, NUNCA NO CHAT)

**⚠️ Nenhuma senha é digitada no chat.** Tudo é feito pelo dashboard:

1. Abra o arquivo **`iniciar-dashboard.bat`** (Windows) ou **`iniciar-dashboard.command`** (Mac) na sua pasta conectada — dois cliques
2. O painel abre em `http://localhost:8765`
3. Vá na aba **Configurações** → seção de **publicação**
4. Escolha **FTP** ou **SSH** (veja seção 4 abaixo) e preencha os campos
5. Clique em **Salvar conexão** — os dados vão direto pro arquivo no seu computador, o chat nunca vê

### 3.3 Teste e entrega

Depois de salvar, avise o Claude ("salvei"). Ele:

- Lê o config (sem nunca mostrar a senha)
- Faz um teste de publicação (sobe uma página `teste.html`)
- **Entrega na sua pasta:**
  - `manual.html` — este manual completo
  - `iniciar-dashboard.bat` / `.command` — atalho do painel
  - `publicar-agora.bat` / `.command` — publicação manual
  - `instalar-publicador.bat` / `.command` — instalador do publicador automático
  - Dashboard pronto com banco SQLite vazio

---

## 4. Escolha seu método de publicação

Você pode publicar os sites de duas formas. Escolha a que se encaixa na sua hospedagem.

### Opção A — FTP / cPanel (hospedagem compartilhada)

Funciona com: HostGator, Locaweb, KingHost, Hostinger, e todo provedor que ofereça FTP + cPanel.

**Campos no dashboard:**

| Campo | O que preencher | Exemplo |
|---|---|---|
| Método | FTP | — |
| Usuário FTP / cPanel | Seu usuário de acesso | `seuusuario` |
| Domínio principal | Seu site | `meusite.com.br` |
| Servidor FTP | Endereço do servidor FTP | `ftp.meusite.com.br` |
| Pasta base | Pasta onde os sites dos clientes vão | `clientes` |
| Senha | Senha do FTP / cPanel | — |

> A URL final fica: `https://meusite.com.br/clientes/nome-do-cliente/`

### Opção B — SSH / rsync (VPS)

Funciona com qualquer VPS (DigitalOcean, Linode, AWS, etc.) ou hospedagem que libere acesso SSH. Usa `ssh` + `rsync` para enviar os arquivos.

**Campos no dashboard:**

| Campo | O que preencher | Exemplo |
|---|---|---|
| Método | SSH | — |
| Servidor SSH | IP ou hostname do seu VPS | `192.168.1.100` |
| Porta SSH | Porta de conexão (padrão 22) | `22` |
| Usuário SSH | Seu usuário no servidor | `root` ou `seuusuario` |
| Caminho remoto | Caminho ABSOLUTO da pasta pública | `/home/seuusuario/public_html` |
| Domínio principal | Seu site | `meusite.com.br` |
| Pasta base | Pasta onde os sites dos clientes vão | `clientes` |
| Senha SSH | Senha do usuário SSH | — |

> O caminho no servidor fica: `/home/seuusuario/public_html/clientes/nome-do-cliente/`

**💡 HTTPS no VPS:** Após configurar, ative o SSL com Certbot:
```bash
certbot --nginx -d meusite.com.br -d www.meusite.com.br
```

---

## 5. Publicador automático (opcional, mas recomendado)

O publicador automático faz o upload para a hospedagem sem você precisar fazer nada.

### Como instalar (uma vez na vida)

1. Na sua pasta conectada, localize o arquivo:
   - **Windows**: `instalar-publicador.bat`
   - **Mac**: `instalar-publicador.command`
2. Dê **um duplo clique**
   - No Windows: se reclamar de permissão, clique com botão direito → **Executar como administrador**
   - No Mac: se o macOS bloquear, clique com botão direito → **Abrir** (só na primeira vez)

### Como funciona

- O instalador registra uma tarefa que **verifica a fila a cada 1 minuto**
- Quando você roda `/publicar`, o Claude monta uma fila (`fila-publicacao.txt`)
- Em até 1 minuto o publicador sobe TUDO sozinho — sem janela, sem clique, sem abrir o cPanel
- O publicador **detecta automaticamente** se você configurou FTP ou SSH e usa o método correto
- O histórico fica em `publicador-log.txt`

### Plano B — publicação manual

Se não quiser instalar o automático, dê duplo clique no `publicar-agora.bat` (Windows) ou `publicar-agora.command` (Mac) sempre que o Claude preparar a fila.

---

## 6. O ciclo completo (passo a passo)

A regra de ouro do redesign: **nada é inventado**. Serviços, credenciais e fotos vêm do site real do cliente. O texto é reescrito com técnica — dizendo a mesma verdade.

### 6.1 `/prospectar` — encontrar clientes

O Claude varre o Google Maps atrás de negócios que:
- Têm **nota ≥ 4.7** (já são bem avaliados)
- Têm **site fraco** (feio, desatualizado ou inexistente)
- Têm **e-mail público** (para enviar proposta)

O resultado vai para uma planilha no Google Sheets + alimenta o dashboard.

### 6.2 `/redesenhar` — refazer a página

O plugin recria as páginas dos melhores leads (5+ por lote):
- Mantém **conteúdo, fotos e logo REAIS** do cliente
- Aplica estética profissional (tipografia, espaçamento, cores)
- Gera **editor visual** (edite no navegador depois)
- Gera **comparador antes/depois**

### 6.3 `/editor [cliente]` — ajustes finos (opcional)

Quer mexer em texto ou foto? O editor abre a página no navegador:
- Clique no texto e edite direto
- Troque imagens
- Exporte a versão final

### 6.4 `/publicar [cliente|todos]` — subir no ar

O publicador:
1. Gera a **página-capa de apresentação** (`proposta.html`) com antes/depois personalizado
2. Sobe página (`index.html`) + capa (`proposta.html`) na hospedagem
3. **Valida o HTTPS** — só considera publicado com cadeado válido

> ⚠️ Link `http://` NUNCA vai para cliente. Se der erro de SSL: cPanel → SSL/TLS Status → Run AutoSSL (ou `certbot` no VPS).

### 6.5 `/proposta [cliente|todos]` — enviar proposta

O Claude escreve o e-mail com:
- **Elogio real** baseado nas avaliações do Google
- **Defeito objetivo** apontado na prospecção
- **Único link**: a página-capa publicada (passa na checklist anti-spam)
- **Sem preço** — a proposta é de valor, não de tabela

Passa pela checklist anti-spam (1 link, sem palavras-gatilho, sem anexo, assunto-pergunta) e deixa o rascunho no Gmail para você revisar.

### 6.6 `/respostas` — quem respondeu? (automático)

O Claude lê seu Gmail e atualiza o dashboard: quem respondeu, o card move sozinho.

**💡 Dica:** peça para o Claude **agendar todo dia às 9h**:
```
cron toda manhã: /respostas
```

### 6.7 `/followup [cliente]` — lembrete gentil

3+ dias sem resposta? O Claude gera um lembrete educado (1 por lead, nunca repete).

### 6.8 `/contrato [cliente]` — fechou!

Cliente fechou? Gera:
- **Minuta do contrato** em folha A4 (pronta pra imprimir ou PDF)
- **Word TRAVADO** — o cliente só preenche os campos que você liberou
- Rascunho no Gmail com o contrato anexado

### Resumo do ciclo

| # | Comando | O que acontece | Duração |
|---|---|---|---|
| 1 | `/prospectar` | Busca leads no Google Maps | 2-5 min |
| 2 | `/redesenhar` | Recria as páginas (5+ por lote) | 3-8 min |
| 3 | `/editor [cliente]` | Ajustes manuais no navegador | opcional |
| 4 | `/publicar [cliente]` | Sobe na hospedagem + gera capa | 1-2 min |
| 5 | `/proposta [cliente]` | Cria rascunho no Gmail | 1-2 min |
| 6 | `/respostas` | Lê o Gmail e atualiza o painel | agende diário |
| 7 | `/followup [cliente]` | Lembrete gentil (3+ dias) | 30s |
| 8 | `/contrato [cliente]` | Gera contrato + Word travado | 1 min |

---

## 7. O dashboard (seu CRM local)

Abra com dois cliques no `iniciar-dashboard.bat` (Windows) ou `iniciar-dashboard.command` (Mac) — abre em `http://localhost:8765`.

> Sem Python? Abra o `dashboard.html` direto (modo leitura com edições só no navegador, sem salvar no banco).

### Abas do painel

| Aba | O que faz |
|---|---|
| **Visão geral** | Números do funil e receita |
| **Pipeline** | Kanban: arraste o card conforme o cliente avança. Ao soltar em "Fechado", informe o valor |
| **Clientes** | Tabela com busca, edição e exclusão |
| **Sites** | Preview de cada página criada, com botões de abrir/editar |
| **Comparador** | Antes/depois lado a lado de cada cliente |
| **Follow-ups** | Quem está parado há dias, com alerta laranja |
| **Contratos** | Ver a folha, imprimir, baixar o Word travado, marcar assinado |
| **Financeiro** | Recebido, a receber, MRR das manutenções e projeção 12 meses |
| **Configurações** | Seus dados de contratante + conexão de publicação (FTP ou SSH) |

---

## 8. E no Mac?

Tudo funciona igual. Só mudam os arquivos:

| Finalidade | Windows | Mac |
|---|---|---|
| Iniciar dashboard | `iniciar-dashboard.bat` | `iniciar-dashboard.command` |
| Publicação manual | `publicar-agora.bat` | `publicar-agora.command` |
| Instalar publicador | `instalar-publicador.bat` | `instalar-publicador.command` |

O `/setup` entrega os arquivos certos pro seu sistema automaticamente.

**💡 Dica:** Na primeira abertura o macOS pode bloquear por segurança. Clique com **botão direito** no arquivo → **Abrir** → Abrir (só na primeira vez).

**💡 Python no Mac:** Se não tiver: `brew install python3` ou baixe em python.org.

---

## 9. Estrutura da pasta

Na sua pasta conectada (ex.: "Clientes"):

```
pasta-conectada/
├── prospector-config.json      # Configurações + credenciais (a senha fica AQUI, no seu PC)
├── prospector.db               # Banco SQLite do CRM
├── leads.md                    # Pipeline de leads
├── dashboard.html              # Painel de controle (abre no navegador)
├── dashboard-server.py         # Servidor local do dashboard (Python)
├── iniciar-dashboard.bat/.cmd  # Iniciador do painel
├── publicar-agora.bat/.ps1     # Publicação manual
├── publicador-oculto.vbs       # Execução silenciosa (Windows)
├── instalar-publicador.bat     # Instala o publicador automático
├── fila-publicacao.txt         # Fila de arquivos para publicar
├── fila-publicada-*.txt        # Fila concluída (log)
├── publicador-log.txt          # Log da publicação automática
├── manual.html                 # Este manual
└── sites/
    └── [slug-do-cliente]/
        ├── index.html          # Página publicada do cliente
        ├── proposta.html       # Página-capa da proposta
        └── comparador.html     # Antes/depois
```

---

## 10. Problemas comuns

### "O comparador não apareceu depois do /redesenhar"
Peça no chat: "gere o comparador.html e atualize o dashboard".

### "Pede login toda hora"
Falta a senha no config. Abra o dashboard → Configurações → seção de publicação, cole a senha e salve.

### "Meu link parece estranho / domínio cheio de números"
Você está usando o subdomínio temporário da hospedagem. Ative seu domínio próprio (cPanel → Domains, ou Certbot no VPS) e atualize o campo "domínio" no dashboard.

### "Meu e-mail pode cair no spam?"
A checklist anti-spam do `/proposta` existe pra isso: 1 link só, sem palavras de vendedor, sem anexo, assunto-pergunta personalizado, envio 1 a 1 da sua conta. Mantenha poucos envios por dia — padrão humano.

### "O lado 'Antes' do comparador fica em branco"
Alguns sites antigos bloqueiam visualização embutida. Use o link **"abrir ↗"** no cabeçalho da coluna.

### "O dashboard diz 'modo arquivo'"
Você abriu o `dashboard.html` direto no navegador. Para editar e salvar no banco, use o `iniciar-dashboard.bat` (requer Python instalado com "Add to PATH").

### "Lead sem e-mail?"
O plugin descarta e busca outro — proposta vai por e-mail. Para leads com WhatsApp, peça o texto adaptado.

### "Erro de certificado HTTPS no primeiro deploy"
- **cPanel**: SSL/TLS Status → Run AutoSSL (minutos)
- **VPS**: `certbot --nginx -d meusite.com.br`

---

## 11. Atualizar o plugin

Re-adicionar o link NÃO atualiza (fica em cache). Faça:

```
/plugin marketplace update desilascarvalho-plugins
```

Depois reinicie o app. Se não subir:

1. Desinstale o plugin
2. Remova o marketplace
3. Feche o app
4. Adicione e instale de novo

> A partir da v2.1.0 a atualização é automática (autoUpdate ativado).

---

Feito por **Helio Arreche** · [YouTube](https://youtube.com/@helioarreche) · [Instagram @helioarreche](https://instagram.com/helioarreche)

Modificado por **desilascarvalho** — suporte a FTP genérico + SSH/rsync.
