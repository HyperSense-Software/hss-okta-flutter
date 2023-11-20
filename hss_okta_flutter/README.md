
# HSS Okta Flutter

The presented plugin functions as an abstraction layer, seamlessly integrating Okta's Native SDKs into the Flutter ecosystem, thereby enabling the utilization of Okta's robust security framework within a cross-platform Flutter environment. This encapsulation endows Flutter-based iOS and Android applications with the capability to leverage Okta's Classic Engine Authentication workflows, ensuring a secure and efficient user authentication experience. The plugin is architecturally designed to interface fluently with native platform capabilities, harnessing the power of Dart's asynchronous features to provide a non-blocking, streamlined authentication process that is both platform-agnostic and performance-optimized.

🤝 **Contributors & Maintainers**:

This project is proudly developed and maintained by [HyperSense Software](https://hypersense-software.com/).

📄 **License**:

Distributed under the MIT License. See LICENSE for more information.


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
