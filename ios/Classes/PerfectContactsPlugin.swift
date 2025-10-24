import Flutter
import UIKit
import Contacts
import PhoneNumberKit

public class PerfectContactsPlugin: NSObject, FlutterPlugin {
    private let phoneNumberKit = PhoneNumberKit()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "perfect_contacts", binaryMessenger: registrar.messenger())
        let instance = PerfectContactsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getContacts":
            requestAndFetchContacts(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Request + Fetch Contacts
    private func requestAndFetchContacts(result: @escaping FlutterResult) {
        let store = CNContactStore()
        let authStatus = CNContactStore.authorizationStatus(for: .contacts)

        switch authStatus {
        case .authorized:
            fetchContacts(result: result)
        case .notDetermined:
            store.requestAccess(for: .contacts) { [weak self] granted, error in
                if let error = error {
                    DispatchQueue.main.async {
                        result(FlutterError(code: "PERMISSION_ERROR", message: error.localizedDescription, details: nil))
                    }
                    return
                }
                if granted {
                    self?.fetchContacts(result: result)
                } else {
                    DispatchQueue.main.async {
                        result(FlutterError(code: "PERMISSION_DENIED", message: "Contacts permission not granted", details: nil))
                    }
                }
            }
        case .denied, .restricted:
            result(FlutterError(code: "PERMISSION_DENIED", message: "Contacts permission not granted", details: nil))
        @unknown default:
            result(FlutterError(code: "UNKNOWN_STATUS", message: "Unknown contact permission status", details: nil))
        }
    }

    // MARK: - Core Contact Fetch
    private func fetchContacts(result: @escaping FlutterResult) {
        DispatchQueue.global(qos: .userInitiated).async {
            var contactList: [[String: String]] = []

            let store = CNContactStore()
            let keys: [CNKeyDescriptor] = [
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor,
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName)
            ]

            let request = CNContactFetchRequest(keysToFetch: keys)

            do {
                try store.enumerateContacts(with: request) { contact, _ in
                    guard let phoneValue = contact.phoneNumbers.first?.value.stringValue.trimmingCharacters(in: .whitespacesAndNewlines),
                          !phoneValue.isEmpty else {
                        return
                    }

                    var countryCode = ""
                    var countryName = ""

                    do {
                        let parsed = try self.phoneNumberKit.parse(phoneValue, withRegion: "UZ", ignoreType: true)
                        countryCode = "+\(parsed.countryCode)"
                        if let region = self.phoneNumberKit.mainCountry(forCode: parsed.countryCode) {
                            countryName = Locale.current.localizedString(forRegionCode: region) ?? ""
                        }
                    } catch {
                        // ignore invalid numbers silently
                    }

                    let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
                    let firstName = contact.givenName
                    let lastName = contact.familyName

                    contactList.append([
                        "fullName": fullName,
                        "firstName": firstName,
                        "lastName": lastName,
                        "phoneNumber": phoneValue,
                        "countryCode": countryCode,
                        "countryName": countryName
                    ])
                }

                DispatchQueue.main.async {
                    result(contactList)
                }
            } catch {
                DispatchQueue.main.async {
                    result(FlutterError(code: "CONTACT_FETCH_ERROR", message: error.localizedDescription, details: nil))
                }
            }
        }
    }
}