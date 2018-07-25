# Procura se o processo do dropbox ou do google drive está em execução
# na sessão do usuário especificado, caso positivo retorna 0. Se não 
# estiver rodando, chama o processo na sessão do usuário e retorna 1.
# Caso o nome do processo não esteja nos padrões, retorna 2.
# 
# Author: Juliano Romani
# Versão: 0.8
# Data: 2018-07-25

param(
  [Parameter(Mandatory=$True,Position=0)]
  [string]$user,
  [Parameter(Mandatory=$True,Position=1)]
  [string]$senha,
  [Parameter(Mandatory=$True,Position=2)]
  [string]$processo
)

if ($processo -eq "dropbox"){
  $processo = "Dropbox"
}
elseif ($processo -eq "gdrive"){
  $processo = "googledrivesync"
 }
else {
  '2'
}

$existe = (Get-Process -IncludeUserName | Where-Object {$_.ProcessName -match $processo -and $_.UserName -match $user}).Id
if ($existe ){
  '0'
}
else {
  $session = (Get-Process -IncludeUserName | Select-Object UserName,SessionId -Unique | Where-Object { $_.UserName -Match $user }).SessionId
  if ($processo -eq "Dropbox"){
    & C:\smo\PsExec.exe -i $session -u $user -p $senha -d -accepteula -nobanner 'C:\Program Files (x86)\Dropbox\Client\Dropbox.exe' 2>&1 > $null
    '1'
  }
  elseif ($processo -eq "googledrivesync"){
    & C:\smo\PsExec.exe -i $session -u $user -p $senha -d -accepteula -nobanner 'C:\Program Files\Google\Drive\googledrivesync.exe' 2>&1 > $null
    '1'
  }
  else {
    '2'
  }
}