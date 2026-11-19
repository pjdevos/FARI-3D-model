# Builds a single, self-contained HTML file of the model: every photo and 3D model referenced as 'assets/...' is written into the
# file as a data URI. Opened from disk (file://), browsers refuse to put separate image files on WebGL screens, so the
# photos stay black there; embedded they work. three.js and the fonts still come from the internet.
param([string]$Out = "")
$root = Split-Path -Parent $PSScriptRoot
if ($Out -eq "") { $Out = Join-Path $root ("FARI Experience Hub - " + (Get-Date -Format 'yyyy-MM-dd') + ".html") }
$utf8 = New-Object System.Text.UTF8Encoding($false)
$html = [IO.File]::ReadAllText((Join-Path $root 'index.html'), $utf8)
$types = @{ '.jpg' = 'image/jpeg'; '.jpeg' = 'image/jpeg'; '.png' = 'image/png'; '.webp' = 'image/webp'; '.gif' = 'image/gif'; '.glb' = 'model/gltf-binary' }
$count = 0
$html = [regex]::Replace($html, "'(assets/[^'""]+?\.(jpe?g|png|webp|gif|glb))'", {
  param($m)
  $file = Join-Path $root ($m.Groups[1].Value -replace '/', '\')
  if (-not (Test-Path $file -PathType Leaf)) { Write-Host "not found, left as is: $($m.Groups[1].Value)"; return $m.Value }
  $script:count++
  $mime = $types[[IO.Path]::GetExtension($file).ToLower()]
  return "'data:$mime;base64," + [Convert]::ToBase64String([IO.File]::ReadAllBytes($file)) + "'"
}, 'IgnoreCase')
[IO.File]::WriteAllText($Out, $html, $utf8)
Write-Host ("{0} photo(s) embedded -> {1} ({2:N0} KB)" -f $count, $Out, ((Get-Item $Out).Length / 1KB))
