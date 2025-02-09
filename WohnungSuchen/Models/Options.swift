//
//  Options.swift
//  DetectChanges
//
//  Created by Yuriy Gudimov on 09.04.2023.
//

import Foundation

enum SavingKeys: String {
    case roomsMin
    case roomsMax
    case areaMin
    case areaMax
    case rentMin
    case rentMax
    case updateTime
    case soundIsOn
    case saga
    case vonovia
}

final class Options {
    var roomsMin: Int
    var roomsMax: Int
    var areaMin: Int
    var areaMax: Int
    var rentMin: Int
    var rentMax: Int
    var updateTime: Int
    var soundIsOn: Bool
    var landlords: [String: Bool]

    init() {
        self.roomsMin = 0
        self.roomsMax = 0
        self.areaMin = 0
        self.areaMax = 0
        self.rentMin = 0
        self.rentMax = 0
        self.updateTime = 30
        self.soundIsOn = true
        self.landlords = [:]
    }

    func loadSavedDefaults() {
        roomsMin = UserDefaults.standard.object(forKey: SavingKeys.roomsMin.rawValue) as? Int ?? DefaultOptions.roomsMin
        roomsMax = UserDefaults.standard.object(forKey: SavingKeys.roomsMax.rawValue) as? Int ?? DefaultOptions.roomsMax
        areaMin = UserDefaults.standard.object(forKey: SavingKeys.areaMin.rawValue) as? Int ?? DefaultOptions.areaMin
        areaMax = UserDefaults.standard.object(forKey: SavingKeys.areaMax.rawValue) as? Int ?? DefaultOptions.areaMax
        rentMin = UserDefaults.standard.object(forKey: SavingKeys.rentMin.rawValue) as? Int ?? DefaultOptions.rentMin
        rentMax = UserDefaults.standard.object(forKey: SavingKeys.rentMax.rawValue) as? Int ?? DefaultOptions.rentMax
        updateTime = UserDefaults.standard.object(forKey: SavingKeys.updateTime.rawValue) as? Int ?? DefaultOptions.updateTime
        soundIsOn = UserDefaults.standard.object(forKey: SavingKeys.soundIsOn.rawValue) as? Bool ?? DefaultOptions.soundIsOn

        landlords = [ SavingKeys.saga.rawValue: UserDefaults.standard.object(forKey: SavingKeys.saga.rawValue) as? Bool ?? DefaultOptions.landlords[SavingKeys.saga.rawValue]!,
                      SavingKeys.vonovia.rawValue: UserDefaults.standard.object(forKey: SavingKeys.vonovia.rawValue) as? Bool ?? DefaultOptions.landlords[SavingKeys.vonovia.rawValue]!
                    ]
    }

    func isEqualToUserDefaults() -> Bool {
        guard let defaultRoomsMin = UserDefaults.standard.object(forKey: SavingKeys.roomsMin.rawValue) as? Int,
              let defaultRoomsMax = UserDefaults.standard.object(forKey: SavingKeys.roomsMax.rawValue) as? Int,
              let defaultAreaMin = UserDefaults.standard.object(forKey: SavingKeys.areaMin.rawValue) as? Int,
              let defaultAreaMax = UserDefaults.standard.object(forKey: SavingKeys.areaMax.rawValue) as? Int,
              let defaultRentMin = UserDefaults.standard.object(forKey: SavingKeys.rentMin.rawValue) as? Int,
              let defaultRentMax = UserDefaults.standard.object(forKey: SavingKeys.rentMax.rawValue) as? Int,
              let defaultUpdateTime = UserDefaults.standard.object(forKey: SavingKeys.updateTime.rawValue) as? Int,
              let defaultSoundIsOn = UserDefaults.standard.object(forKey: SavingKeys.soundIsOn.rawValue) as? Bool,
              let defaultLandlords = getLandlordsFromUserDefaults() else { return false }

        return self.roomsMin == defaultRoomsMin && self.roomsMax == defaultRoomsMax &&
        self.areaMin == defaultAreaMin && self.areaMax == defaultAreaMax &&
        self.rentMin == defaultRentMin && self.rentMax == defaultRentMax &&
        self.updateTime == defaultUpdateTime && self.soundIsOn == defaultSoundIsOn && self.landlords == defaultLandlords
    }

    private func getLandlordsFromUserDefaults() -> [String: Bool]? {
        var landlordsDict: [String: Bool] = [:]
        for (key, _) in DefaultOptions.landlords {
            if let value = UserDefaults.standard.object(forKey: key) as? Bool {
                landlordsDict[key] = value
            } else { return nil }
        }
        return landlordsDict
    }

}
