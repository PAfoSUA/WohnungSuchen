//
//  Vonovia.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 02.04.2023.
//

import Foundation
import SwiftSoup

final class Vonovia: Landlord {
    private let networkManager: NetworkManager
    private let vonoviaURL = "https://www.vonovia.de/de-de/immobiliensuche/"
    private let searchURLString = "https://www.wohnraumkarte.de/Api/getImmoList?offset=0&limit=25&orderBy=date_asc&city=Hamburg&rentType=miete&immoType=all&priceMax=1500&sizeMin=20&sizeMax=0&minRooms=1&dachgeschoss=0&erdgeschoss=0&sofortfrei=egal&lift=0&balcony=egal&disabilityAccess=egal&subsidizedHousingPermit=egal&userCookieValue=e64300007d54e2f903e5a62b1a63c39613705590&geoLocation=1"

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchApartmentsList(completion: @escaping (Result<[Apartment], AppError>) -> Void) {
        networkManager.fetchData(urlString: searchURLString) {[weak self] result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                guard let decodedData = try? decoder.decode(VonoviaJson.self, from: data) else {
                    completion(.failure(AppError.landlordError(.vonoviaDecodedDataCreationFailed)))
                    return
                }
                var currentApartments = [Apartment]()
                guard let self = self else { return }
                let time = TimeManager.shared.getCurrentTime()
                for jsonApartment in decodedData.apartments {
                    let link = self.vonoviaURL + jsonApartment.slug.lowercased() + "-" + jsonApartment.wrk_id
                    let area = self.getRoundedInt(from: jsonApartment.groesse)
                    let price = self.getRoundedInt(from: jsonApartment.preis)
                    let rooms = self.getRoundedInt(from: jsonApartment.anzahl_zimmer)

                    let apartment = Apartment(time: time,
                                              title: jsonApartment.titel,
                                              internalLink: link,
                                              street: jsonApartment.strasse,
                                              rooms: rooms,
                                              area: area,
                                              rent: price,
                                              externalLink: link,
                                              company: .vonovia
                    )
                    currentApartments.append(apartment)
                }
                completion(.success(currentApartments))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func getRoundedInt(from stringNumber: String) -> Int {
        guard let double = Double(stringNumber) else { return -1 }
        let roundedDouble = double.rounded()
        return Int(roundedDouble)
    }
}
