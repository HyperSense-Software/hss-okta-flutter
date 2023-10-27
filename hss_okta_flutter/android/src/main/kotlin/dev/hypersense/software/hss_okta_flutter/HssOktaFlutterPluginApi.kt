// Autogenerated from Pigeon (v12.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package dev.hypersense.software.hss_okta

import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  if (exception is FlutterError) {
    return listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    return listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

enum class AuthenticationType(val raw: Int) {
  BROWSER(0),
  SSO(1),
  DIRECTAUTH(2);

  companion object {
    fun ofRaw(raw: Int): AuthenticationType? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

enum class AuthenticationResult(val raw: Int) {
  SUCCESS(0),
  MFAREQUIRED(1),
  ERROR(2);

  companion object {
    fun ofRaw(raw: Int): AuthenticationResult? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

enum class AuthenticationFactor(val raw: Int) {
  OTP(0),
  OOB(1);

  companion object {
    fun ofRaw(raw: Int): AuthenticationFactor? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class OktaAuthenticationResult (
  val result: AuthenticationResult? = null,
  val error: String? = null,
  val token: OktaToken? = null,
  val userInfo: UserInfo? = null

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): OktaAuthenticationResult {
      val result: AuthenticationResult? = (list[0] as Int?)?.let {
        AuthenticationResult.ofRaw(it)
      }
      val error = list[1] as String?
      val token: OktaToken? = (list[2] as List<Any?>?)?.let {
        OktaToken.fromList(it)
      }
      val userInfo: UserInfo? = (list[3] as List<Any?>?)?.let {
        UserInfo.fromList(it)
      }
      return OktaAuthenticationResult(result, error, token, userInfo)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      result?.raw,
      error,
      token?.toList(),
      userInfo?.toList(),
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class OktaToken (
  val id: String? = null,
  val token: String? = null,
  val issuedAt: Long? = null,
  val tokenType: String? = null,
  val accessToken: String? = null,
  val scope: String? = null,
  val refreshToken: String? = null

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): OktaToken {
      val id = list[0] as String?
      val token = list[1] as String?
      val issuedAt = list[2].let { if (it is Int) it.toLong() else it as Long? }
      val tokenType = list[3] as String?
      val accessToken = list[4] as String?
      val scope = list[5] as String?
      val refreshToken = list[6] as String?
      return OktaToken(id, token, issuedAt, tokenType, accessToken, scope, refreshToken)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      id,
      token,
      issuedAt,
      tokenType,
      accessToken,
      scope,
      refreshToken,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class UserInfo (
  val userId: String,
  val givenName: String,
  val middleName: String,
  val familyName: String,
  val gender: String,
  val email: String,
  val phoneNumber: String,
  val username: String

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): UserInfo {
      val userId = list[0] as String
      val givenName = list[1] as String
      val middleName = list[2] as String
      val familyName = list[3] as String
      val gender = list[4] as String
      val email = list[5] as String
      val phoneNumber = list[6] as String
      val username = list[7] as String
      return UserInfo(userId, givenName, middleName, familyName, gender, email, phoneNumber, username)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      userId,
      givenName,
      middleName,
      familyName,
      gender,
      email,
      phoneNumber,
      username,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class DirectAuthRequest (
  val username: String,
  val password: String,
  val factors: List<String?>

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): DirectAuthRequest {
      val username = list[0] as String
      val password = list[1] as String
      val factors = list[2] as List<String?>
      return DirectAuthRequest(username, password, factors)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      username,
      password,
      factors,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class DeviceAuthorizationSession (
  val userCode: String? = null,
  val verificationUri: String? = null

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): DeviceAuthorizationSession {
      val userCode = list[0] as String?
      val verificationUri = list[1] as String?
      return DeviceAuthorizationSession(userCode, verificationUri)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      userCode,
      verificationUri,
    )
  }
}

@Suppress("UNCHECKED_CAST")
private object HssOktaFlutterPluginApiCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          DeviceAuthorizationSession.fromList(it)
        }
      }
      129.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          DirectAuthRequest.fromList(it)
        }
      }
      130.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          OktaAuthenticationResult.fromList(it)
        }
      }
      131.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          OktaToken.fromList(it)
        }
      }
      132.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          UserInfo.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is DeviceAuthorizationSession -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      is DirectAuthRequest -> {
        stream.write(129)
        writeValue(stream, value.toList())
      }
      is OktaAuthenticationResult -> {
        stream.write(130)
        writeValue(stream, value.toList())
      }
      is OktaToken -> {
        stream.write(131)
        writeValue(stream, value.toList())
      }
      is UserInfo -> {
        stream.write(132)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface HssOktaFlutterPluginApi {
  fun initializeConfiguration(clientid: String, signInRedirectUrl: String, signOutRedirectUrl: String, issuer: String, scopes: String)
  fun startDirectAuthenticationFlow(request: DirectAuthRequest, callback: (Result<OktaAuthenticationResult?>) -> Unit)
  fun continueDirectAuthenticationMfaFlow(otp: String, callback: (Result<OktaAuthenticationResult?>) -> Unit)
  fun refreshDefaultToken(callback: (Result<Boolean?>) -> Unit)
  fun revokeDefaultToken(callback: (Result<Boolean?>) -> Unit)
  fun getCredential(callback: (Result<OktaAuthenticationResult?>) -> Unit)
  fun startDeviceAuthorizationFlow(callback: (Result<DeviceAuthorizationSession?>) -> Unit)
  fun resumeDeviceAuthorizationFlow(callback: (Result<OktaAuthenticationResult?>) -> Unit)

  companion object {
    /** The codec used by HssOktaFlutterPluginApi. */
    val codec: MessageCodec<Any?> by lazy {
      HssOktaFlutterPluginApiCodec
    }
    /** Sets up an instance of `HssOktaFlutterPluginApi` to handle messages through the `binaryMessenger`. */
    @Suppress("UNCHECKED_CAST")
    fun setUp(binaryMessenger: BinaryMessenger, api: HssOktaFlutterPluginApi?) {
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.initializeConfiguration", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val clientidArg = args[0] as String
            val signInRedirectUrlArg = args[1] as String
            val signOutRedirectUrlArg = args[2] as String
            val issuerArg = args[3] as String
            val scopesArg = args[4] as String
            var wrapped: List<Any?>
            try {
              api.initializeConfiguration(clientidArg, signInRedirectUrlArg, signOutRedirectUrlArg, issuerArg, scopesArg)
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startDirectAuthenticationFlow", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val requestArg = args[0] as DirectAuthRequest
            api.startDirectAuthenticationFlow(requestArg) { result: Result<OktaAuthenticationResult?> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.continueDirectAuthenticationMfaFlow", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val otpArg = args[0] as String
            api.continueDirectAuthenticationMfaFlow(otpArg) { result: Result<OktaAuthenticationResult?> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.refreshDefaultToken", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.refreshDefaultToken() { result: Result<Boolean?> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.revokeDefaultToken", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.revokeDefaultToken() { result: Result<Boolean?> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.getCredential", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.getCredential() { result: Result<OktaAuthenticationResult?> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startDeviceAuthorizationFlow", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.startDeviceAuthorizationFlow() { result: Result<DeviceAuthorizationSession?> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.resumeDeviceAuthorizationFlow", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.resumeDeviceAuthorizationFlow() { result: Result<OktaAuthenticationResult?> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
