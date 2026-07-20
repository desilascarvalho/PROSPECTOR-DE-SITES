# Prospector de Sites — publicação automática via FTP ou rsync/SSH
# Manual: duplo clique no publicar-agora.bat (mostra janela)
# Automático: instalado pelo instalar-publicador.bat, roda a cada minuto escondido (-Auto)
param([switch]$Auto)
$ErrorActionPreference = "Stop"
$pasta = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $pasta
function Fim($code){ if(-not $Auto){ pause }; exit $code }
function Log($msg,$cor="Gray"){
  if($Auto){ Add-Content "publicador-log.txt" ("[" + (Get-Date -Format "dd/MM HH:mm:ss") + "] " + $msg) }
  else { Write-Host $msg -ForegroundColor $cor }
}
if (-not (Test-Path "fila-publicacao.txt")) { if(-not $Auto){ Log "Nada na fila - peca /publicar ao Claude primeiro." "Yellow" }; Fim 0 }
try { $cfg = Get-Content "prospector-config.json" -Raw -Encoding UTF8 | ConvertFrom-Json } catch { Log "ERRO: prospector-config.json nao encontrado/invalido." "Red"; Fim 1 }
# Tenta 'deploy' primeiro, depois 'hostgator' (compatibilidade)
$hgCfg = if ($cfg.deploy) { $cfg.deploy } else { $cfg.hostgator }
$method = if ($hgCfg.metodo) { $hgCfg.metodo } else { "ftp" }
if ($method -eq "ssh") {
  $sshHost = $hgCfg.sshHost; $sshPort = if ($hgCfg.sshPort) { $hgCfg.sshPort } else { 22 }
  $sshUser = $hgCfg.sshUser; $sshPass = $hgCfg.sshPass; $remotePath = $hgCfg.remotePath
  if (-not $sshHost -or -not $sshUser) { Log "ERRO: preencha a conexao SSH (dashboard > Configuracoes)." "Red"; Fim 1 }
} else {
  $u = $hgCfg.usuario; $p = $hgCfg.senha; $srv = $hgCfg.servidor
  if (-not $u -or -not $p -or -not $srv) { Log "ERRO: preencha a conexao FTP (dashboard > Configuracoes) incluindo a senha." "Red"; Fim 1 }
}
$fila = Get-Content "fila-publicacao.txt" -Encoding UTF8 | Where-Object { $_ -match "\|" }
$ok = 0; $falha = 0
foreach ($linha in $fila) {
  $par = $linha -split "\|", 2
  $local = $par[0].Trim(); $remoto = $par[1].Trim()
  if (-not (Test-Path $local)) { Log ("PULOU (nao existe): " + $local) "Yellow"; $falha++; continue }
  Log ("Subindo " + $local + " -> " + $remoto + " ...")
  if ($method -eq "ssh") {
    $dirRemoto = [System.IO.Path]::GetDirectoryName($remoto).Replace("\","/")
    $remotoFull = $remotePath.TrimEnd('/') + "/" + $remoto
    $dirFull = [System.IO.Path]::GetDirectoryName($remotoFull).Replace("\","/")
    if ($sshPass) {
      # Usar sshpass se senha estiver configurada
      & sshpass -p "$sshPass" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $sshPort "${sshUser}@${sshHost}" "mkdir -p '$dirFull'" 2>&1 | Out-Null
      & sshpass -p "$sshPass" rsync -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $sshPort" "$local" "${sshUser}@${sshHost}:$remotoFull" 2>&1 | Out-Null
    } else {
      & ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $sshPort "${sshUser}@${sshHost}" "mkdir -p '$dirFull'" 2>&1 | Out-Null
      & rsync -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $sshPort" "$local" "${sshUser}@${sshHost}:$remotoFull" 2>&1 | Out-Null
    }
    if ($LASTEXITCODE -eq 0) { Log "  OK" "Green"; $ok++ } else { Log ("  FALHOU (codigo " + $LASTEXITCODE + ")"); $falha++ }
  } else {
    & curl.exe -sS --connect-timeout 20 -T "$local" "ftp://$srv/$remoto" --user "${u}:${p}" --ftp-create-dirs
    if ($LASTEXITCODE -eq 0) { Log "  OK" "Green"; $ok++ } else { Log ("  FALHOU (codigo " + $LASTEXITCODE + ")") "Red"; $falha++ }
  }
}
Log ("Concluido: " + $ok + " enviados, " + $falha + " falhas.") "Cyan"
if ($falha -eq 0 -and $ok -gt 0) {
  Rename-Item "fila-publicacao.txt" ("fila-publicada-" + (Get-Date -Format "yyyyMMdd-HHmm") + ".txt") -Force
  Log "Fila concluida. Avise o Claude ('publiquei') para verificar as URLs." "Cyan"
}
Fim 0
