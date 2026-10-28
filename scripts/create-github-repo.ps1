param(
    [string]$RepoName = 'sbwc-platform',
    [string]$Visibility = 'public'
)

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw 'GitHub CLI (gh) não está instalado. Instale-o e faça login com: gh auth login'
}

gh auth status

gh repo create $RepoName --$Visibility --source=. --remote=origin --push
