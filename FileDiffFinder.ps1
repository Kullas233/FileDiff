function Cut-String
{
    param(
        [Parameter (Mandatory = $true)] [String]$str
    )

    $copy = $str
    return ($copy.Substring(14, $str.Length-33))
}

#$file1 = "C:\Users\dylan.kullas\Documents\Help\FileDiff\file1.txt"
#$file2 = "C:\Users\dylan.kullas\Documents\Help\FileDiff\file2.txt"
$file1 = "/Users/dkullas/Documents/Powershell Scripts/Fantasy Football/Untitled1.txt"
$file2 = "/Users/dkullas/Documents/Powershell Scripts/Fantasy Football/ttestdjohn.txt"
#$file1 = "C:\Users\dylan.kullas\Documents\My Received Files\Compare-PrePostScans.ps1"
#$file2 = "L:\dkullas\with dups\Compare-PrePostScans-withDups.ps1"
#$diff = "C:\Users\dylan.kullas\Documents\Help\FileDiff\diff.txt"
$diff = "/Users/dkullas/Documents/Powershell Scripts/Fantasy Football/diff.txt"

$str1 = Get-Content $file1
$str2 = Get-Content $file2
Compare-Object $str2 $str1 -IncludeEqual  | Set-Content $diff

$strDiff = Get-Content $diff
$output = ""


$section = 0
for($x = 0; $x -lt $strDiff.Count; $x++)
{
    if($strDiff[$x].Contains("===") -and $section -eq 0)
    {
        $output += "This is the same in both files`n"
        $section++
    }
    elseif($strDiff[$x].Contains("==>") -and $section -eq 1)
    {
        $output += "`n`n`n`n`nThis is only in file1`n"
        $section++
    }
    elseif($strDiff[$x].Contains("=<=") -and $section -eq 2)
    {
        $output += "`n`n`n`n`nThis is only in file2`n"
        $section++
    }

    $codeLine = $(Cut-String -str $strDiff[$x])
    if($codeLine -ne "")
    {
        if($section -eq 2)
        {
            $lineNum = $str1.indexOf($codeLine)
            $output += ($lineNum+1)
        }
        else
        {
            $lineNum = $str2.indexOf($codeLine)
            $output += ($lineNum+1)
        }

        if($lineNum -lt 99)
        {
            $output += " "
        }
        if($lineNum -lt 9)
        {
            $output += " "
        }
        $output += "|"
    }
    else
    {
        $output += "   |"
    }
    
    
    $output += $codeLine
    $output += "`n"
}

$output | Set-Content $diff