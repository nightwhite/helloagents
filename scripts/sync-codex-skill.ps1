$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$sourceDir = Join-Path $repoRoot "HelloAgents"
$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
$targetDir = Join-Path (Join-Path $codexHome "skills") "helloagents"

if (-not (Test-Path -LiteralPath $sourceDir -PathType Container)) {
  throw "Source skill directory not found: $sourceDir"
}

New-Item -ItemType Directory -Force -Path (Split-Path -Parent $targetDir) | Out-Null

# If a symlink/junction exists at target, remove it so we can create a real directory copy.
if (Test-Path -LiteralPath $targetDir) {
  $item = Get-Item -LiteralPath $targetDir -Force
  if ($item.LinkType) {
    Write-Host "Found link at $targetDir ($($item.LinkType)) -> $($item.Target)"
    Write-Host "Removing link to replace with real directory copy..."
    Remove-Item -LiteralPath $targetDir -Force
  }
}

New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Prefer robocopy for reliable mirror semantics on Windows.
$robocopy = Get-Command robocopy -ErrorAction SilentlyContinue
if ($robocopy) {
  $args = @(
    $sourceDir,
    $targetDir,
    "/MIR",          # mirror (includes deletions)
    "/NFL", "/NDL",  # no file/dir list
    "/NJH", "/NJS",  # no job header/summary
    "/NP",           # no progress
    "/R:1", "/W:1",  # retries
    "/XF", ".DS_Store",
    "/XD", ".git"
  )

  & robocopy @args | Out-Null
  $exit = $LASTEXITCODE
  # Robocopy uses bitmask exit codes; < 8 indicates success with possible copies.
  if ($exit -ge 8) {
    throw "Robocopy failed with exit code $exit"
  }
} else {
  Write-Warning "robocopy not found; falling back to Copy-Item (no delete sync)."
  Copy-Item -LiteralPath (Join-Path $sourceDir "*") -Destination $targetDir -Recurse -Force
}

Write-Host "Synced Codex skill:"
Write-Host "  from: $sourceDir"
Write-Host "    to: $targetDir"
