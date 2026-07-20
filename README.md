# 🎯 Prospector de Sites — v2.1.1

**Plugin para Claude (Cowork) que roda o ciclo completo de prospecção e venda de sites — com CRM local incluso.**

**Achou → Refez → Publicou → Ofertou → Acompanhou → Fechou → Contrato.**

De graça, rodando no seu computador, sem mensalidade.

---

## 📋 O que a v2 faz

| Comando | O que acontece |
|---|---|
| `/setup` | Configura tudo uma vez (pasta, assinatura, nichos, deploy) e entrega o manual + dashboard |
| `/prospectar` | Varre o Google Maps: negócios nota ≥ 4.7 com site fraco E e-mail público → planilha no Google Sheets + CRM |
| `/redesenhar` | Recria as páginas com estética premium (fotos/logo/conteúdo REAIS) + editor visual + comparador antes/depois |
| `/editor` | Edita texto e imagem da página no navegador, sem código |
| `/publicar` | Publica na hospedagem via FTP ou SSH/rsync (publicador automático) + página-capa da proposta + HTTPS validado |
| `/proposta` | E-mail com rapport real, checklist anti-spam e a capa personalizada como link |
| `/respostas` | Lê seu Gmail e move o card sozinho quando o cliente responde (agende diário!) |
| `/followup` | 3+ dias sem resposta? Gera o lembrete gentil — 1 por lead, nunca repete |
| `/contrato` | Fechou? Folha A4 imprimível + Word TRAVADO (cliente só preenche onde você deixar) |

## 📊 CRM local (dashboard)

Kanban com drag & drop, funil, clientes, sites, comparador, follow-ups, contratos e painel financeiro (recebido, a receber, MRR e projeção 12 meses) — tudo num banco SQLite **na sua pasta**. Duplo clique no `iniciar-dashboard.bat` (Windows) ou `iniciar-dashboard.command` (Mac). Requer [Python](https://www.python.org/downloads/) (marque "Add to PATH").

---

## 🚀 Instalação passo a passo

### 1. Requisitos

- **Claude Cowork** instalado
- **Extensão Claude in Chrome** conectada (para navegação no Google Maps)
- **Conectores Gmail e Google Drive** ativos no Claude
- **Uma pasta conectada** no Cowork (ex.: "Clientes") — tudo fica salvo nela
- **Python 3** instalado ([python.org](https://www.python.org/downloads/)) com "Add to PATH" marcado
- **Uma hospedagem** com um dos métodos abaixo

### 2. Escolha seu método de publicação

Você pode publicar os sites de duas formas:

#### Opção A — FTP / cPanel (qualquer hospedagem compartilhada)
Funciona com: HostGator, Locaweb, KingHost, Hostinger, e todo provedor que ofereça FTP + cPanel.

**Você precisa ter:**
- Usuário FTP / cPanel
- Senha do FTP / cPanel
- Servidor FTP (ex.: `ftp.seusite.com.br` ou `br1024.hostgator.com.br`)
- Domínio principal
- Acesso ao cPanel (para ativar SSL, se necessário)

#### Opção B — SSH / rsync (VPS ou hospedagem com acesso SSH)
Funciona com qualquer VPS (DigitalOcean, Linode, AWS, etc.) ou hospedagem que libere acesso SSH.

**Você precisa ter:**
- Host/IP do servidor SSH
- Porta SSH (geralmente 22)
- Usuário SSH
- Senha SSH (ou chave SSH — o publicador também aceita senha via sshpass)
- Caminho absoluto da pasta pública (ex.: `/home/seuusuario/public_html`)
- Domínio principal apontado para o servidor

### 3. Instalar o plugin

**No Claude Cowork:**
1. Abra o Claude Cowork
2. Vá em Plugins → Gerenciar plugins → Adicionar marketplace
3. Cole a URL deste repositório:
   ```
   https://github.com/desilascarvalho/PROSPECTOR-DE-SITES
   ```
4. Instale o **prospector-de-sites**
5. No chat, rode o comando de setup:
   ```
   /setup
   ```

**No Claude Code:**
```
/plugin marketplace add desilascarvalho/PROSPECTOR-DE-SITES
/plugin install prospector-de-sites@desilascarvalho-plugins
```

### 4. Configuração (`/setup`)

O `/setup` vai te guiar:

1. **Dados de assinatura** — nome, apresentação, WhatsApp (usado nas propostas e contratos)
2. **Nichos padrão** — sugestão: nutricionistas, psicólogos, advogados, psiquiatras
3. **Cidade/região** — onde buscar leads no Google Maps
4. **Método de publicação** — no dashboard (aba Configurações), escolha:

   **Se for FTP/cPanel:**
   - Método: FTP
   - Usuário FTP / cPanel
   - Domínio principal
   - Servidor FTP
   - Pasta base (padrão: `clientes`)
   - Senha FTP / cPanel

   **Se for SSH/rsync:**
   - Método: SSH
   - Servidor SSH (IP ou hostname)
   - Porta SSH (padrão 22)
   - Usuário SSH
   - Caminho remoto (ex.: `/home/usuario/public_html`)
   - Domínio principal
   - Pasta base (padrão: `clientes`)
   - Senha SSH

5. O plugin testa a conexão e entrega o manual + dashboard na sua pasta.

### 5. Publicador automático (opcional, mas recomendado)

O publicador automático faz o upload dos sites sem você precisar fazer nada:

1. Na sua pasta conectada, dê **um duplo clique** no `instalar-publicador.bat` (Windows) ou `instalar-publicador.command` (Mac)
2. Pronto: de agora em diante o `/publicar` monta a fila e o publicador sobe os sites sozinho em até 1 minuto
3. O publicador detecta automaticamente se você configurou FTP ou SSH e usa o método correto

> ⚠️ No Windows, se der erro de permissão: clique com botão direito → **Executar como administrador**

### 6. Dashboard (CRM)

Na sua pasta conectada, duplo clique em `iniciar-dashboard.bat` (Windows) ou `iniciar-dashboard.command` (Mac). Abre em `http://localhost:8765`:

- Pipeline kanban com drag & drop
- Clientess com busca e edição
- Comparador antes/depois
- Follow-ups automáticos
- Contratos (pendente / enviado / assinado)
- Financeiro (recebido, a receber, MRR, projeção 12 meses)
- Configurações (assinatura + conexão de deploy)

---

## 🔄 Ciclo completo

| Passo | Comando | Duração |
|---|---|---|
| 1 | `/prospectar` | 2-5 min |
| 2 | `/redesenhar` | 3-8 min |
| 3 | `/publicar [cliente]` | 1-2 min |
| 4 | `/proposta [cliente]` | 1-2 min |
| 5 | `/respostas` (agende diário) | automático |
| 6 | `/followup [cliente]` | 30s |
| 7 | `/contrato [cliente]` | 1 min |

---

## 🔄 Já tem o plugin e não atualiza?

Re-adicionar o link NÃO atualiza (fica em cache). Faça:
```
/plugin marketplace update desilascarvalho-plugins
```
e reinicie o app. Se não subir: desinstale o plugin → remova o marketplace → feche o app → adicione e instale de novo.

---

## 📁 Estrutura da pasta

```
pasta-conectada/
├── prospector-config.json     # Configurações e credenciais (senha local)
├── prospector.db              # Banco SQLite do CRM
├── leads.md                   # Pipeline de leads
├── dashboard.html             # Painel de controle
├── dashboard-server.py        # Servidor local do dashboard
├── iniciar-dashboard.bat      # Iniciador do dashboard (Windows)
├── publicar-agora.bat         # Publicação manual (Windows)
├── publicar-agora.ps1         # Script de publicação PowerShell
├── publicador-oculto.vbs      # Execução silenciosa do publicador
├── instalar-publicador.bat    # Instala o publicador automático
├── fila-publicacao.txt        # Fila de arquivos para publicar
├── publicador-log.txt         # Log do publicador
├── manual.html                # Manual completo do usuário
└── sites/
    └── [slug-do-cliente]/
        ├── index.html         # Página publicada
        ├── proposta.html      # Página-capa da proposta
        └── comparador.html    # Antes/depois
```

---

Feito por **Helio Arreche** · [YouTube](https://youtube.com/@helioarreche) · [Instagram @helioarreche](https://instagram.com/helioarreche)

Modificado por **desilascarvalho** — suporte a FTP genérico + SSH/rsync.
