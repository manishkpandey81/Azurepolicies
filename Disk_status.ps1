$Subs=Get-AzSubscription
foreach($sub in $Subs)
{
Write-Host "+++++++++++++++++++++++"
Write-Host "Subscription = "$sub.Name
write-host "+++++++++++++++++++++++"
Select-AzSubscription -Subscription $sub
#$resource_group_list = Get-AzResourceGroup

#foreach ($resource_group_list_iterator in $resource_group_list)



$Disk_list=Get-AzDisk

$Disk_list | export-csv c:\temp\deldesk.csv -Append -NoTypeInformation

}

