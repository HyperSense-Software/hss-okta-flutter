
# HSS Okta Flutter

  

A Flutter plugin that wraps Okta's Native SDK to flutter

  

The Plugin supports Classic Engine Authentication flows.

 

## How to Install

    $ flutter pub add hss_okta_flutter


## Features
Feature | Android | IOS |
|--|--|--|
|**Resource Owner Flow / Direct Authentication**| ✅ (MFA Not Available)| ✅ |
|**Browser Redirect Authentication**|✅|✅|
|**Device Authorization**|✅|✅|
|**Device SSO**|✅|✅|

  
  
  

## Getting Started
Android
Create **okta.property** file inside android root folder

*okta.properties*

    issuer= <https://your.issuer.link>
    clientId= <Your client id>
    signInRedirectUri= <Sign in redirect URL>
    signOutRedirectUri= <Sign out redirect URL>
    scopes= <List of scopes, separated by space>
---
IOS
Create **Okta.plist** in your iOS project

*Okta.plist*

    <key>issuer</key>
    <string>https://your.issuer.link</string>
    <key>clientId</key>
    <string>Your client id</string>
    <key>redirectUri</key>
    <string>Sign in redirect URL</string>
    <key>logoutRedirectUri</key>
    <string>Sign out redirect URL</string>
    <key>scopes</key>
    <string>List of scopes, separated by space</string>


#### General Usage:

    import 'package:hss_okta_flutter/hss_okta_flutter_plugin.dart';

    final _plugin =  HssOktaFlutter();
    
    Future<void> getCredential() async{
    
    try{
	    await _plugin.getCredentials();
    }catch(e){
		    print('$e')
	    }
    }

#### Browser Redirect Authentication

    import 'package:hss_okta_flutter/hss_okta_flutter_plugin.dart';

    @override
    Widget build(BuildContext context){
    return HssOktaBrowserSignOutWidget(
    onResult: (success){
         if(success)
         Navigator.of(context).pop(success);
       }
    builder: (context,child) => Container(child:child)
      )
    }

## Authentication Flows

### Browser Redirect
The login is achieved through the **Web-based OIDC flows**, where the user is redirected to the Okta-Hosted login page. After the user authenticates, they are redirected back to the application.

This launches a popup web view where the user can login and interact with challenges.

### Direct Authentication Flow  / Resource Owner Flow
Direct Authentication with MFA is Only available for iOS.
Used for Owner Resource authentication with user and password.

### Device Authentication Flow
Allow the user to login via another device, the plugin will provide a access code and a URI where the user can login via another device or the browser.

### Device SSO 
Allows Single sign on using a Device secret paired with the user's ID token
