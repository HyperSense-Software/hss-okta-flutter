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