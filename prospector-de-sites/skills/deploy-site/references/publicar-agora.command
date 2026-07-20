#!/bin/bash
# Prospector de Sites — publica a fila via FTP ou rsync/SSH (Mac).
# Manual: duplo clique. Automatico (launchd): chamado com --auto (log em publicador-log.txt, sem pause).
cd "$(dirname "$0")"
AUTO=0; [ "$1" = "--auto" ] && AUTO=1
log(){ if [ $AUTO -eq 1 ]; then echo "[$(date '+%d/%m %H:%M:%S')] $1" >> publicador-log.txt; else echo "$1"; fi; }
fim(){ [ $AUTO -eq 0 ] && read -p "Pressione Enter para fechar..."; exit $1; }
[ -f fila-publicacao.txt ] || { [ $AUTO -eq 0 ] && log "Nada na fila — peca /publicar ao Claude primeiro."; fim 0; }
CFG=prospector-config.json
[ -f $CFG ] || { log "ERRO: prospector-config.json nao encontrado."; fim 1; }

# Ler config (deploy ou hostgator para compatibilidade)
eval "$(python3 -c "
import json
cfg = json.load(open('$CFG'))
d = cfg.get('deploy') or cfg.get('hostgator') or {}
metodo = d.get('metodo', 'ftp')
print(f'METODO={metodo}')
if metodo == 'ssh':
    print(f'SSHHOST={d.get(\"sshHost\",\"\")}')
    print(f'SSHPORT={d.get(\"sshPort\",22)}')
    print(f'SSHUSER={d.get(\"sshUser\",\"\")}')
    print(f'SSHPASS={d.get(\"sshPass\",\"\")}')
    print(f'REMOTEPATH={d.get(\"remotePath\",\"\")}')
else:
    print(f'U={d.get(\"usuario\",\"\")}')
    print(f'P={d.get(\"senha\",\"\")}')
    print(f'SRV={d.get(\"servidor\",\"\")}')
")"

if [ "$METODO" = "ssh" ]; then
  [ -n "$SSHHOST" ] && [ -n "$SSHUSER" ] || { log "ERRO: preencha a conexao SSH no dashboard (Configuracoes)."; fim 1; }
else
  [ -n "$U" ] && [ -n "$P" ] && [ -n "$SRV" ] || { log "ERRO: preencha a conexao FTP no dashboard (Configuracoes), incluindo a senha."; fim 1; }
fi

OK=0; FALHA=0
while IFS='|' read -r LOCAL REMOTO; do
  LOCAL=$(echo "$LOCAL" | xargs); REMOTO=$(echo "$REMOTO" | xargs)
  [ -z "$LOCAL" ] && continue
  if [ ! -f "$LOCAL" ]; then log "PULOU (nao existe): $LOCAL"; FALHA=$((FALHA+1)); continue; fi
  log "Subindo $LOCAL -> $REMOTO ..."

  if [ "$METODO" = "ssh" ]; then
    DIRREMOTO=$(dirname "$REMOTO")
    REMOTOFULL="${REMOTEPATH%/}/$REMOTO"
    DIRFULL=$(dirname "$REMOTOFULL")
    if [ -n "$SSHPASS" ]; then
      sshpass -p "$SSHPASS" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p "$SSHPORT" "${SSHUSER}@${SSHHOST}" "mkdir -p '$DIRFULL'" 2>/dev/null
      sshpass -p "$SSHPASS" rsync -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $SSHPORT" "$LOCAL" "${SSHUSER}@${SSHHOST}:$REMOTOFULL" 2>/dev/null
    else
      ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p "$SSHPORT" "${SSHUSER}@${SSHHOST}" "mkdir -p '$DIRFULL'" 2>/dev/null
      rsync -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $SSHPORT" "$LOCAL" "${SSHUSER}@${SSHHOST}:$REMOTOFULL" 2>/dev/null
    fi
    if [ $? -eq 0 ]; then log "  OK"; OK=$((OK+1)); else log "  FALHOU"; FALHA=$((FALHA+1)); fi
  else
    if curl -sS --connect-timeout 20 -T "$LOCAL" "ftp://$SRV/$REMOTO" --user "$U:$P" --ftp-create-dirs; then
      log "  OK"; OK=$((OK+1))
    else
      log "  FALHOU"; FALHA=$((FALHA+1))
    fi
  fi
done < fila-publicacao.txt
log "Concluido: $OK enviados, $FALHA falhas."
if [ $FALHA -eq 0 ] && [ $OK -gt 0 ]; then
  mv fila-publicacao.txt "fila-publicada-$(date '+%Y%m%d-%H%M').txt"
  log "Fila concluida. Avise o Claude ('publiquei') para verificar as URLs."
fi
fim 0
