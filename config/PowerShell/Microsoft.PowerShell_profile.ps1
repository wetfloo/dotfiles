$env:EDITOR = 'nvim'

Invoke-Expression (& { (zoxide init powershell | Out-String) })