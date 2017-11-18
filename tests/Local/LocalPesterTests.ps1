#Ensure the location is the root of the Github module

Import-Module .\RestPS\RestPS.psm1
. .\RestPS\private\Invoke-AvailableRouteSet.ps1
. .\RestPS\private\Invoke-GetContext.ps1
. .\RestPS\private\Invoke-RequestRouter.ps1
. .\RestPS\private\Invoke-StartListener.ps1
. .\RestPS\private\Invoke-StopListener.ps1
. .\RestPS\private\Invoke-StreamOutput.ps1
. .\RestPS\public\Start-RestPSListener.ps1

#Individual File
Invoke-Pester .\tests\Public\Start-RestPSListener.Tests.ps1 -CodeCoverage .\RestPS\public\Start-RestPSListener.ps1

# Run tests against public folder
Invoke-Pester .\tests\Public\ -CodeCoverage .\RestPS\public\*.ps1

# Run tests against private folder
Invoke-Pester .\tests\private\ -CodeCoverage .\RestPS\private\*.ps1

# Run Script Analyzer against Public folder
Invoke-ScriptAnalyzer -Path .\RestPS\public\

# Run Script Analyzer against Private folder
Invoke-ScriptAnalyzer -Path .\RestPS\private\
