$rootFolder = "D:\test"
$folders = Get-ChildItem -Directory -Path $rootFolder -Recurse |
    Sort-Object -Property @{Expression = { (Get-ChildItem -File -Path $_.FullName -Recurse | Measure-Object -Property Length -Sum).Sum }; Descending = $true }

$output = @()
foreach ($folder in $folders) {
    $folderPath = $folder.FullName
    $fileCount = (Get-ChildItem -File -Path $folderPath -Recurse).Count
    $folderSize = (Get-ChildItem -File -Path $folderPath -Recurse | Measure-Object -Property Length -Sum).Sum
    $folderLevel = ($folder.FullName -split [regex]::Escape($rootFolder))[1] -split "\\"

    $entry = [PSCustomObject]@{
        'フォルダ' = $folderPath
        'ファイル数' = $fileCount
        '容量' = $folderSize
        '階層' = $folderLevel.Count
    }

    $output += $entry
}

$output | Export-Csv -Path "D:\output.csv" -Encoding UTF8 -NoTypeInformation
