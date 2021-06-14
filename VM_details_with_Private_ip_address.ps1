<#
 File name: VM_details_with_Private_ip_address.ps1
 Owner:   Vijay Gupta
 Tester:   Vijay Gupta
 Reviewer:
 Env: Azure test Account
 Description: This Script will extract VM details. 
Usage1:.\VM_details_with_Private_ip_address.ps1
 
 Algorithm:
 -----------
assigning Vm detail to variable
1- User Need to Define path of excel file where script will save the file.
 $workbook.SaveAs("c:\temp\xxxx.xlsx" ) ==> this is sample line where user need to change path.
 note :- User should have access on given folder .
#>
$report =$null
$report = @()
$subs = Get-AzSubscription
foreach ($sub in $subs){
    Select-AzSubscription -Subscription $sub.SubscriptionId
    Write-Host "========================================================================================================="
    Write-Host "Working on Subscription Name :-" $sub.Name
    Write-Host "Working on Subscription Id :-" $sub.SubscriptionId
    Write-Host "========================================================================================================="
$vms = Get-AzVM -Status
$nics = Get-AzNetworkInterface | ?{ $_.VirtualMachine -NE $null}
 
foreach($nic in $nics)
{
    $info = "" | Select VmName, ResourceGroupName, HostName, IpAddress, Status, OS_Type, Location, OS, Version, OS_Disk_Size, CPU_Cores, RAM, Compute_Name, Subscription_Name
    $vm = $vms | ? -Property Id -eq $nic.VirtualMachine.id
    $info.VMName = $vm.Name
    $info.ResourceGroupName = $vm.ResourceGroupName
    $info.IpAddress = $nic.IpConfigurations.PrivateIpAddress
    $info.HostName = $vm.OSProfile.ComputerName
    $info.Status = $vm.StatusCode.value__
    $info.OS_Type = $vm.StorageProfile.OsDisk
    $info.Location = $vm.Location
    $info.OS = $vm.StorageProfile.ImageReference.Offer
    $info.Version = $vm.StorageProfile.ImageReference.sku
    $size = (Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name ).HardwareProfile.VmSize
    $data = Get-AzVMSize -Location $vm.Location | ?{ $_.name -eq $size }
    $info.OS_Disk_Size = $data.OSDiskSizeInMB
    $info.Compute_Name = $data.Name
    $memory=$data.MemoryInMB/1024
    $info.CPU_Cores = $data.NumberOfCores
    $info.RAM = $memory
    $info.Subscription_Name = $sub.Name
    $report+=$info
}
    }
$report | Export-Csv -Path "C:\temp\VM_Details.csv" -NoTypeInformation -Force