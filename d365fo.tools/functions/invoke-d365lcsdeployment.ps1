﻿
<#
    .SYNOPSIS
        Start the deployment of a deployable package
        
    .DESCRIPTION
        Deploy a deployable package from the Asset Library from a LCS project using the API provided by Microsoft
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER AssetId
        The unique id of the asset / file that you are trying to deploy from LCS
        
    .PARAMETER EnvironmentId
        The unique id of the environment that you want to work against
        
        The Id can be located inside the LCS portal
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        Depending on whether your LCS project is located in europe or not, there is 2 valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsDeployment -ProjectId 123456789 -AssetId "958ae597-f089-4811-abbd-c1190917eaae" -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -BearerToken "Bearer JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will start the deployment of the file located in the Asset Library.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The file is identified by the AssetId "958ae597-f089-4811-abbd-c1190917eaae", which is obtained either by earlier upload or simply looking in the LCS portal.
        The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        The request will authenticate with the BearerToken "Bearer JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsDeployment -AssetId "958ae597-f089-4811-abbd-c1190917eaae"
        
        This will start the deployment of the file located in the Asset Library.
        The file is identified by the AssetId "958ae597-f089-4811-abbd-c1190917eaae", which is obtained either by earlier upload or simply looking in the LCS portal.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
    .LINK
        Get-D365LcsApiConfig
        
    .LINK
        Get-D365LcsApiToken
        
    .LINK
        Get-D365LcsAssetValidationStatus
        
    .LINK
        Get-D365LcsDeploymentStatus
        
    .LINK
        Invoke-D365LcsApiRefreshToken
        
    .LINK
        Invoke-D365LcsUpload
        
    .LINK
        Set-D365LcsApiConfig
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, LCS, Upload, Api, AAD, Token, Deployment, Deploy
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Invoke-D365LcsDeployment {
    [CmdletBinding()]
    [OutputType()]
    param(
        [Parameter(Mandatory = $false)]
        [int] $ProjectId = $Script:LcsApiProjectId,
        
        [Parameter(Mandatory = $false)]
        [Alias('Token')]
        [string] $BearerToken = $Script:LcsApiBearerToken,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 3)]
        [string] $AssetId,

        [Parameter(Mandatory = $false)]
        [string] $EnvironmentId = $Script:LcsApiEnvironmentId,

        [Parameter(Mandatory = $false)]
        [string] $LcsApiUri = $Script:LcsApiLcsApiUri
    )

    Invoke-TimeSignal -Start

    if (-not ($BearerToken.StartsWith("Bearer "))) {
        $BearerToken = "Bearer $BearerToken"
    }

    $deploymentStatus = Start-LcsDeployment -BearerToken $BearerToken -ProjectId $ProjectId -AssetId $AssetId -EnvironmentId $EnvironmentId -LcsApiUri $LcsApiUri

    Invoke-TimeSignal -End

    $deploymentStatus
}