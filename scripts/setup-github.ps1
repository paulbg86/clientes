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

# Crear el repositorio en GitHub
Write-Host "🚀 Creando repositorio '$Repo' en GitHub ($visibility)..."
& "$ghPath" repo create "$Owner/$Repo" --$visibility --confirm

# Inicializar Git si no existe
if (-not (Test-Path ".git")) {
    git init
    git add .
    git commit -m "🎉 Proyecto inicial"
}

# Establecer remoto y hacer push
Write-Host "🌐 Configurando el repositorio remoto..."
git remote add origin "https://github.com/$Owner/$Repo.git"
git branch -M main
git push -u origin main

Write-Host "✅ Repositorio '$Repo' creado y sincronizado con GitHub: https://github.com/$Owner/$Repo"
