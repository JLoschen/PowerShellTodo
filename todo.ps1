function get-jltodoNames {
    [CmdletBinding()]
    param([string] $myParam)

    $toDoFiles = @()
    
    Get-ChildItem -Path "C:\Users\Josh\Documents\Menards\2022\Powershell\To Do tracker" -Filter *.todo -Recurse <#-File -Name#>| ForEach-Object {
    #Get-ChildItem -Path "C:\Users\jloschen\Documents\Projects\2022\Powershell Scripts\To Do tracker\" -Filter *.todo -Recurse <#-File -Name#>| ForEach-Object {
    #Get-ChildItem -Path "C:\Users\jloschen\Documents\Projects\" -Filter *.todo -Recurse -File -Name| ForEach-Object {
        #Write-Output $([System.IO.Path]::GetFileNameWithoutExtension($_))
        $toDoFiles += $_.FullName
    }

    foreach($file in $toDoFiles){
        #$content = Get-Content $file
        #Write-Host $content
        $test = get-jltodo $file

        foreach($todoItem in $test){
            Write-Output $todoItem
        }
        #Write-Host $file
    }
}
#get-jltodoNames
#get-jltodo "Josh test"

#get the TODO items
function get-jltodo{
    [CmdletBinding()]
    param([string] $fileName)

    Write-Output "getting file $fileName"

    $content = Get-Content $fileName 
    
    $todoItems = @()
    if($content -eq $null){
        Write-Host "Probwem"
        return $todoItems
    }

    $doneIndex = $content.IndexOf("---Done---");

    for($index = 0;$index -lt $doneIndex; $index++)
    {
        $line = $content[$index]

        if($line -eq "---To Do---" -or ([string]::IsNullOrWhiteSpace($line)))
        { 
            continue 
        }

        $properties = $line.Split("|")

        $todoItem = [PSCustomObject]@{
            Id = $properties[0]
            DateRecorded = $properties[1]
            Message = $properties[2]
        }
        $todoItems += $todoItem
    }

    return $todoItems
}

function read-jltodo{
    [CmdletBinding()]
    param([string] $fileName)

    $todoItems = get-jltodo $fileName
    foreach($item in $todoItems){
        Write-Host 
    }
}

#read-jltodo "C:\Users\jloschen\Documents\Projects\2022\Powershell Scripts\To Do tracker\To Do Tracker.todo"
function add-jltodo {
    [CmdletBinding()]
    param([string] $message, [string] $todoName)
    
    #$path = "C:\Users\jloschen\Documents\Projects\2022\Powershell Scripts\To Do tracker\$todoName.todo"
    $path = "C:\Users\Josh\Documents\Menards\2022\Powershell\To Do tracker\$todoName.todo"
    
    if(Test-Path $path)
    {
        [System.Collections.ArrayList]$content = Get-Content $path 

        $date = Get-Date

        $content.Insert(1, "$(get-jlpassword)|$($date.ToString("yyyy-MM-dd HH:mm"))|$message")
        
        $content | Out-File $path

    }else{
        write-host "Need to call create todo here"
    }
}
#add-jltodo "jl testing on Jan 28th 2nd try" "To Do Tracker"

function get-jlpassword{
    [CmdletBinding()]
    param()
    
    #gives weird characters back
    #$length = 4
    #$nonAlphaChars = 0
    #$myPassword = [System.Web.Security.Membership]::GeneratePassword($length, $nonAlphaChars)
    #return $myPassword

    #$charSet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'.ToCharArray()
    $charSet = 'abcdefghijklmnopqrstuvwxyz0123456789'.ToCharArray()

    $first = $charSet[(Get-Random -Maximum $charSet.Length)]
    $second = $charSet[(Get-Random -Maximum $charSet.Length)]
    $third = $charSet[(Get-Random -Maximum $charSet.Length)]
    $fourth = $charSet[(Get-Random -Maximum $charSet.Length)]
    $fifth = $charSet[(Get-Random -Maximum $charSet.Length)]

    return "$first$second$third$fourth$fifth"
}
#get-jlpassword 

function set-jldone {
    [CmdletBinding()]
    param([string] $fileName, 
          [string] $id)

    $content = Get-Content $fileName 


    $doneIndex = $content.IndexOf("---Done---");
    $idIndex = $content.IndexOf($id);

    foreach($line in $content){
    #work here when getting back into this

    }

    Write-Host "$doneIndex $idIndex $id"
}

set-jldone "C:\Users\Josh\Documents\Menards\2022\Powershell\To Do tracker\To Do Tracker.todo" "zerp8"