package com.perfect.contacts.perfect_contacts

import android.content.Context
import android.content.pm.PackageManager
import android.provider.ContactsContract
import androidx.core.content.ContextCompat
import com.google.i18n.phonenumbers.PhoneNumberUtil
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import java.util.Locale

class PerfectContactsPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private val phoneUtil by lazy { PhoneNumberUtil.getInstance() }
    private val pluginScope = CoroutineScope(Dispatchers.IO)

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "perfect_contacts")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "getContacts") {
            if (ContextCompat.checkSelfPermission(
                    context,
                    android.Manifest.permission.READ_CONTACTS
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                result.error("PERMISSION_DENIED", "Contacts permission not granted", null)
                return
            }

            // Run in background thread
            pluginScope.launch {
                try {
                    val contacts = getAllContactsFast()
                    withContext(Dispatchers.Main) {
                        result.success(contacts)
                    }
                } catch (e: Exception) {
                    withContext(Dispatchers.Main) {
                        result.error("CONTACT_ERROR", e.localizedMessage, null)
                    }
                }
            }
        } else {
            result.notImplemented()
        }
    }

    private fun getAllContactsFast(): List<Map<String, String>> {
        val contacts = mutableListOf<Map<String, String>>()

        val projection = arrayOf(
            ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME,
            ContactsContract.CommonDataKinds.Phone.NUMBER,
            ContactsContract.CommonDataKinds.Phone.CONTACT_ID
        )

        val cursor = context.contentResolver.query(
            ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
            projection,
            null,
            null,
            null
        )

        cursor?.use {
            val nameIndex = it.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME)
            val numberIndex = it.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER)

            while (it.moveToNext()) {
                val fullName = it.getString(nameIndex) ?: ""
                val phoneNumber = it.getString(numberIndex)?.trim() ?: ""

                if (phoneNumber.isEmpty()) continue

                var countryCode = ""
                var countryName = ""

                try {
                    val parsed = phoneUtil.parse(phoneNumber, "UZ")
                    countryCode = "+${parsed.countryCode}"
                    val region = phoneUtil.getRegionCodeForCountryCode(parsed.countryCode)
                    countryName = Locale("", region ?: "").displayCountry
                } catch (_: Exception) {
                    // skip invalid numbers silently
                }

                contacts.add(
                    mapOf(
                        "fullName" to fullName,
                        "firstName" to "",
                        "lastName" to "",
                        "phoneNumber" to phoneNumber,
                        "countryCode" to countryCode,
                        "countryName" to countryName
                    )
                )
            }
        }

        return contacts
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        pluginScope.cancel()
    }
}