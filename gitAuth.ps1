# gitAuth.ps1

$sshDir = "$HOME\.ssh"

# Create the .ssh directory if it doesn't exist
if (-Not (Test-Path -Path $sshDir)) {
    New-Item -ItemType Directory -Path $sshDir | Out-Null
} elseif (-Not (Get-Item $sshDir).PSIsContainer) {
    Write-Host "$sshDir exists but is not a directory"
    exit
}

Set-Location $sshDir

# Get GitHub username and email
$username = Read-Host "GitHub account username"
$email = Read-Host "GitHub account email"

# Set Git global config
git config --global user.name "$username"
git config --global user.email "$email"

# Generate SSH key
$sshKeyFile = "id_github"
ssh-keygen -t rsa -b 4096 -C "$email" -f $sshKeyFile -q -N ""

# Create SSH config
@"
Host github.com
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/id_github
"@ | Out-File -Encoding ASCII "$sshDir\config"

# Secure the config file
icacls "$sshDir\config" /inheritance:r /grant:r "$($env:USERNAME):R"

# Start ssh-agent and add key
Start-Service ssh-agent -ErrorAction SilentlyContinue
Get-Service ssh-agent | Set-Service -StartupType Manual
ssh-add "$sshDir\$sshKeyFile"

# Add GitHub to known hosts
ssh-keyscan -t rsa github.com | Out-File -Encoding ASCII "$sshDir\known_hosts"

# Show the key and prompt user to add it to GitHub
Clear-Host
Write-Host "`nCopy this key to https://github.com/settings/keys -> New SSH Key:`n"
Get-Content "$sshDir\$sshKeyFile.pub"
Write-Host "`nPress Enter when finished to test the connection..."
Read-Host

# Test the connection
ssh -T git@github.com
