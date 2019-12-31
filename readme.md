# RestPS

PowerShell Framework for creating and running Simple ReSTful APIs

## Build Status  

[![Build status](https://ci.appveyor.com/api/projects/status/github/jpsider/RestPS?branch=master&svg=true)](https://ci.appveyor.com/project/JustinSider/RestPS)
[![PS Gallery](https://img.shields.io/badge/install-PS%20Gallery-blue.svg)](https://www.powershellgallery.com/packages/RestPS/)
[![Coverage Status](https://coveralls.io/repos/github/jpsider/RestPS/badge.svg?branch=master)](https://coveralls.io/github/jpsider/RestPS?branch=master)
[![Documentation Status](https://img.shields.io/badge/docs-latest-brightgreen.svg?style=flat)](http://restps.readthedocs.io/en/latest/?badge=latest)

![](https://github.com/jpsider/RestPS/blob/master/z_Images/icon_2.png "RestPS Icon") 

## Docs  

[Help](http://restps.readthedocs.io/en/latest/?badge=latest)

## Getting Started

Install from the PSGallery and Import the module

    Install-Module RestPS
    Import-Module RestPS

It is recommended to set the PowerShell execution policy to RemoteSigned and run the console as administrator.

    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

## Using RestPS

When you start an Endpoint you can specify several different parameters:

* Port
  * A Port can be specified, but is not required. The default is 8080.
* SSLThumbprint
  * A SSLThumbprint is used to identify the SSL certificate for the HTTPS binding, but is not required. If no SSLThumbprint is set, RestPS will default to HTTP traffic.
* RestPSLocalRoot
  * RestPSLocalRoot is a local directory where Endpoint scripts are stored, but is not required. The default is C:\\RestPS
* AppGuid
  * An AppGuid defines an application ID (not required). If a SSLThumbprint is specified then an AppGuid is required.
  * It is not mandatory to supply an AppGuid, it will be auto generated if it is not supplied as a parameter.
* VerificationType
  * A VerificationType (optional) - accepted values:
    * VerifyRootCA - Verifies the Root Certificate Authority (CA) of the server and client certificate match.
    * VerifySubject - Verifies the RootCA, and the client is on a user provided Access Control List (ACL).
    * VerifyUserAuth - Provides an option for advanced authentication, plus the RootCA, subject checks.
* RoutesFilePath
  * A custom Routes file can be specified (highly recommended, but not required). A default file is included in the RestPS module and it expects the 'RestPSLocalRoot' to be C:\\RestPS.

## Starting a HTTP RestPS Endpoint

This example will use the default parameters and example files included with the RestPS Module.

### Deploy RestPS example directories and files

    Invoke-DeployRestPS -LocalDir 'C:\RestPS'

### Start your first Endpoint

Using all of the included files and default directories perform the following command:

    $RestPSparams = @{
                RoutesFilePath = 'C:\RestPS\endpoints\RestPSRoutes.json'
                Port = '8080'
            }
    Start-RestPSListener @RestPSparams

This is a blocking command, you will need to shutdown the endpoint in order to return to the PowerShell prompt.

### Retrieve information from the new Endpoint

Open a new Console window to act as the client.
Use `Invoke-RestMethod` to access the data the Endpoint is providing.

    $RestMethodParams = @{
                Uri = 'http://localhost:8080/process?name=powershell'
                Method = 'Get'
                UseBasicParsing = $true
            }
    Invoke-RestMethod @RestMethodParams

The return from the command should look similar to the following table:

    ProcessName    Id MainWindowTitle
    -----------    -- ---------------
    powershell   1992 Administrator: powershell.exe - Shortcut
    powershell   3380 Administrator: powershell.exe - Shortcut
    powershell   6668 RestPS - http:// - Port: 8080
    powershell  11440

### Shutdown a RestPS Endpoint

    $RestMethodParams = @{
                Uri = 'http://localhost:8080/endpoint/shutdown'
                Method = 'Get'
                UseBasicParsing = $true
            }
    Invoke-RestMethod @RestMethodParams

## Securing RestPS Endpoints

RestPS can implement 3 different types of security:

* Standard SSL
* Client Verification
* Client Authentication

### Using SSL with RestPS

#### Setup a local Certificate environment for testing

If you are familiar with SSL certificates, AWESOME!, otherwise view my [blog post](https://invoke-automation.blog/2018/09/16/creating-a-local-ssl-certificate-hierarchy-with-windows-powershell/) on setting up a simple Certificate hierarchy.

#### Creating an Endpoint with SSL

Once you have a Server and Client certificate signed by the same Root Certificate Authority, open two PowerShell consoles, one for the Client, and one for the Server.
You can rename the console title with the following command:

    $Host.UI.RawUI.WindowTitle = 'ClientConsole'
    $Host.UI.RawUI.WindowTitle = 'ServerConsole'

In the ServerConsole, capture the Server certificate as a variable, this will be used to identify the thumbprint. Next, we can setup the RestPS parameters and start the Endpoint:

    $ServerParams = @{
        RoutesFilePath = 'C:\RestPS\endpoints\RestPSRoutes.json'
        Port = 8080
        SSLThumbprint = $ServerCert.Thumbprint
        VerificationType = 'VerifyRootCA'
    }
    Start-RestPSListener @ServerParams

In the console you should see the title has changed, and the following message was posted:

    Starting: https:// Listener on Port: 8080

If you attempt to connect to this endpoint from the client console without using a SSL certificate you will receive an error similar to:

    401 Client failed Verification or Authentication

This can be avoided by using the Client Certificate in the `Invoke-RestMethod` command:

    $HttpsParams = @{
      Uri = 'https://localhost:8080/process?name=powershell'
      Method = 'Get'
      Certificate = $ClientCert
      UseBasicParsing = $true
    }
    Invoke-RestMethod @HttpsParams

        ProcessName    Id MainWindowTitle
        -----------    -- ---------------
        powershell   5708
        powershell  10072 Administrator: powershell.exe - Shortcut
        powershell  12772 RestPS - https:// - Port: 8080

You can now shutdown the Endpoint, a Client certificate is still required!

    $HttpsParams = @{
      Uri = 'https://localhost:8080/endpoint/shutdown'
      Method = 'Get'
      Certificate = $ClientCert
      UseBasicParsing = $true
    }
    Invoke-RestMethod @HttpsParams

#### Client Verification

Think of this as an Access Control List(ACL). RestPS includes and example function, `Get-RestAclList`, that contains an ACL list, simply add the Common Names (CN) that are allowed to access the data to this list. Additional Verification options include

* List of names from Active Directory
* Querying an actual Certificate Authority for authorized Users
* Or any other way to create a list of users via PowerShell

Example Parameters for the 'VerifySubject' VerificationType

    $ServerParams = @{
        RoutesFilePath = 'C:\RestPS\endpoints\RestPSRoutes.json'
        Port = 8080
        SSLThumbprint = $ServerCert.Thumbprint
        VerificationType = 'VerifySubject'
    }
    Start-RestPSListener @ServerParams

#### Client Authentication

This level of security requires the user to provide a valid certificate, on the ACL, and proper credentials. Authentication methods could include:

* A password (encrypted/hashed)
* Web token
* RSA token

An example function, `Get-RestUserAuth`, is included with RestPS and uses a plain text example.

Example Parameters for the 'VerifyUserAuth' VerificationType

    $ServerParams = @{
        RoutesFilePath = 'C:\RestPS\endpoints\RestPSRoutes.json'
        Port = 8080
        SSLThumbprint = $ServerCert.Thumbprint
        VerificationType = 'VerifyUserAuth'
    }
    Start-RestPSListener @ServerParams

### Final Notes on Security

Simple SSL, only verifies the client has a certificate signed by the same CA, it does not validate the user. The `Get-RestACLList` and `Get-RestUserAuth` example files are meant to be extended to suit your organizational needs. Always make your best effort to protect your critical data!

This project was generated using [Kevin Marquette](http://kevinmarquette.github.io)'s [Full Module Plaster Template](https://github.com/KevinMarquette/PlasterTemplates/tree/master/FullModuleTemplate).
