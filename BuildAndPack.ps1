param(
    [string] $VersionSuffix,
    [string] $GitCommitId,
    [string[]] $MsBuildArgs,
    [switch] $CIBuild,
    [switch] $Debug
)

if (-not $semver)
{
    set-variable -name semver -scope global -value (get-content .\semver.txt)
}

if ($VersionSuffix -or $CIBuild)
{
    $version = "$semver$VersionSuffix"
}
else
{
    $epoch = [math]::truncate((new-timespan -start (get-date -date "01/01/1970") -end (get-date)).TotalSeconds)
    $version = "$semver-local$epoch"
}

if(-not $GitCommitId)
{
    $GitCommitId = $(git rev-parse HEAD)
}

$Configuration = 'Release'
if ($Debug)
{
    $Configuration = 'Debug'
}

$solutionDir = "$((Resolve-Path .).Path)\"
$defaultArgs = "/v:m", "/nologo",
    "/p:SolutionDir=$solutionDir",
    "/p:RepositoryCommit=$GitCommitId",
    "/p:Version=$version",
    "/p:Configuration=$Configuration",
    "/p:SEPrecompilerPath=$solutionDir\StackExchange.Precompilation.Build\bin\$Configuration\net472"
if ($MsBuildArgs)
{
    $defaultArgs += $MsBuildArgs
}
& msbuild ($defaultArgs + "/t:Restore")
& msbuild ($defaultArgs + "/t:Build,Pack")

if ($LastExitCode -ne 0)
{
    throw "MSBuild failed"
}

& ".\Test.ConsoleApp\bin\$Configuration\net472\Test.ConsoleApp.exe"

if ($LastExitCode -ne 0)
{
    throw "Test.ConsoleApp failed to run"
}
