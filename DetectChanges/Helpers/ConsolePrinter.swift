//
//  ConsolePrinter.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 12.03.2023.
//

import UIKit

class ConsolePrinter {
    
    static var shared = ConsolePrinter()
    private let startSign = " → "
    private let successSign = "✅ "
    private let nothingNewSign = "☑️ "
    private let errorSign = "❌ "
    private let urlSign = "🔗 "
    private let descriptionSign = "🔍 "
    private let apartmentNameSign = "➡️ "
    private let streetSign = "📍 "
    
    private init() {}
    
    private func postTime() -> String {
        let currentTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: currentTime)
    }
    
//    func postDebug(message: String) {
//        DispatchQueue.main.async {
//            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//               let window = scene.windows.first,
//               let viewController = window.rootViewController as? ViewController {
//                viewController.consoleTextView.text += "\(self.postTime())\(self.startSign)\(message)\n"
//            }
//        }
//    }
    
    func foundNew(_ apartment: Apartment) -> String {
        let result =    postTime() + startSign + successSign +
                        apartmentNameSign + "\(apartment.title)\n" +
                        descriptionSign + "Rooms: \(apartment.rooms), " + "m2: \(apartment.area), " + "€: \(apartment.rent)" + "\n" +
                        streetSign + "Street: \(apartment.street)" + "\n" +
                        urlSign + "\(apartment.externalLink)" + "\n"
        return result
    }
    
    func notFound() -> String {
        postTime() + startSign + nothingNewSign + "Nothing new was found" + "\n"
    }
    
    func errorMakingGoogleURL() -> String {
        postTime() + startSign + errorSign + "Error: unable to construct Google Maps URL" + "\n"
    }
}
