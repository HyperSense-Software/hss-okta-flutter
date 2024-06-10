// Autogenerated from Pigeon (v18.0.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon
@file:Suppress("UNCHECKED_CAST", "ArrayInDataClass")

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
  return if (exception is FlutterError) {
    listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    listOf(
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
  DIRECT_AUTH(2);

  companion object {
    fun ofRaw(raw: Int): AuthenticationType? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

enum class DirectAuthenticationResult(val raw: Int) {
  SUCCESS(0),
  MFA_REQUIRED(1),
  ERROR(2);

  companion object {
    fun ofRaw(raw: Int): DirectAuthenticationResult? {
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

enum class RequestIntent(val raw: Int) {
  ENROLL_NEW_USER(0),
  LOGIN(1),
  CREDENTIAL_ENROLLMENT(2),
  CREDENTIAL_UNENROLLMENT(3),
  CREDENTIAL_RECOVERY(4),
  CREDENTIAL_MODIFY(5),
  UNKNOWN(6);

  companion object {
    fun ofRaw(raw: Int): RequestIntent? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class AuthenticationResult (
  val result: DirectAuthenticationResult? = null,
  val error: String? = null,
  val token: OktaToken? = null,
  val userInfo: UserInfo? = null

) {
  companion object {
    @Suppress("LocalVariableName")
    fun fromList(__pigeon_list: List<Any?>): AuthenticationResult {
      val result: DirectAuthenticationResult? = (__pigeon_list[0] as Int?)?.let { num ->
        DirectAuthenticationResult.ofRaw(num)
      }
      val error = __pigeon_list[1] as String?
      val token = __pigeon_list[2] as OktaToken?
      val userInfo = __pigeon_list[3] as UserInfo?
      return AuthenticationResult(result, error, token, userInfo)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      result?.raw,
      error,
      token,
      userInfo,
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
    @Suppress("LocalVariableName")
    fun fromList(__pigeon_list: List<Any?>): OktaToken {
      val id = __pigeon_list[0] as String?
      val token = __pigeon_list[1] as String?
      val issuedAt = __pigeon_list[2].let { num -> if (num is Int) num.toLong() else num as Long? }
      val tokenType = __pigeon_list[3] as String?
      val accessToken = __pigeon_list[4] as String?
      val scope = __pigeon_list[5] as String?
      val refreshToken = __pigeon_list[6] as String?
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
    @Suppress("LocalVariableName")
    fun fromList(__pigeon_list: List<Any?>): UserInfo {
      val userId = __pigeon_list[0] as String
      val givenName = __pigeon_list[1] as String
      val middleName = __pigeon_list[2] as String
      val familyName = __pigeon_list[3] as String
      val gender = __pigeon_list[4] as String
      val email = __pigeon_list[5] as String
      val phoneNumber = __pigeon_list[6] as String
      val username = __pigeon_list[7] as String
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
    @Suppress("LocalVariableName")
    fun fromList(__pigeon_list: List<Any?>): DirectAuthRequest {
      val username = __pigeon_list[0] as String
      val password = __pigeon_list[1] as String
      val factors = __pigeon_list[2] as List<String?>
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
    @Suppress("LocalVariableName")
    fun fromList(__pigeon_list: List<Any?>): DeviceAuthorizationSession {
      val userCode = __pigeon_list[0] as String?
      val verificationUri = __pigeon_list[1] as String?
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

/** Generated class from Pigeon that represents data sent in messages. */
data class IdxResponse (
  val expiresAt: Long? = null,
  val user: UserInfo? = null,
  val canCancel: Boolean,
  val isLoginSuccessful: Boolean,
  val intent: RequestIntent,
  val messages: List<String?>,
  val authenticationFactors: List<String?>? = null,
  val token: OktaToken? = null

) {
  companion object {
    @Suppress("LocalVariableName")
    fun fromList(__pigeon_list: List<Any?>): IdxResponse {
      val expiresAt = __pigeon_list[0].let { num -> if (num is Int) num.toLong() else num as Long? }
      val user = __pigeon_list[1] as UserInfo?
      val canCancel = __pigeon_list[2] as Boolean
      val isLoginSuccessful = __pigeon_list[3] as Boolean
      val intent = RequestIntent.ofRaw(__pigeon_list[4] as Int)!!
      val messages = __pigeon_list[5] as List<String?>
      val authenticationFactors = __pigeon_list[6] as List<String?>?
      val token = __pigeon_list[7] as OktaToken?
      return IdxResponse(expiresAt, user, canCancel, isLoginSuccessful, intent, messages, authenticationFactors, token)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      expiresAt,
      user,
      canCancel,
      isLoginSuccessful,
      intent.raw,
      messages,
      authenticationFactors,
      token,
    )
  }
}

private object HssOktaFlutterPluginApiCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          AuthenticationResult.fromList(it)
        }
      }
      129.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          DeviceAuthorizationSession.fromList(it)
        }
      }
      130.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          DirectAuthRequest.fromList(it)
        }
      }
      131.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          IdxResponse.fromList(it)
        }
      }
      132.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          IdxResponse.fromList(it)
        }
      }
      133.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          OktaToken.fromList(it)
        }
      }
      134.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          UserInfo.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is AuthenticationResult -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      is DeviceAuthorizationSession -> {
        stream.write(129)
        writeValue(stream, value.toList())
      }
      is DirectAuthRequest -> {
        stream.write(130)
        writeValue(stream, value.toList())
      }
      is IdxResponse -> {
        stream.write(131)
        writeValue(stream, value.toList())
      }
      is IdxResponse -> {
        stream.write(132)
        writeValue(stream, value.toList())
      }
      is OktaToken -> {
        stream.write(133)
        writeValue(stream, value.toList())
      }
      is UserInfo -> {
        stream.write(134)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface HssOktaFlutterPluginApi {
  fun startDirectAuthenticationFlow(request: DirectAuthRequest, callback: (Result<AuthenticationResult?>) -> Unit)
  fun continueDirectAuthenticationMfaFlow(otp: String, callback: (Result<AuthenticationResult?>) -> Unit)
  fun refreshDefaultToken(callback: (Result<Boolean?>) -> Unit)
  fun revokeDefaultToken(callback: (Result<Boolean?>) -> Unit)
  fun getCredential(callback: (Result<AuthenticationResult?>) -> Unit)
  fun startDeviceAuthorizationFlow(callback: (Result<DeviceAuthorizationSession?>) -> Unit)
  fun resumeDeviceAuthorizationFlow(callback: (Result<AuthenticationResult?>) -> Unit)
  fun startTokenExchangeFlow(deviceSecret: String, idToken: String, callback: (Result<AuthenticationResult?>) -> Unit)
  fun getAllUserIds(callback: (Result<List<String>>) -> Unit)
  fun getToken(tokenId: String, callback: (Result<AuthenticationResult?>) -> Unit)
  fun removeCredential(tokenId: String, callback: (Result<Boolean>) -> Unit)
  fun setDefaultToken(tokenId: String, callback: (Result<Boolean>) -> Unit)
  fun authenticateWithEmailAndPassword(email: String, password: String, callback: (Result<IdxResponse?>) -> Unit)
  fun startInteractionCodeFlow(email: String?, remidiation: String, callback: (Result<IdxResponse?>) -> Unit)
  fun startSMSPhoneEnrollment(phoneNumber: String, callback: (Result<Boolean>) -> Unit)
  fun continueSMSPhoneEnrollment(passcode: String, callback: (Result<Boolean>) -> Unit)
  fun continueWithGoogleAuthenticator(code: String, callback: (Result<IdxResponse?>) -> Unit)
  fun continueWithEmailCode(code: String, callback: (Result<IdxResponse?>) -> Unit)
  fun sendEmailCode(callback: (Result<Unit>) -> Unit)
  fun startUserEnrollmentFlow(firstName: String, lastName: String, email: String, callback: (Result<Boolean>) -> Unit)
  fun recoverPassword(identifier: String, callback: (Result<IdxResponse>) -> Unit)
  fun getIdxResponse(callback: (Result<IdxResponse?>) -> Unit)
  fun cancelCurrentTransaction(callback: (Result<Boolean>) -> Unit)
  fun getRemidiations(callback: (Result<List<String>>) -> Unit)
  fun getRemidiationsFields(remidiation: String, fields: String?, callback: (Result<List<String>>) -> Unit)
  fun getRemidiationAuthenticators(remidiation: String, fields: String?, callback: (Result<List<String>>) -> Unit)

  companion object {
    /** The codec used by HssOktaFlutterPluginApi. */
    val codec: MessageCodec<Any?> by lazy {
      HssOktaFlutterPluginApiCodec
    }
    /** Sets up an instance of `HssOktaFlutterPluginApi` to handle messages through the `binaryMessenger`. */
    fun setUp(binaryMessenger: BinaryMessenger, api: HssOktaFlutterPluginApi?, messageChannelSuffix: String = "") {
      val separatedMessageChannelSuffix = if (messageChannelSuffix.isNotEmpty()) ".$messageChannelSuffix" else ""
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startDirectAuthenticationFlow$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val requestArg = args[0] as DirectAuthRequest
            api.startDirectAuthenticationFlow(requestArg) { result: Result<AuthenticationResult?> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.continueDirectAuthenticationMfaFlow$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val otpArg = args[0] as String
            api.continueDirectAuthenticationMfaFlow(otpArg) { result: Result<AuthenticationResult?> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.refreshDefaultToken$separatedMessageChannelSuffix", codec)
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.revokeDefaultToken$separatedMessageChannelSuffix", codec)
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.getCredential$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.getCredential() { result: Result<AuthenticationResult?> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startDeviceAuthorizationFlow$separatedMessageChannelSuffix", codec)
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.resumeDeviceAuthorizationFlow$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.resumeDeviceAuthorizationFlow() { result: Result<AuthenticationResult?> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startTokenExchangeFlow$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val deviceSecretArg = args[0] as String
            val idTokenArg = args[1] as String
            api.startTokenExchangeFlow(deviceSecretArg, idTokenArg) { result: Result<AuthenticationResult?> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.getAllUserIds$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.getAllUserIds() { result: Result<List<String>> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.getToken$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val tokenIdArg = args[0] as String
            api.getToken(tokenIdArg) { result: Result<AuthenticationResult?> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.removeCredential$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val tokenIdArg = args[0] as String
            api.removeCredential(tokenIdArg) { result: Result<Boolean> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.setDefaultToken$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val tokenIdArg = args[0] as String
            api.setDefaultToken(tokenIdArg) { result: Result<Boolean> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.authenticateWithEmailAndPassword$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val emailArg = args[0] as String
            val passwordArg = args[1] as String
            api.authenticateWithEmailAndPassword(emailArg, passwordArg) { result: Result<IdxResponse?> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startInteractionCodeFlow$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val emailArg = args[0] as String?
            val remidiationArg = args[1] as String
            api.startInteractionCodeFlow(emailArg, remidiationArg) { result: Result<IdxResponse?> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startSMSPhoneEnrollment$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val phoneNumberArg = args[0] as String
            api.startSMSPhoneEnrollment(phoneNumberArg) { result: Result<Boolean> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.continueSMSPhoneEnrollment$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val passcodeArg = args[0] as String
            api.continueSMSPhoneEnrollment(passcodeArg) { result: Result<Boolean> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.continueWithGoogleAuthenticator$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val codeArg = args[0] as String
            api.continueWithGoogleAuthenticator(codeArg) { result: Result<IdxResponse?> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.continueWithEmailCode$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val codeArg = args[0] as String
            api.continueWithEmailCode(codeArg) { result: Result<IdxResponse?> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.sendEmailCode$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.sendEmailCode() { result: Result<Unit> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                reply.reply(wrapResult(null))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startUserEnrollmentFlow$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val firstNameArg = args[0] as String
            val lastNameArg = args[1] as String
            val emailArg = args[2] as String
            api.startUserEnrollmentFlow(firstNameArg, lastNameArg, emailArg) { result: Result<Boolean> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.recoverPassword$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val identifierArg = args[0] as String
            api.recoverPassword(identifierArg) { result: Result<IdxResponse> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.getIdxResponse$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.getIdxResponse() { result: Result<IdxResponse?> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.cancelCurrentTransaction$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.cancelCurrentTransaction() { result: Result<Boolean> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.getRemidiations$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.getRemidiations() { result: Result<List<String>> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.getRemidiationsFields$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val remidiationArg = args[0] as String
            val fieldsArg = args[1] as String?
            api.getRemidiationsFields(remidiationArg, fieldsArg) { result: Result<List<String>> ->
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
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.getRemidiationAuthenticators$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val remidiationArg = args[0] as String
            val fieldsArg = args[1] as String?
            api.getRemidiationAuthenticators(remidiationArg, fieldsArg) { result: Result<List<String>> ->
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
