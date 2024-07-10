# Nombre del nuevo conmutador virtual
$switchName = "Public Switch"

# Obtener el adaptador de red físico para el conmutador externo
$netAdapter = Get-NetAdapter -Name "Ethernet" 

# Crear el nuevo conmutador virtual de tipo externo
New-VMSwitch -Name $switchName -NetAdapterName $netAdapter.Name -AllowManagementOS $true