//
//  EmailClientHelper.swift
//
//
//  Created by Ahnaf Mahmud on 22/04/2024.
//

#if canImport(UIKit)
import UIKit
#endif

public class EmailClientHelper {

    /// An array of available email clients on the device
    public static var availableClients: [EmailClient] {
        var clients: [EmailClient] = []
        
        #if os(iOS) || os(visionOS)
        for client in EmailClient.allCases {
            if isClientAvailable(client) {
                clients.append(client)
            }
        }
        #endif
        
        return clients
    }
    
    
    /// Checks whether a specific client is available on the device
    /// - Parameter client: The email client to check
    /// - Returns: Whether the client is available
    public static func isClientAvailable(_ client: EmailClient) -> Bool {
        #if os(iOS) || os(visionOS)
        let urlProtocol = URL(string: "\(client.rawValue)://")
        
        if let urlProtocol = urlProtocol, UIApplication.shared.canOpenURL(urlProtocol) {
            return true
        } else {
            return false
        }
        #else
        return false
        #endif
    }
    
    /// Send an email using the specified email client
    /// - Parameters:
    ///   - client: The email client to use
    ///   - to: The email address to send to
    ///   - subject: The email subject
    ///   - body: The email body
    public static func sendEmail(client: EmailClient, to: String, subject: String, body: String) {
        #if os(iOS) || os(visionOS)
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        var url: URL?
        
        for client in EmailClient.allCases {
            switch client {
            case .gmail:
                url = URL(string: "googlegmail://co?to=\(to)&subject=\(encodedSubject)&body=\(encodedBody)")
            case .outlook:
                url = URL(string: "ms-outlook://compose?to=\(to)&subject=\(encodedSubject)&body=\(encodedBody)")
            case .yahooMail:
                url = URL(string: "ymail://mail/compose?to=\(to)&subject=\(encodedSubject)&body=\(encodedBody)")
            }
        }
        
        if let url {
            UIApplication.shared.open(url)
        }
        #endif
    }
}
