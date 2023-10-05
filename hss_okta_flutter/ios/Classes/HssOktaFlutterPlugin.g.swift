// Autogenerated from Pigeon (v12.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)"
  ]
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

enum AuthenticationType: Int {
  case browser = 0
  case sso = 1
  case directAuth = 2
}

enum AuthenticationResult: Int {
  case success = 0
  case mfaRequired = 1
  case error = 2
}

enum AuthenticationFactor: Int {
  case otp = 0
  case oob = 1
}

/// Generated class from Pigeon that represents data sent in messages.
struct OktaAuthenticationResult {
  var result: AuthenticationResult? = nil
  var error: String? = nil
  var token: OktaToken? = nil
  var userInfo: UserInfo? = nil

  static func fromList(_ list: [Any?]) -> OktaAuthenticationResult? {
    var result: AuthenticationResult? = nil
    let resultEnumVal: Int? = nilOrValue(list[0])
    if let resultRawValue = resultEnumVal {
      result = AuthenticationResult(rawValue: resultRawValue)!
    }
    let error: String? = nilOrValue(list[1])
    var token: OktaToken? = nil
    if let tokenList: [Any?] = nilOrValue(list[2]) {
      token = OktaToken.fromList(tokenList)
    }
    var userInfo: UserInfo? = nil
    if let userInfoList: [Any?] = nilOrValue(list[3]) {
      userInfo = UserInfo.fromList(userInfoList)
    }

    return OktaAuthenticationResult(
      result: result,
      error: error,
      token: token,
      userInfo: userInfo
    )
  }
  func toList() -> [Any?] {
    return [
      result?.rawValue,
      error,
      token?.toList(),
      userInfo?.toList(),
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct OktaToken {
  var id: String? = nil
  var token: String? = nil
  var issuedAt: Int64? = nil
  var tokenType: String? = nil
  var accessToken: String? = nil
  var scope: String? = nil
  var refreshToken: String? = nil

  static func fromList(_ list: [Any?]) -> OktaToken? {
    let id: String? = nilOrValue(list[0])
    let token: String? = nilOrValue(list[1])
    let issuedAt: Int64? = isNullish(list[2]) ? nil : (list[2] is Int64? ? list[2] as! Int64? : Int64(list[2] as! Int32))
    let tokenType: String? = nilOrValue(list[3])
    let accessToken: String? = nilOrValue(list[4])
    let scope: String? = nilOrValue(list[5])
    let refreshToken: String? = nilOrValue(list[6])

    return OktaToken(
      id: id,
      token: token,
      issuedAt: issuedAt,
      tokenType: tokenType,
      accessToken: accessToken,
      scope: scope,
      refreshToken: refreshToken
    )
  }
  func toList() -> [Any?] {
    return [
      id,
      token,
      issuedAt,
      tokenType,
      accessToken,
      scope,
      refreshToken,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct UserInfo {
  var userId: String
  var givenName: String
  var middleName: String
  var familyName: String
  var gender: String
  var email: String
  var phoneNumber: String
  var username: String

  static func fromList(_ list: [Any?]) -> UserInfo? {
    let userId = list[0] as! String
    let givenName = list[1] as! String
    let middleName = list[2] as! String
    let familyName = list[3] as! String
    let gender = list[4] as! String
    let email = list[5] as! String
    let phoneNumber = list[6] as! String
    let username = list[7] as! String

    return UserInfo(
      userId: userId,
      givenName: givenName,
      middleName: middleName,
      familyName: familyName,
      gender: gender,
      email: email,
      phoneNumber: phoneNumber,
      username: username
    )
  }
  func toList() -> [Any?] {
    return [
      userId,
      givenName,
      middleName,
      familyName,
      gender,
      email,
      phoneNumber,
      username,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct DirectAuthRequest {
  var username: String
  var password: String
  var factors: [String?]

  static func fromList(_ list: [Any?]) -> DirectAuthRequest? {
    let username = list[0] as! String
    let password = list[1] as! String
    let factors = list[2] as! [String?]

    return DirectAuthRequest(
      username: username,
      password: password,
      factors: factors
    )
  }
  func toList() -> [Any?] {
    return [
      username,
      password,
      factors,
    ]
  }
}

private class HssOktaFlutterPluginApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
      case 128:
        return DirectAuthRequest.fromList(self.readValue() as! [Any?])
      case 129:
        return OktaAuthenticationResult.fromList(self.readValue() as! [Any?])
      case 130:
        return OktaToken.fromList(self.readValue() as! [Any?])
      case 131:
        return UserInfo.fromList(self.readValue() as! [Any?])
      default:
        return super.readValue(ofType: type)
    }
  }
}

private class HssOktaFlutterPluginApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? DirectAuthRequest {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else if let value = value as? OktaAuthenticationResult {
      super.writeByte(129)
      super.writeValue(value.toList())
    } else if let value = value as? OktaToken {
      super.writeByte(130)
      super.writeValue(value.toList())
    } else if let value = value as? UserInfo {
      super.writeByte(131)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class HssOktaFlutterPluginApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return HssOktaFlutterPluginApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return HssOktaFlutterPluginApiCodecWriter(data: data)
  }
}

class HssOktaFlutterPluginApiCodec: FlutterStandardMessageCodec {
  static let shared = HssOktaFlutterPluginApiCodec(readerWriter: HssOktaFlutterPluginApiCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol HssOktaFlutterPluginApi {
  func initializeConfiguration(clientid: String, signInRedirectUrl: String, signOutRedirectUrl: String, issuer: String, scopes: String) throws
  func startDirectAuthenticationFlow(request: DirectAuthRequest, completion: @escaping (Result<OktaAuthenticationResult?, Error>) -> Void)
  func continueDirectAuthenticationMfaFlow(otp: String, completion: @escaping (Result<OktaAuthenticationResult?, Error>) -> Void)
  func refreshDefaultToken(completion: @escaping (Result<Bool?, Error>) -> Void)
  func revokeDefaultToken(completion: @escaping (Result<Bool?, Error>) -> Void)
  func getCredential(completion: @escaping (Result<OktaAuthenticationResult?, Error>) -> Void)
  func startBrowserAuthenticationFlow(completion: @escaping (Result<OktaAuthenticationResult?, Error>) -> Void)
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class HssOktaFlutterPluginApiSetup {
  /// The codec used by HssOktaFlutterPluginApi.
  static var codec: FlutterStandardMessageCodec { HssOktaFlutterPluginApiCodec.shared }
  /// Sets up an instance of `HssOktaFlutterPluginApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: HssOktaFlutterPluginApi?) {
    let initializeConfigurationChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.initializeConfiguration", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      initializeConfigurationChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let clientidArg = args[0] as! String
        let signInRedirectUrlArg = args[1] as! String
        let signOutRedirectUrlArg = args[2] as! String
        let issuerArg = args[3] as! String
        let scopesArg = args[4] as! String
        do {
          try api.initializeConfiguration(clientid: clientidArg, signInRedirectUrl: signInRedirectUrlArg, signOutRedirectUrl: signOutRedirectUrlArg, issuer: issuerArg, scopes: scopesArg)
          reply(wrapResult(nil))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      initializeConfigurationChannel.setMessageHandler(nil)
    }
    let startDirectAuthenticationFlowChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startDirectAuthenticationFlow", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      startDirectAuthenticationFlowChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let requestArg = args[0] as! DirectAuthRequest
        api.startDirectAuthenticationFlow(request: requestArg) { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      startDirectAuthenticationFlowChannel.setMessageHandler(nil)
    }
    let continueDirectAuthenticationMfaFlowChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.continueDirectAuthenticationMfaFlow", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      continueDirectAuthenticationMfaFlowChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let otpArg = args[0] as! String
        api.continueDirectAuthenticationMfaFlow(otp: otpArg) { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      continueDirectAuthenticationMfaFlowChannel.setMessageHandler(nil)
    }
    let refreshDefaultTokenChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.refreshDefaultToken", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      refreshDefaultTokenChannel.setMessageHandler { _, reply in
        api.refreshDefaultToken() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      refreshDefaultTokenChannel.setMessageHandler(nil)
    }
    let revokeDefaultTokenChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.revokeDefaultToken", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      revokeDefaultTokenChannel.setMessageHandler { _, reply in
        api.revokeDefaultToken() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      revokeDefaultTokenChannel.setMessageHandler(nil)
    }
    let getCredentialChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.getCredential", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getCredentialChannel.setMessageHandler { _, reply in
        api.getCredential() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      getCredentialChannel.setMessageHandler(nil)
    }
    let startBrowserAuthenticationFlowChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startBrowserAuthenticationFlow", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      startBrowserAuthenticationFlowChannel.setMessageHandler { _, reply in
        api.startBrowserAuthenticationFlow() { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      startBrowserAuthenticationFlowChannel.setMessageHandler(nil)
    }
  }
}
