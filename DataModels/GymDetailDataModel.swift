//
//  GymDetailDataModel.swift
//  BygApp
//
//  Created by Prince Agrawal on 27/07/16.
//  Copyright © 2016 Book Your Game Fitness Pvt. Ltd. All rights reserved.
//

import Foundation

class GymDetailDataModel {
    
    static var ongoingOffers = [Offer]()
    static var gyms = [String: Gym]()
    static var recentGyms: [String: String]?
    static var searchedGyms: [String: Gym]?
    static var categories = [Category](arrayLiteral: Category(categoryID: "0000", name: "All", gyms: [])) {
        didSet {
            if categories.count == 0 {
                self.categories = [Category(categoryID: "0000", name: "All", gyms: [])]
            }
        }
    }
    
    static var appliedFilter: Filter? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(kFilterChangeNotification, object: nil)
        }
    }
    
    class func parseSearchGymsResponse(response: JSONDictionary) {
        searchedGyms = [String: Gym]()
        if let gymArray = response[APIKeys.kGyms] as? JSONArray {
            searchedGyms = parsedGymListFromResponse(gymArray)
        }
    }
    
    class func updateGymListFromResponse(response: JSONArray, categoryIndex: Int, nextPage:Int, prevPage:Int) {
        let sortedResponse = response.sort { ($0[APIKeys.kDistance] as! Double) < ($1[APIKeys.kDistance] as! Double) }
        for gym in sortedResponse {
            if let gymObj = parsedGymFromResponse(gym) {
                gyms.updateValue(gymObj, forKey: gymObj.gymID)
                if categoryIndex >= 0 {
                    self.categories[categoryIndex].gyms.insert(gymObj.gymID)
                    self.categories[categoryIndex].nextPage = nextPage
                    self.categories[categoryIndex].previousPage = prevPage
                }
            }
        }
    }
    
    class func parsedGymListFromResponse(response: JSONArray) -> [String: Gym] {
        let sortedResponse = response.sort { ($0[APIKeys.kDistance] as! Double) < ($1[APIKeys.kDistance] as! Double) }
        var newGyms = [String: Gym]()
        for gym in sortedResponse {
            if let gymObj = parsedGymFromResponse(gym) {
                newGyms.updateValue(gymObj, forKey: gymObj.gymID)
            }
        }
        return newGyms
    }
    
    class func parsedGymFromResponse(response: JSONDictionary) -> Gym? {
        let gym: Gym?
        
        let name = response[APIKeys.kName] as? String ?? ""
        let logoUrl = response[APIKeys.kLogoURL] as? String ?? ""
        let address = response[APIKeys.kPlace] as? String ?? ""
        let distance = response[APIKeys.kDistance] as? Double ?? 0
        let imageURL = response[APIKeys.kBannerImageURL] as? String ?? ""
        let startingPrice = response[APIKeys.kLowestPrice] as? Double ?? 0
        let rating = response[APIKeys.kRating] as? Double ?? 0
        let latitude = response[APIKeys.kLat] as? Double ?? 0
        let longitude = response[APIKeys.kLng] as? Double ?? 0
        let isBYGPreferred = response[APIKeys.kPreferred] as? Bool ?? false
        let isPopular = response[APIKeys.kPopular] as? Bool ?? false
        let fullAddress = response[APIKeys.kAddress] as? String ?? ""
        
        var infoString = "Monday: Closed, \nTuesday: Closed, \nWednesday: Closed, \nThursday: Closed, \nFriday: Closed, \nSaturday: Closed, \nSunday: Closed"
        if let timings = response[APIKeys.kTimings] as? JSONDictionary {
            for key in Array(timings.keys) ?? [] {
                
                let values = timings[key] as? [String] ?? [String]()
                var valueString = ""
                for value in values {
                    valueString += "\(value), "
                }
                
                valueString = valueString.substringToIndex(valueString.endIndex.advancedBy(-2))
                infoString = infoString.stringByReplacingOccurrencesOfString("\(key): Closed", withString: "\(key): \(valueString)")
            }
        }
        
        let gymID = response[APIKeys.kID] as? String ?? ""
        
        gym = Gym(gymID: gymID, name: name, logoURL: logoUrl, address: address, distance: distance, imageURL: imageURL, startingPrice: startingPrice, rating: String(abs(rating)), isBYGPreferred: isBYGPreferred, isPopular: isPopular, latitude: latitude, longitude: longitude, timings: infoString, ratings: nil, fullAddress: fullAddress, services: nil)
        
        return gym
    }
    
    class func parseCategoryListFromResponse(response: JSONArray) {
        let sortedResponse = response.sort { ($0[APIKeys.kPriority] as! Int) < ($1[APIKeys.kPriority] as! Int) }
        
        for category in sortedResponse {
            let categoryID = category[APIKeys.kID] as? String ?? ""
            let categoryName = category[APIKeys.kName] as? String ?? ""
            //Setting nextPage to 1 as we need to fetch data again for all categories now.
            let categoryObj = Category(categoryID: categoryID, name: categoryName, gyms: [])
            categories.append(categoryObj)
        }
    }
    
    class func parseGymServicesFromResponse(response: JSONDictionary, gymID: String) {
        
        var groupClasses, gymFloor:[Session]?
        //Parse Gym Floor Services
        if let floorServices = response[APIKeys.kFloor] as? JSONDictionary {
            gymFloor = parseScheduledServicesFromResponse(floorServices)
        }
        
        
        //Parse Group Class Services
        if let groupServices = response[APIKeys.kGroup] as? JSONDictionary {
            groupClasses = parseScheduledServicesFromResponse(groupServices)
            groupClasses = groupClasses?.sort{$0.lowestPrice < $1.lowestPrice}
        }
        
        //Parse Membership services
        var memberships: [Membership]?
        if let membershipServices = response[APIKeys.kMembership] as? JSONDictionary {
            memberships = parseMembershipServicesFromResponse(membershipServices)
            memberships = memberships?.sort{$0.lowestPrice < $1.lowestPrice}
        }
        
        let gymService = GymService(memberships: memberships, groupClasses: groupClasses, gymFloor: gymFloor)
        
        gyms[gymID]?.services = gymService
        
    }
    
    class func parseScheduledServicesFromResponse(response: JSONDictionary) -> [Session] {
        var scheduledServices = [Session]()
        if let sessions = response[APIKeys.kSessions] as? JSONArray {
            for session in sessions {
                
                var scheduleDict = [Day: [ScheduledService]]()
                if let schedules = session[APIKeys.kSchedule] as? JSONArray {
                    for schedule in schedules {
                        var scheduleArray = [ScheduledService]()
                        if let timings = schedule[APIKeys.kTimings] as? JSONArray {
                            for timing in timings {
                                let floorSchedule = ScheduledService(serviceDict: timing)
                                scheduleArray.append(floorSchedule)
                            }
                        }
                        
                        if let day = schedule[APIKeys.kDay] as? String where day != "" {
                            scheduleDict.updateValue(scheduleArray, forKey: Day(rawValue: day.lowercaseString)!)
                        }
                    }
                }
                
                let sessionType = session[APIKeys.kType] as? String ?? ""
                let lowestPrice = session[APIKeys.kLowestPrice] as? Double ?? 0
                let sessionObj = Session(name: sessionType, schedules: scheduleDict, lowestPrice: lowestPrice)
                
                scheduledServices.append(sessionObj)
            }
        }
        return scheduledServices
    }
    
    class func parseMembershipServicesFromResponse(response: JSONDictionary) -> [Membership] {
        
        var memberships = [Membership]()
        if let sessions = response[APIKeys.kSessions] as? JSONArray {
            for session in sessions {
                var serviceArray = [MembershipService]()
                if let schedules = session[APIKeys.kSchedule] as? JSONArray {
                    for schedule in schedules {
                        let membership = MembershipService(serviceDict: schedule)
                        serviceArray.append(membership)
                    }
                }
                
                serviceArray = serviceArray.sort { $0.price < $1.price }
                
                let sessionType = session[APIKeys.kType] as? String ?? ""
                let lowestPrice = session[APIKeys.kLowestPrice] as? Double ?? 0
                memberships.append(Membership(name: sessionType, schedules: serviceArray, lowestPrice: lowestPrice))
            }
            
        }
        
        return memberships
    }
    
    class func parseOffersFromResponse(response: JSONDictionary) {
        ongoingOffers.removeAll()
        if let offers = response[APIKeys.kOffers] as? JSONArray {
            for offer in offers {
                if let imageURL = offer[APIKeys.kImage] as? String {
                    ongoingOffers.append(Offer(imageURL: imageURL))
                }
            }
        }
    }
    
    class func parseGymRatingsFromResponse(response: JSONArray, gymID: String) {
        var ratings = [Rating]()
        for rating in response {
            let username = rating[APIKeys.kUserName] as? String ?? ""
            let ratingValue = rating[APIKeys.kRating] as? Int ?? 0
            let date = rating[APIKeys.kCreatedAt] as? Double ?? 0
            let comment = rating[APIKeys.kComment] as? String
            
            let newRating = Rating(userName: username, rating: ratingValue, comment: comment, date: date)
            ratings.append(newRating)
        }
        
        gyms[gymID]?.ratings = ratings
    }
}