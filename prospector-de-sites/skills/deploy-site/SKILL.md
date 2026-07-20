---
name: deploy-site
description: Esta skill deve ser usada ao publicar páginas em qualquer hospedagem com suporte a FTP, cPanel ou SSH — upload via script local automático (ftp ou rsync), FTP direto ou cPanel File Manager, criação de pastas por cliente, verificação da URL pública e HTTPS. Acione quando o usuário disser "publicar", "subir o site", "colocar no ar", "deploy", "ftp", "ssh", "rsync" ou rodar /publicar ou o teste de conexão do /setup.
---

# Deploy via FTP / cPanel / SSH (qualquer hospedagem)

Publicar páginas em `public_html/[pastaBase]/[slug]/` e garantir a URL pública `https://[dominio]/[pastaBase]/[slug]/` funcionando.

Não depende de provedor específico — funciona com qualquer hospedagem que ofereça FTP, cPanel ou acesso SSH (HostGator, Locaweb, KingHost, Hostinger, VPS, etc.).

## Credenciais

Tudo vem de `prospector-config.json` (bloco `deploy` ou `hostgator` para compatibilidade). A configuração varia conforme o método escolhido no dashboard:

### Método FTP (padrão)
Campos: `metodo: "ftp"`, `usuario`, `dominio`, `servidor`, `senha`, `pastaBase` (padrão `clientes`).

### Método SSH/rsync
Campos: `metodo: "ssh"`, `sshHost`, `sshPort` (padrão 22), `sshUser`, `sshPass`, `sshKey`, `remotePath` (ex.: `/home/usuario/public_html/clientes`), `dominio`, `pastaBase`.

**A senha vive SÓ nesse arquivo, no computador do usuário — nunca é digitada no chat, nunca é exibida em nenhuma saída, log ou comando mostrado ao usuário.** Se estiver vazia, oriente o usuário: dashboard → aba Configurações → Conexão FTP ou SSH → colar a senha e salvar (ou editar o arquivo na mão). Nunca pelo chat.

## Método 1 — Publicador automático local (RECOMENDADO: instala uma vez, nunca mais clica)

A rede do sandbox do Cowork NÃO alcança FTP nem SSH — isso vale para todo usuário. A publicação roda na máquina do usuário via um publicador instalado no agendador do Windows: a cada minuto ele verifica a fila e sobe o que houver, escondido, lendo as credenciais do config. O usuário instala UMA vez e o /publicar vira 100% automático.

1. **Garanta os arquivos do publicador na pasta conectada** (copie de `references/` desta skill, sobrescrevendo versões antigas), conforme o sistema do usuário — pergunte ou detecte:
   - **Windows**: `publicar-agora.ps1`, `publicar-agora.bat`, `publicador-oculto.vbs`, `instalar-publicador.bat`.
   - **Mac**: `publicar-agora.command` e `instalar-publicador.command` (o instalador registra o publicador no launchd, a cada 60s; desinstalar = `launchctl unload` do plist com.prospector.publicador).
   Em dúvida, copie todos — cada sistema ignora os do outro.
2. **Primeira vez**: peça UM duplo clique no `instalar-publicador.bat` (Windows — cria a tarefa "ProspectorPublicador"; erro de permissão = botão direito → Executar como administrador) ou no `instalar-publicador.command` (Mac — se o macOS bloquear por segurança: botão direito → Abrir na primeira vez). Só uma vez na vida.
3. **Monte a fila**: escreva `fila-publicacao.txt` na raiz da pasta conectada, uma linha por arquivo: `caminho/local/arquivo.html|public_html/[pastaBase]/[slug]/index.html`. Inclua página (`index.html`) e capa (`proposta.html`) de cada cliente. Em até 1 minuto o publicador sobe tudo sozinho e renomeia a fila para `fila-publicada-[data].txt` (o log fica em `publicador-log.txt`). O publicador detecta automaticamente o método configurado (FTP ou SSH) e usa o comando apropriado.
4. **Aguarde ~90s e verifique**: confira se a fila foi renomeada e teste as URLs (verificação abaixo). Sem tarefa instalada, o fallback manual é o duplo clique no `publicar-agora.bat` (Windows) ou `publicar-agora.command` (Mac).

## Método 2 — FTP direto do sandbox (tentar primeiro, silencioso)

Antes de acionar o usuário, tente publicar você mesmo via FTP: `curl -sS --connect-timeout 15 -T [arquivo] "ftp://[servidor]/public_html/[pastaBase]/[slug]/index.html" --user "[usuario]:[senha do config]" --ftp-create-dirs` (senha lida do arquivo via script — jamais mostrada). Se funcionar, ótimo: zero ação do usuário. Se a rede do sandbox bloquear (timeout/refused), caia SEM DRAMA para o Método 1 — não insista em tentativas repetidas.

## Método 3 — SSH direto do sandbox (alternativa)

Se o usuário configurou SSH, tente você mesmo: crie o diretório remoto e faça upload com rsync ou scp:
```bash
ssh -p [porta] [sshUser]@[sshHost] "mkdir -p [remotePath]/[pastaBase]/[slug]"
scp -P [porta] [arquivo] [sshUser]@[sshHost]:[remotePath]/[pastaBase]/[slug]/index.html
```
Senha lida do config (via script) — jamais mostrada. Se a rede bloquear, caia para o Método 1.

## Método 4 — cPanel File Manager (último recurso)

Se os métodos anteriores falharem: cPanel File Manager pelo Claude in Chrome — o USUÁRIO faz o login dele (nunca peça a senha no chat), você navega, cria as pastas e faz upload pela interface.

## Verificação (obrigatória, após qualquer método)

1. Abra `https://[dominio]/[pastaBase]/[slug]/` e a capa `.../proposta.html` — confirme que carregam com conteúdo certo.
2. **HTTPS obrigatório**: precisa carregar com cadeado válido. Se der erro de certificado: acesse o cPanel da hospedagem → **SSL/TLS Status** → marcar o domínio → **Run AutoSSL** (minutos). Para VPS sem cPanel, use Certbot/Let's Encrypt: `certbot --nginx -d [dominio]`. Enquanto o HTTPS não valida, a publicação NÃO está concluída — link `http://` NUNCA vai para cliente.
3. Atualize `leads.md` + dashboard com status `publicado` e a URL.

## Teste de conexão do /setup

Publique `teste.html` simples ("Funcionou!") em `public_html/[pastaBase]/teste/index.html` pelo Método 2 ou 3; se bloqueado, já deixe os scripts do Método 1 copiados na pasta, monte a fila com o teste e peça os 2 cliques — assim o usuário aprende o fluxo logo no setup.
