# Prospector de Sites — v2.1.1

Prospecção semi-automática de clientes com sites ruins: acha, redesenha, publica e oferta.

Suporta publicação via **FTP/cPanel** (qualquer hospedagem compartilhada) ou **SSH/rsync** (VPS).

---

## 📥 Instalação

### Pré-requisitos

- Claude Cowork com extensão Claude in Chrome
- Conectores Gmail e Google Drive ativos
- Python 3 instalado ([python.org](https://www.python.org/downloads/)) com "Add to PATH"
- Uma pasta conectada no Cowork (ex.: "Clientes")
- Uma hospedagem com FTP/cPanel **ou** acesso SSH

### Instalar o plugin

1. **Adicione o marketplace** no Claude Cowork:
   - Plugins → Gerenciar plugins → Adicionar marketplace
   - Cole: `https://github.com/desilascarvalho/PROSPECTOR-DE-SITES`
2. **Instale** o plugin `prospector-de-sites`
3. **Rode** no chat:
   ```
   /setup
   ```

## ⚙️ Configuração de deploy

O `/setup` copia o publicador e o dashboard pra sua pasta. As credenciais de publicação você preenche no próprio dashboard (aba Configurações) — nunca pelo chat.

### FTP / cPanel (padrão)

| Campo | Exemplo |
|---|---|
| Método | FTP |
| Usuário FTP / cPanel | `seuusuario` |
| Domínio principal | `meusite.com.br` |
| Servidor FTP | `ftp.meusite.com.br` |
| Pasta base | `clientes` |
| Senha FTP / cPanel | (sua senha) |

### SSH / rsync

| Campo | Exemplo |
|---|---|
| Método | SSH |
| Servidor SSH | `192.168.1.100` ou `meuvps.com` |
| Porta SSH | `22` |
| Usuário SSH | `root` ou `seuusuario` |
| Caminho remoto | `/home/seuusuario/public_html` |
| Domínio principal | `meusite.com.br` |
| Pasta base | `clientes` |
| Senha SSH | (sua senha) |

> 💡 Se for VPS, ative o HTTPS com Certbot: `certbot --nginx -d meusite.com.br`

## 🚀 O ciclo completo

1. **`/setup`** — uma vez: assinatura, nichos, deploy e teste de conexão
2. **`/prospectar [nicho] [cidade]`** — busca no Google Maps negócios nota ≥ 4.7 com site fraco
3. **`/redesenhar`** — recria as páginas dos melhores leads com estética premium
4. **`/editor [cliente]`** — ajuste fino no navegador (textos e imagens)
5. **`/publicar [cliente|todos]`** — sobe na hospedagem via FTP ou SSH/rsync + gera capa de proposta
6. **`/proposta [cliente|todos]`** — cria o e-mail com página-capa como único link
7. **`/respostas`** — lê o Gmail e atualiza o dashboard (agende diário)
8. **`/followup [cliente]`** — lembrete gentil para leads sem resposta há 3+ dias
9. **`/contrato [cliente]`** — cliente fechou? Gera contrato + Word travado

## 📊 Dashboard local

Duplo clique em `iniciar-dashboard.bat` (Windows) ou `.command` (Mac). Abre em http://localhost:8765:

- Kanban com drag & drop · funil · clientes · comparador antes/depois
- Follow-ups · contratos (pendente/enviado/assinado)
- Financeiro: recebido, a receber, MRR, projeção 12 meses
- Configurações: assinatura + conexão de deploy (FTP ou SSH)

## 📁 Dados

Tudo na pasta conectada:
- `prospector-config.json` — preferências e credenciais (senha em texto no seu computador, nunca no chat)
- `prospector.db` — banco SQLite do CRM
- `leads.md` — pipeline de leads
- `sites/[slug]/` — páginas criadas
- `publicador-log.txt` — log da publicação automática

## 🔄 Atualizar

No chat: `/plugin marketplace update desilascarvalho-plugins` e reinicie o app.
