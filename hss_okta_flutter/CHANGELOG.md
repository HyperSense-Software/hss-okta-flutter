# 1.0.1
* Updated readme.md
* Updated pubspec.yaml description property

# 1.0.0
* Initial Release of the plugin

# 1.1.0
* Added Okta Web
* Updated readme.md

# 1.1.1
* Updated readme.md

# 1.2.2
* Made OktaAuth private
* Added getter for OktaAuth
* Removed OktaConfig
* Added AuthStateManager
* Added TokenManager
* Added Helper methods for OktaAuth
* Changed initialize auth client parameters to OktaConfig
* Added additional okta config parameters

# 1.2.3
* Updated OktaConfig constructor
* Added additional OktaConfig properties
* Fixed Bug regarding mishandling of mobile and web exports

# 1.2.4
* Fixed missing extension for export barrel

# 1.3.0
* Fixed Missing Interop tag for OktaAuth
* Added getUserInfo call
* Removed misleading UnImplemented Exception message
* Updated setTokens to accept Tokens
* Updated getTokens return type to Tokens
* Changed setTokens from Future<void> to void
* Changed getUserInfo return type to Map
* Update Token abstractons
* Added refresh token
* Added hasExpired in TokenManager
* Updated getToken to return Abstract token
* Added Userclaims 
* Added Userclaims to AbstractToken

# 1.3.1
* removed acces to OktaAuth JS Object
* Changed return type of getUserInfo to UserClaims
* Added revoke AccessToken
* Added revoke RefreshToken
* Added Alias of getUserInfo
* Added removeOriginalUri,getOriginalUri, and setOriginalUri to OktaAuth
* Added handleRedirect for OktaAuth
* Added setHeaders to OktaAuth
* Added other AuthorizeOptions arguments

# 1.3.2
* Added Authn API
* Added AuthStateManager
* Addded subscribe to authentication changes
* Added unsubscribe to authentication changes
* Added User claims class
* Added Session API
* exposed AuthClient for web users

# 1.3.3
* Added Fix for a problem in iOS which causes non-exhaustive error, making some users unable to build

# 1.3.4
* Added getAllIds for iOS and Android
* Added removeCredential for iOS and Android
* Added setDefaultCredential for iOS
* Added getToken for Android and iOS
* Fixed Missing error return for native Browser SignIn and Signout streams
* Fixed Crash on android when okta.properties has bad values

# 1.4.0
* Fixed renew token not accepting abstract tokens
* updated example UI

# 1.4.1
* Added authstate methods

# 1.4.2
* Fixed Outdated web stub causing example running issues

# 1.4.3
* updated dependencies
* generated pigeon files for exceptions
* updated exception throws with the generated ones for better stacktrace and exception logging

# 1.4.4
* Changes scope argument from string to list of strings

# 1.4.5
* Fixed Logout in web
* Added Logout in example

# 1.4.6
* Added continuation to direct auth flow

# 1.4.7
* Fixed issue with iOS crashing, due to non exhaustive switch
* Fixed issue with Android crashing due to wrong stack trace call

# 1.4.8
* Deprecated widgets for browser signin
* Added new web browser signin for android and ios

# 1.4.9
* Changed continuation to default in direct authentication in switch statement for statuses in ios

# 1.5.0
* Updated documentation
* Changed example to the newer web browser authentication