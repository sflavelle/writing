param (
    [string]$Part,
    [string]$ChapterNumber,
    [string]$ChapterName,
    [string]$OutputName = "BeginAgain",
    [switch]$Verbose = $false,
    [switch]$ePub = $false,
    [switch]$HTML = $true,
    [string]$Format
)

$contentPath = if ( $Part -and $ChapterNumber ) { 
    Get-ChildItem -Directory -Path ".\Chapters\Part $Part" | Where-Object {$_.Name -match "^$("{0:d2}" -f $ChapterNumber) "} | Select-Object -ExpandProperty FullName
}
elseif ( $Part -and $ChapterName ) {
    Get-ChildItem -Directory -Path ".\Chapters\Part $Part" | Where-Object {$_.Name -match $ChapterName} | Select-Object -ExpandProperty FullName
}
elseif ( $Part ) {
    Get-ChildItem -Directory -Path ".\Chapters\Part $Part" | Select-Object -ExpandProperty FullName
}
else { Get-Item Chapters | Select-Object -ExpandProperty FullName }


# collect everything into a temp variable
$content = switch ($IsWindows)
{
    true { 
        Get-ChildItem -Path $contentPath -Filter *.md -Recurse -ErrorAction SilentlyContinue | Get-Content -Encoding utf8 -Raw | Join-String -Separator "`n`n" 
        }
    false { 
        Get-ChildItem -Path $contentPath -Filter *.md -Recurse -ErrorAction SilentlyContinue | Sort-Object -Property Directory, Name | Get-Content -Encoding utf8 -Raw | Join-String -Separator "`n`n" 
        }
}

# if ($content.Length = 0) { Write-Error -Category ReadError -Message "Content path '$contentPath' has nothing in it.";  }
if ( $Verbose )
{
    Write-Host -BackgroundColor Yellow -ForegroundColor Black "Selected $contentPath"
    Get-Variable content -ValueOnly | Measure-Object -IgnoreWhiteSpace -Word -Character -Line
}

# to ePub
if ( $ePub ) {
    Write-Host "Compiling to ePub..."
    Get-Variable content -ValueOnly | pandoc --verbose --defaults pandoc-defaults.yaml --metadata-file=Resources/metadata.yaml --to epub -o Compiled/$OutputName.epub
}
# to HTML
if ( $HTML ) {
    Write-Host "Compiling to HTML..."
    Get-Variable content -ValueOnly | pandoc --verbose --defaults pandoc-defaults.yaml --metadata-file=Resources/metadata.yaml --to html -o Compiled/$OutputName.html
}

if ( $Format ) {
    Write-Host "Compiling to $Format..."
    Get-Variable content -ValueOnly | pandoc --verbose --defaults pandoc-defaults.yaml --metadata-file=Resources/metadata.yaml --to $Format -o Compiled/$OutputName.$Format
}

Write-Host "Done!"