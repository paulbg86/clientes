param (
    [Parameter(Mandatory=$true)]
    [string]$Owner,

    [Parameter(Mandatory=$true)]
    [string]$Repo,

    [switch]$Private
)

# Ruta fija al ejecutable de GitHub CLI
$ghPath = "C:\Program Files\GitHub CLI\gh.exe"

# Verifica si gh.exe existe en la ruta
if (-not (Test-Path $ghPath)) {
    Write-Error "❌ No se encontró gh.exe en la ruta esperada: $ghPath. Asegúrate de que la CLI de GitHub esté instalada."
    exit 1
}

# Verifica autenticación
Write-Host " Verificando autenticación con GitHub CLI..."
& "$ghPath" auth status 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host " Autenticando con GitHub..."
    & "$ghPath" auth login
}

# Define si es privado
$visibility = "public"
if ($Private) {
    $visibility = "private"
}

# Crear el repositorio en GitHub (si no existe)
Write-Host "🚀 Verificando/creando repositorio '$Repo' en GitHub ($visibility)..."
& "$ghPath" repo view "$Owner/$Repo" 2>$null
if ($LASTEXITCODE -ne 0) {
    & "$ghPath" repo create "$Owner/$Repo" --$visibility --confirm
}
Write-Host "ℹ️  Repositorio en GitHub listo: https://github.com/$Owner/$Repo"

# Inicializar Git si no existe y asegurar commit inicial si el repo está vacío
if (-not (Test-Path ".git")) {
    git init
}

# Si no hay commits (HEAD inválido), crear commit inicial con el estado actual
git rev-parse --verify HEAD 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
    git add -A
    git commit -m "🎉 Proyecto inicial"
}

# Establecer remoto y hacer push
Write-Host "🌐 Configurando el repositorio remoto..."
git remote get-url origin 2>$null
$hasOrigin = ($LASTEXITCODE -eq 0)
if (-not $hasOrigin) {
    git remote add origin "https://github.com/$Owner/$Repo.git"
}
if ($hasOrigin) {
    git remote set-url origin "https://github.com/$Owner/$Repo.git"
}

# Sincronizar con el remoto
git fetch origin --prune

# ¿Existe 'main' en el remoto?
$remoteMainExists = $false
git ls-remote --exit-code --heads origin main *> $null
if ($LASTEXITCODE -eq 0) { $remoteMainExists = $true }

# Asegurar estar en 'main'
git checkout -B main

if ($remoteMainExists) {
    Write-Host "⬇️  Actualizando 'main' desde origin/main (rebase)..."
    git pull --rebase origin main
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Conflictos al actualizar 'main'. Resuélvelos y vuelve a ejecutar el script."
        exit 1
    }
}

Write-Host "⬆️  Publicando 'main' al remoto..."
git push -u origin main

# Crear y mapear rama 'dev' (local y remoto)
Write-Host "🪄 Configurando rama 'dev' (local y remoto)..."

# ¿Existe 'dev' local?
$localDevExists = $false
git show-ref --verify --quiet "refs/heads/dev"
if ($LASTEXITCODE -eq 0) { $localDevExists = $true }

# ¿Existe 'dev' en el remoto?
$remoteDevExists = $false
git ls-remote --exit-code --heads origin dev *> $null
if ($LASTEXITCODE -eq 0) { $remoteDevExists = $true }

if (-not $localDevExists -and $remoteDevExists) {
    Write-Host "↩️  Creando rama local 'dev' rastreando origin/dev..."
    git checkout -b dev origin/dev
} elseif (-not $localDevExists -and -not $remoteDevExists) {
    Write-Host "🆕 Creando rama local 'dev' y publicándola..."
    git checkout -b dev
    git push -u origin dev
} elseif ($localDevExists -and -not $remoteDevExists) {
    Write-Host "☁️  Publicando rama local 'dev' al remoto..."
    git checkout dev
    git push -u origin dev
} else {
    Write-Host "✅ 'dev' existe en local y remoto. Asegurando mapeo upstream y sincronizando..."
    git checkout dev
    $upstream = (git for-each-ref --format='%(upstream:short)' refs/heads/dev).Trim()
    if (-not $upstream) {
        git branch --set-upstream-to=origin/dev dev
    }
    git pull --rebase origin dev
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Conflictos al actualizar 'dev'. Resuélvelos y vuelve a ejecutar el script."
        exit 1
    }
}

Write-Host "✅ Rama 'dev' lista y mapeada con origin/dev"

Write-Host "✅ Repositorio '$Repo' creado y sincronizado con GitHub: https://github.com/$Owner/$Repo"
