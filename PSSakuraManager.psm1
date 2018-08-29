$URL=@{
    v2320="https://github.com/sakura-editor/sakura/releases/download/v2.3.2.0/sakura2-3-2-0.zip";
    v2310="https://github.com/sakura-editor/sakura/releases/download/v2.3.1.0/sakura2-3-1-0.zip";
    v2300="https://github.com/sakura-editor/sakura/releases/download/v2.3.0.0/sakura2-3-0-0.zip";
    bregonig="https://bitbucket.org/k_takata/bregonig/downloads/bron412.zip"
}

<#
.SYNOPSIS
Sakura Editor をインストールします。

.PARAMETER v2320
Sakura Editor v2.3.2.0 をインストールします。

.PARAMETER v2310
Sakura Editor v2.3.1.0 をインストールします。

.PARAMETER v2300
Sakura Editor v2.3.0.0 をインストールします。
#>
function Install-SakuraEditor([switch]$v2320,[switch]$v2310,[switch]$v2300){
    if($v2320){
        $base_name=(Split-Path -Leaf $URL["v2320"])

        Uninstall-SakuraEditor
        curl.exe $URL["v2320"] -L -o "${HOME}/Downloads/${base_name}"
        Expand-Archive "${HOME}/Downloads/${base_name}" $HOME
    }elseif($v2310){
        $base_name=(Split-Path -Leaf $URL["v2310"])
        $dir_name=($base_name -replace ".zip","")

        Uninstall-SakuraEditor
        curl.exe $URL["v2310"] -L -o "${HOME}/Downloads/${base_name}"
        Expand-Archive "${HOME}/Downloads/${base_name}" "${HOME}/${dir_name}"
    }elseif($v2300){
        $base_name=(Split-Path -Leaf $URL["v2300"])
        $dir_name=($base_name -replace ".zip","")

        Uninstall-SakuraEditor
        curl.exe $URL["v2300"] -L -o "${HOME}/Downloads/${base_name}"
        Expand-Archive "${HOME}/Downloads/${base_name}" "${HOME}/${dir_name}"
    }else{
        Write-Output "オプションを指定してください。"
        return
    }

    Remove-Item "${HOME}/Downloads/${base_name}"
}

<#
.SYNOPSIS
Sakura Editor をアンインストールします。
#>
function Uninstall-SakuraEditor(){
    if(Test-Path "${HOME}/sakura[0-9]*"){
        Remove-Item -Recurse "${HOME}/sakura[0-9]*"
    }
}

<#
.SYNOPSIS
環境変数 Path へ Sakura Editor がインストールされているフォルダーのパスを追加します。
#>
function Set-SakuraEditorPath(){
    $sakura_path=(Resolve-Path "${HOME}/sakura[0-9]*")
    $env:Path="${env:Path}${sakura_path};"
}

<#
.SYNOPSIS
bregonig.dll をインストールします。

.PARAMETER x32
32 bit 版 bregonig.dll をインストールします。

.PARAMETER x64
64 bit 版 bregonig.dll をインストールします。
#>
function Install-Bregonig([switch]$x32,[switch]$x64){
    if($x32 -eq $false -and $x64 -eq $false){
        Write-Output "オプションを指定してください。"
        return
    }
    
    if(Test-Path "${HOME}/sakura[0-9]*"){
        $base_name=(Split-Path -Leaf $URL["bregonig"])
        $dir_name=($base_name -replace ".zip","")
        $sakura_path=(Resolve-Path "${HOME}/sakura[0-9]*")

        Invoke-WebRequest $URL["bregonig"] -OutFile "${HOME}/Downloads/${base_name}"
        Uninstall-Bregonig
        Expand-Archive "${HOME}/Downloads/${base_name}" "${sakura_path}/${dir_name}"
        Remove-Item "${HOME}/Downloads/${base_name}"

        if($x32){
            Copy-Item "${sakura_path}/${dir_name}/bregonig.dll" $sakura_path
        }elseif($x64){
            Copy-Item "${sakura_path}/${dir_name}/x64/bregonig.dll" $sakura_path
        }
    }else{
        Write-Output "Sakura Editor がインストールされていません。"
        return
    }
}

<#
.SYNOPSIS
bregonig.dll をアンインストールします。
#>
function Uninstall-Bregonig(){
    $base_name=(Split-Path -Leaf $URL["bregonig"])
    $dir_name=($base_name -replace ".zip","")
    $sakura_path=(Resolve-Path "${HOME}/sakura[0-9]*")

    if(Test-Path "${sakura_path}/${dir_name}"){
        Remove-Item -Recurse "${sakura_path}/${dir_name}"
    }

    if(Test-Path "${sakura_path}/bregonig.dll"){
        Remove-Item "${sakura_path}/bregonig.dll"
    }
}
