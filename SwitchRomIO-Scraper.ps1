  [CmdLetBinding()]Param([Parameter(Position=0,Mandatory=$False)][ArgumentCompletions('1fichier','Megaup','Buzzheavier','Filefactory','Frdl.to','Mediafire','Qiwi.gg','Up-4ever','Send.cm','Terabox','Google')][String]$FilterProvider,[Parameter(Mandatory=$False)][Int]$MaxResults,[Parameter(Mandatory=$False)][Int]$MaxRetry=50,[Parameter(Mandatory=$False)][Switch]$Refresh)
  Begin{
    Clear-Host;If(([Int]($PSVersionTable).PSVersion.Major)-Lt7){Write-Warning "Run this script with PowerShell 7+";Break};$ProgressPreference='SilentlyContinue';@('ImportExcel')|%{If(!(Get-Module $_ -L)){Install-Module $_ -Sc CurrentUser -Fo -ErrorA SilentlyContinue;Import-Module $_ -ErrorA SilentlyContinue}}
    $S=$MyInvocation.MyCommand;$SN=$S.Name;$SExtension=(Get-Item $SN).Extension;$SFile=(Get-Item $SN).BaseName;$SFullName=$PSCommandPath;$SP=$PSScriptRoot;$CD=(Get-Date).ToString( 'MM-dd-yyyy_HH-mm-ss', [CultureInfo]'en-US' );$E="$SP\$SN.xlsx";If($Refresh){If(Test-Path $E){Try{Remove-Item $E -Fo -ErrorA Stop}Catch{Write-Host "Can't delete file $E";Break}}}
    Function CatchString{[CmdLetBinding()]Param([Parameter(Position=0,Mandatory=$False)][String]$C,[Parameter(Position=1,Mandatory=$False)][String]$FS,[Parameter(Position=2,Mandatory=$False)][String]$SS);Begin{$C=$C.Split([Environment]::NewLine);$P="$FS(.*?)$SS"};Process{$R=[regex]::Match($C,$P).Groups[1].Value};End{Return $R;$FS=""; $SS=""; $C=""; $R=""}}
    Function GetPage{[CmdLetBinding()]Param([Parameter(Position=0,Mandatory=$False)][String]$Uri);Begin{$R=@()};Process{$RQ=Invoke-WebRequest $Uri -UseB;$L=($RQ).Links.href|Where{$_-Notmatch'/switchrom.io'-And$_-Notmatch'/t.me/'-And$_-Notmatch'/tiktok.com/'-And$_-Notmatch'/www.youtube.com/'-And$_-Notmatch'/about-us'-And$_-Notmatch'/contact'-And$_-Notmatch'/dcma-disclaimer'-And$_-Notmatch'/privacy-policy'-And$_-NotMatch'www.google.com/'-And$_-NotMatch'mangolivemodapk.com'}|Select -Unique;$C=($RQ).Content;$O=New-Object PSCustomObject;$O|Add-Member 'Links' $L;$O|Add-Member 'Content' $C;$O|Add-Member 'FullRequest' $RQ;$R+=$O};End{Return $R}}
    Function ReplaceChars{[CmdLetBinding()]Param([Parameter(Position=0,Mandatory=$False,ValueFromPipeLine)][String]$Input);Begin{};Process{$R=(($Input).Replace('"','').Replace('&amp;','').Replace('&#039;','').Replace(' Free Download','').Replace('1fichier: <strong>','').Replace('  ',' ')).Trim()};End{Return $R}}
    $CatchString=${Function:CatchString}.ToString();$ReplaceChars=${Function:ReplaceChars}.ToString();$GetPage=${Function:GetPage}.ToString()
  }
  Process{
    $KP=@('1fichier','Megaup','Buzzheavier','Filefactory','Frdl.to','Mediafire','Qiwi.gg','Up-4ever','Send.cm','Terabox','Google');$J='Links';If(Get-Job -Na $J -ErrorA SilentlyContinue){Get-Job -Na $J|Remove-Job -Fo};$U="https://switchrom.io/nintendo-switch-games";(Invoke-WebRequest $U -UseB).Links.href|%{If($_-NotMatch"/page/2/"-And$_-Match"$U/page/"){$LP=Split-Path $_ -Leaf}};If(Test-Path $E){$IP=Import-Excel $E -DataOnly}Else{$IP=""}
    $I=$(For($I=1;$I-Le$LP;$I++){"$U/page/$I"})|% -Th 20 -Pa{$P=(Invoke-WebRequest $_ -UseB).Links.href|Where{$_-NotMatch'/nintendo-switch-games/'-And$_-NotMatch'/about-us'-And$_-NotMatch'/dcma-disclaimer'-And$_-NotMatch'/contact'-And$_-NotMatch'/privacy-policy'-And$_-NotMatch'/top-100-most-popular-nintendo-switch-games/'-And$_-Ne'https://switchrom.io/'-And$_-Ne'https://switchrom.io'};$P|%{$_+'?download'}};Start-ThreadJob -N $J{$Using:I}|Out-Null;Wait-Job -N $J|Out-Null;$L=Get-Job -Na $J|Receive-Job|Sort;$LC=$L.Count;If($MaxResults){$L=$L|Select -First $MaxResults};Get-Job -Na $J|Remove-Job -Fo;Write-Host "Total Games : $LC";$DLC=0
    $L|%{
      $Result=@()
        $CT=(Invoke-WebRequest $_ -UseB).Content;$FS='<div class="wp-block-button">';$SS='</span>';$P="$FS(.*?)$SS";$PD=(($CT-Replace"`n","")|Select-String -AllMatches $P).Matches.Value;If($FilterProvider){$PD=$PD|Where{$PSItem-Match"$FilterProvider"-And$KP-NotContains$PSItem}};$DLC++;$N="$DLC/$LC";$GN=CatchString $CT '<meta property="og:image:alt" content="' '" />'|ReplaceChars;If(($PD).Count-Eq0){Write-Host "$N - No Downloads - $GN"}
        $Result+=$PD|% -Th 20 -Pa{
          ${Function:CatchString}=$Using:CatchString;${Function:ReplaceChars}=$Using:ReplaceChars;${Function:GetPage}=$Using:GetPage;$DP=CatchString $_ '<a class="wp-block-button__link a-link-button" href="' '"> ';$DPC=$DP.Count;$N=(CatchString $Using:CT '<meta property="og:image:alt" content="' '" />'|ReplaceChars);$DI=CatchString (GetPage $DP).Content '</p><pre>' '</pre>';If(Test-Path $Using:E){If(($Using:IP).DownloadPage -Contains $DP){Write-Host "$Using:N - Already Exist - $N - $DI";EXIT}}
          $PR=((CatchString $_ '"align-middle link-title"> <strong>' '</strong>').Split('|')[-1]).Trim();If($DI-Match"\|"){$A=$DI -Split "\|";$DN=$A[0]|ReplaceChars;$DS=$A[1]|ReplaceChars;If($DC-NotMatch" MB"-And$DC-NotMatch" GB"){$DC="Unknown"};If(!$PR){$PR=$A[2]|ReplaceChars}};$Loop=0;Do{$Loop++;$DL=(GetPage $DP).Links}Until($DL-Match"http"-Or$Loop-Eq$Using:MaxRetry);$DL=$DL -Join ", ";If($Loop-Eq$Using:MaxRetry){Write-Host "$Using:N - Failed - $N - $DI"}Else{Write-Host "$Using:N - Attempts $Loop - $N - $DI"};If($DL-Match'drive.google.com'){$DI=($DL -Split '/')[-2];$DL='https://drive.usercontent.google.com/download?id='+$DI+'&export=download&authuser=0'}
          If($DL){$PR=(Get-Culture).TextInfo.ToTitleCase((((($DL).Split("/")[2]).Split('.'))[-2]))};If($PR-NotMatch$FilterProvider){EXIT};$PW=CatchString (GetPage $DP).Content 'Password ' '</strong>'|ReplaceChars;$DateUpdate=CatchString $Using:CT '<span class="date-update">' '</span>';If($DateUpdate-Match" ago\)"){$DUS=(($DateUpdate -Split " \(")[-1]).Replace(')','')};If(!$PR){If($DL-Match'http'){Try{$PR=([System.Uri]$DL).Host -replace '^www\.'}Catch{}}Else{$PR='Unknown'}}
          $O=New-Object PSCustomObject;$O|Add-Member 'Provider' $PR;$O|Add-Member 'Name' $N;$O|Add-Member 'DownloadName' $DN;$O|Add-Member 'DownloadSize' $DS;$O|Add-Member 'DownloadLink' $DL;$O|Add-Member 'Password' $PW;$O|Add-Member 'DownloadPage' $DP;$O|Add-Member 'Title' (CatchString $Using:CT '<meta property="og:title" content="' '" />'|ReplaceChars);$O|Add-Member 'Genre' (CatchString $Using:CT '<meta property="article:section" content="' '" />'|ReplaceChars)
          $O|Add-Member 'Description' (CatchString $Using:CT '<meta property="og:description" content="' '" />'|ReplaceChars);$O|Add-Member 'DatePublished' (([DateTime](CatchString $Using:CT '<meta property="article:published_time" content="' '" />')).ToString("MM/dd/yyyy HH:mm:ss",[CultureInfo]'en-US'));$O|Add-Member 'DateModified' (([DateTime](CatchString $Using:CT '"dateModified":"' '","')).ToString("MM/dd/yyyy HH:mm:ss",[CultureInfo]'en-US'));$O|Add-Member 'DateUpdate' $DateUpdate
          $O|Add-Member 'DateUpdateSimple' $DUS;$O|Add-Member 'ImageCover' ((CatchString $Using:CT '<div class="img-bg" style="background-image: url\(' '\);background-size:cover;"></div>').Replace("'",''));Return $O
        }
      If($Result){Try{$Result|Export-Excel $E -WorkSheetName $SN -AutoFilter -AutoSize -FreezeTopRow -BoldTopRow -Append}Catch{Start-Sleep 5;$Result|Export-Excel $E -WorkSheetName $SN -AutoFilter -AutoSize -FreezeTopRow -BoldTopRow -Append}}
    }
  }
  End {}
