//
//  PassioExternalConnector.swift
//
//  Created by zvika on 1/21/20.
//  Copyright © 2021 Passio Inc. All rights reserved.
//

import UIKit
#if canImport(PassioNutritionAISDK)
import PassioNutritionAISDK
#endif

#if canImport(PassioAppModule)
import PassioAppModule
#endif

class PassioExternalConnector {

    // MARK: Shared Object
    public class var shared: PassioExternalConnector {
        if Static.instance == nil {
            Static.instance = PassioExternalConnector()
        }
        return Static.instance!
    }
    private struct Static {
        fileprivate static var instance: PassioExternalConnector?
    }

    var firebaseMode = false
    // private let firebase: FirebasePersistence
    private init() {
    // firebase = FirebasePersistence.shared
    }
    public func shutDown() {
        Static.instance = nil
    }

    private let fileManager = FileManager.default

    // TODO: Add your Passio Key here
    var passioKeyForSDK: String {
        #error("To obtain a key please sign up at https://www.passio.ai/nutrition-ai.  Delete this line before building.")
    }

    var bundleForModule: Bundle {
        Bundle(for: PassioInternalConnector.self)
    }

    var offsetFoodEditor: CGFloat {
        10
    }

    private var urlForFavoritesDirectory: URL? {
        guard let appSupportDir = try? fileManager.url(for: .applicationSupportDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true) else {
            return nil
        }
        let dirURL = appSupportDir.appendingPathComponent("passiofavorites", isDirectory: true)
        do {
            try fileManager.createDirectory(atPath: dirURL.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("can't create directory at \(dirURL)")
        }
        return dirURL
    }

    private var urlForUserFoodsDirectory: URL? {
        guard let appSupportDir = try? fileManager.url(for: .applicationSupportDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true) else {
            return nil
        }
        let dirURL = appSupportDir.appendingPathComponent("passioUserFoods", isDirectory: true)
        do {
            try fileManager.createDirectory(atPath: dirURL.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("can't create directory at \(dirURL)")
        }
        return dirURL
    }

    private var urlForUserFoodImagesDirectory: URL? {
        guard let appSupportDir = try? fileManager.url(for: .applicationSupportDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true) else {
            return nil
        }
        let dirURL = appSupportDir.appendingPathComponent("passioUserFoodImages", isDirectory: true)
        do {
            try fileManager.createDirectory(atPath: dirURL.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("can't create directory at \(dirURL)")
        }
        return dirURL
    }

    private var urlForUserProfileModel: URL? {
        guard let appSupportDir = try? fileManager.url(for: .applicationSupportDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true) else {
            return nil
        }
        let dirURL = appSupportDir.appendingPathComponent("userProfile")// appendingPathComponent("userProfileModel.json")
        do {
            try fileManager.createDirectory(atPath: dirURL.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("can't create directory at \(dirURL)")
        }
        return dirURL.appendingPathComponent("userProfileModel.json")
    }


    private func locallySaveUserProfileModel(userProfileModel: UserProfileModel) {
        guard let dirURL = urlForUserProfileModel else { return }
        do {
            let encodedData = try? JSONEncoder().encode(userProfileModel)
            //  print("url.path   ", url.path)
            if fileManager.fileExists(atPath: dirURL.path ) {
                try fileManager.removeItem(atPath: dirURL.path)
            }
            do {
                try encodedData?.write(to: dirURL)
                return
            } catch {
                return
            }
        } catch {
            return
        }
    }

    private func locallyGetUserProfileModel() -> UserProfileModel {
        let userProfile = UserProfileModel()
        guard let dirURL = urlForUserProfileModel else { return userProfile }
        do {
            let decoder = JSONDecoder()
            if let data = try? Data(contentsOf: dirURL),
               let profile = try? decoder.decode(UserProfileModel.self, from: data) {
                return profile
            }
        }
        return userProfile
    }

    private func locallyUpdateRecored(record: FoodRecordV3, url: URL) -> Bool {
        do {
            let encodedData = try? JSONEncoder().encode(record)
            //  print("url.path   ", url.path)
            if fileManager.fileExists(atPath: url.path ) {
                try fileManager.removeItem(atPath: url.path)
            }
            do {
                try encodedData?.write(to: url)
                return true
            } catch {
                return false
            }
        } catch {
            return false
        }
    }

    private func locallyUpdateUserFood(image: UIImage, url: URL) -> Bool {
        do {
            let encodedImageData = image.pngData()
            //  print("url.path   ", url.path)
            if fileManager.fileExists(atPath: url.path) {
                try fileManager.removeItem(atPath: url.path)
            }
            do {
                try encodedImageData?.write(to: url)
                return true
            } catch {
                return false
            }
        } catch {
            return false
        }
    }

    private func locallyDeleteRecord(record: FoodRecordV3, url: URL) -> Bool {
        if fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.removeItem(atPath: url.path)
                return true
            } catch {
                print("No record was found")
                return false
            }
        }
        return false
    }

    private func locallyDeleteUserFood(url: URL) -> Bool {
        if fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.removeItem(atPath: url.path)
                return true
            } catch {
                print("No record was found")
                return false
            }
        }
        return false
    }

    private func getRecordsFor(url: URL) -> [FoodRecordV3] {
        var foodRecords = [FoodRecordV3]()
        do {
            let directoryContents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            // print("directoryContents = \(directoryContents)")
            for fileURL in directoryContents {
                if let data = try? Data(contentsOf: fileURL) {
                    let decoder = JSONDecoder()
                    let foodRecord = try decoder.decode(FoodRecordV3.self, from: data)
                    foodRecords.append(foodRecord)
                }
            }
            return foodRecords
        } catch {
            return foodRecords
        }
    }

    private func getUserFoodImageFor(id: String, url: URL) -> UIImage {
        guard let dirURL = urlForUserFoodImagesDirectory else { return UIImage() }
        do {
            let imagePath = dirURL.appendingPathComponent("\(id).png", isDirectory: false)
            if let imageData = try? Data(contentsOf: imagePath),
               let foodImage = UIImage(data: imageData) {
                return foodImage
            }
        }
        return UIImage()
    }

    private func urlForSaving(userFoods: FoodRecordV3) -> URL? {
        guard let dirURL = urlForUserFoodsDirectory else { return nil }
        let finalURL = dirURL.appendingPathComponent(userFoods.uuid.replacingOccurrences(of: "-", with: "") + ".json")
        return finalURL
    }

    private func urlForSaving(imageId: String) -> URL? {
        guard let dirURL = urlForUserFoodImagesDirectory else { return nil }
        let finalURL = dirURL.appendingPathComponent("\(imageId)" + ".png")
        return finalURL
    }

    fileprivate func urlForSaving(record: FoodRecordV3) -> URL? {
        let date = record.createdAt
        guard let urlForFile = urlForSavingFiles(date: date) else {
            return nil
        }
        let finalURL = urlForFile.appendingPathComponent(record.uuid.replacingOccurrences(of: "-", with: "") + ".json")
        return finalURL
    }

    fileprivate func urlForSavingFiles(date: Date) -> URL? {
        guard let appSupportDir = try? fileManager.url(for: .applicationSupportDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true) else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let directory = dateFormatter.string(from: date)
        let dirURL = appSupportDir.appendingPathComponent("date" + directory, isDirectory: true)
        do {
            try fileManager.createDirectory(atPath: dirURL.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("can't create directory at \(dirURL)")
        }
        return dirURL
    }



    private func urlForSaving(favorite: FoodRecordV3) -> URL? {
        guard let dirURL = urlForFavoritesDirectory else {
            return nil}
        let finalURL = dirURL.appendingPathComponent(favorite.uuid.replacingOccurrences(of: "-", with: "") + ".json")
        return finalURL
    }

    public func getRecordsForDate(date: Date) -> [FoodRecordV3] {
        guard let urlForDate = urlForSavingFiles(date: date) else { return [] }
        let records = getRecordsFor(url: urlForDate)
        return records
    }

    deinit {
        print("deinit PassioExternalConnector")
    }
}

// MARK: - PassioConnector
extension PassioExternalConnector: PassioConnector {

    func updateUserProfile(userProfile: UserProfileModel) {
        if Custom.useFirebase, firebaseMode {
            // Save to Firebase
        } else {
            locallySaveUserProfileModel(userProfileModel: userProfile)
        }
    }

    func fetchUserProfile(completion: @escaping (UserProfileModel?) -> Void) {
        if Custom.useFirebase, firebaseMode {
            // Fetch from Firebase
        } else {
            completion(locallyGetUserProfileModel())
        }
    }

    func updateRecord(foodRecord: FoodRecordV3, isNew: Bool) {
        if Custom.useFirebase, firebaseMode {
            // Update to Firebase
        } else if let url = urlForSaving(record: foodRecord) {
            _ = locallyUpdateRecored(record: foodRecord, url: url)
        }
    }

    func deleteRecord(foodRecord: FoodRecordV3) {
        if Custom.useFirebase, firebaseMode {
            // Delete from Firebase
        } else if let url = urlForSaving(record: foodRecord) {
            _ = locallyDeleteRecord(record: foodRecord, url: url)
        }
    }

    func fetchDayRecords(date: Date, completion: @escaping ([FoodRecordV3]) -> Void) {
        if Custom.useFirebase, firebaseMode {
            // Fetch from Firebase
        } else if let urlForDate = urlForSavingFiles(date: date) {
            let records = getRecordsFor(url: urlForDate)
            completion(records)
        } else {
            completion([])
        }
    }

    func fetchDayLogFor(fromDate: Date,
                        toDate: Date,
                        completion: @escaping ([DayLog]) -> Void){

        if Custom.useFirebase, firebaseMode {

        } else {
            var dayLogs = [DayLog]()
            for time in stride(from: fromDate.timeIntervalSince1970,
                               through: toDate.timeIntervalSince1970,
                               by: 86400) {
                let currentDate = Date(timeIntervalSince1970: time)
                fetchDayRecords(date: currentDate) { (foodRecords) in
                    let daylog = DayLog(date: currentDate, records: foodRecords)
                    dayLogs.append(daylog)
                    completion(dayLogs)
                }
            }
        }
    }

    func fetchDayLogRecursive(fromDate: Date,
                              toDate: Date,
                              currentLogs: [DayLog] = [],
                              completion: @escaping ([DayLog]) -> Void) {

        guard fromDate <= toDate else {
            completion(currentLogs)
            return
        }

        fetchDayRecords(date: fromDate) { (foodRecords) in
            let daylog = DayLog(date: fromDate, records: foodRecords)
            var updatedLogs = currentLogs
            updatedLogs.append(daylog)

            // Recursive call with next day
            let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: fromDate)!
            self.fetchDayLogRecursive(fromDate: nextDate,
                                      toDate: toDate,
                                      currentLogs: updatedLogs,
                                      completion: completion)
        }
    }

    func updateUserFood(record: FoodRecordV3, isNew: Bool) {
        if let url = urlForSaving(userFoods: record) {
            _ = locallyUpdateRecored(record: record, url: url)
        }
    }

    func deleteUserFood(record: FoodRecordV3) {
        if let url = urlForSaving(userFoods: record) {
            _ = locallyDeleteRecord(record: record, url: url)
        }
    }

    func deleteAllUserFood() {
        if let dirURL = urlForUserFoodsDirectory {
            do {
                try fileManager.removeItem(at: dirURL)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func fetchUserFoods(barcode: String, completion: @escaping ([FoodRecordV3]) -> Void) {
        if let url = urlForUserFoodsDirectory {
            let userFoods = getRecordsFor(url: url)
            completion(userFoods.filter { $0.barcode == barcode })
        }
    }

    func fetchAllUserFoods(completion: @escaping ([FoodRecordV3]) -> Void) {
        if let url = urlForUserFoodsDirectory {
            let userFoods = getRecordsFor(url: url)
            completion(userFoods)
        }
    }

    func updateUserFoodImage(with id: String, image: UIImage) {
        if let url = urlForSaving(imageId: id) {
            _ = locallyUpdateUserFood(image: image, url: url)
        }
    }

    func deleteUserFoodImage(with id: String) {
        if let url = urlForSaving(imageId: id) {
            _ = locallyDeleteUserFood(url: url)
        }
    }

    func fetchUserFoodImage(with id: String, completion: @escaping (UIImage) -> Void) {
        if let url = urlForUserFoodImagesDirectory {
            completion(getUserFoodImageFor(id: id, url: url))
        }
    }

    func updateFavorite(foodRecord: FoodRecordV3) {
        if Custom.useFirebase, firebaseMode {
            // Save to Firebase
        } else if let url = urlForSaving(favorite: foodRecord) {
            _ = locallyUpdateRecored(record: foodRecord, url: url)
        }
    }

    func deleteFavorite(foodRecord: FoodRecordV3) {
        if Custom.useFirebase, firebaseMode {
            // Delete from Firebase
        } else if let url = urlForSaving(favorite: foodRecord) {
            _ = locallyDeleteRecord(record: foodRecord, url: url)
        }
    }

    func fetchFavorites(completion: @escaping ([FoodRecordV3]) -> Void) {
        if Custom.useFirebase, firebaseMode {
            // Fetch from Firebase
        } else if let url = urlForFavoritesDirectory {
            let favorites = getRecordsFor(url: url)
            completion(favorites)
        } else {
            completion([])
        }
    }
}

