function Get-Deps {
    Param($path)
#    $path = Read-Host "Installation path"
    If(!(Test-Path -PathType container $path))
    {
        New-Item -ItemType Directory -Path $path
    }
    $repo = "yt-dlp/yt-dlp"
    $filenamePattern = "yt-dlp.exe"
    $giturl = ((Invoke-RestMethod -Method GET -Uri "https://api.github.com/repos/$repo/releases")[0].assets | Where-Object name -like $filenamePattern )
    $latest_link = $giturl.browser_download_url
    $name= $giturl.name
    curl -o $path/$name $latest_link
    $path = [Environment]::GetEnvironmentVariable("PATH", "Machine") + [IO.Path]::PathSeparator + $path
    [Environment]::SetEnvironmentVariable( "Path", $path, "Machine" )
    choco install ffmpeg -y 
}

function Get-Cut {
    Param($url, $s, $d)
#    $url = Read-Host "Video link"
#    $s = Read-Host "Start time"
#    $d = Read-Host "Duration"
    $dw_links = yt-dlp -g $url
    ffmpeg -ss $s -i $dw_links[0] -ss $s -i $dw_links[1] -t $d -map 0:v -map 1:a -c:v libx264 -c:a aac output.mp4
}

$video_url = Read-Host "Video link"
$start_time = Read-Host "Start time"
$duration_time = Read-Host "Duration"
Get-Cut -url $video_url -s $start_time -d $duration_time

# function Show-Menu {
#     param (
#         [string]$Title = 'YT cut DL'
#     )
#     Clear-Host
#     Write-Host "================ $Title ================"
#     Write-Host "1: Press '1' to configure dependencies"
#     Write-Host "2: Press '2' to download video"
# 
#     Write-Host "Q: Press 'Q' to quit."
# }

# do {
#     Show-Menu
#     $input = Read-Host "Please make a selection"
#     Clear-Host
#     switch ($input) {
#         '1' {Get-Deps;break}
#         '2' {Get-Cut; break}
#         'q' {break} # do nothing
#         default{
#             Write-Host "You entered '$input'" -ForegroundColor Red
#             Write-Host "Please select one of the choices from the menu." -ForegroundColor Red}
#     }
#     Pause
# } until ($input -eq 'q')