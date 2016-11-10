//
//  DataStructures.swift
//  BygApp
//
//  Created by Prince Agrawal on 02/08/16.
//  Copyright © 2016 Book Your Game Fitness Pvt. Ltd. All rights reserved.
//

import Foundation

enum DataErrorCode:Int {
    case NoDataForLocation = 1000
    case NoDataForFilter = 1001
}

struct Category {
    var categoryID: String
    var name: String
    var gyms:Set<String>
    var nextPage: Int
    var previousPage: Int
    
    init(categoryID: String, name: String, gyms: Set<String>, nextPage: Int = 1, previousPage: Int = 0) {
        self.categoryID = categoryID
        self.name = name
        self.gyms = gyms
        self.nextPage = nextPage
        self.previousPage = previousPage
    }
}

struct Gym {
    var gymID: String
    var name: String
    var logoURL: String
    var address: String
    var distance: Double
    var imageURL: String
    var startingPrice: Double
    var rating: String
    var isBYGPreferred: Bool
    var isPopular: Bool?
    var latitude: Double
    var longitude: Double
    var timings: String
    var ratings: [Rating]?
    var fullAddress: String
    var services: GymService?
}

enum ServiceType:String {
    case Workout
    case Groupex
}

protocol Service {
    var serviceID: String { get }
    var name: String { get }
    var type: ServiceType { get }
    var categoryID: String { get }
    var price: Double { get }
    var offerPrice: Double { get }
}

private struct ServiceFields: Service {
    let serviceID: String
    let name: String
    let type: ServiceType
    let categoryID: String
    let price: Double
    let offerPrice: Double
    
    init(serviceDict: JSONDictionary) {
        serviceID = serviceDict[APIKeys.kServiceID] as! String
        name = serviceDict[APIKeys.kServiceName] as! String
        let categoryType = serviceDict[APIKeys.kServiceType] as! String
        type = ServiceType(rawValue: categoryType)!
        categoryID = serviceDict[APIKeys.kCategoryID] as! String
        price = serviceDict[APIKeys.kPrice] as! Double
        offerPrice = serviceDict[APIKeys.kOfferPrice] as! Double
    }
}

struct MembershipService: Service {
    let serviceID: String
    let name: String
    let type: ServiceType
    let categoryID: String
    let price: Double
    let offerPrice: Double
    
    let duration: String
    
    init(serviceDict: JSONDictionary) {
        let service = ServiceFields(serviceDict: serviceDict)
        serviceID = service.serviceID
        name = service.name
        type = service.type
        categoryID = service.categoryID
        price = service.price
        offerPrice = service.offerPrice
        duration = serviceDict[APIKeys.kDuration] as! String
    }
    
}

struct ScheduledService: Service {
    let serviceID: String
    let name: String
    let type: ServiceType
    let categoryID: String
    let price: Double
    let offerPrice: Double
    
    let scheduleID: String
    let startTime: String
    let endTime: String
    
    init(serviceDict: JSONDictionary) {
        let service = ServiceFields(serviceDict: serviceDict)
        serviceID = service.serviceID
        name = service.name
        type = service.type
        categoryID = service.categoryID
        price = service.price
        offerPrice = service.offerPrice
        scheduleID = serviceDict[APIKeys.kScheduleID] as! String
        let startTimeInDouble = serviceDict[APIKeys.kStartTime] as! Double
        startTime = startTimeInDouble.bygTimeString()
        let endTimeInDouble = serviceDict[APIKeys.kEndTime] as! Double
        endTime = endTimeInDouble.bygTimeString()
    }
}

struct Session {
    let name: String
    let schedules:[Day:[ScheduledService]]?
    let lowestPrice: Double
}

struct Membership {
    let name: String
    let schedules:[MembershipService]?
    let lowestPrice: Double
}

struct GymService {
    var memberships: [Membership]? = nil
    var groupClasses:[Session]? = nil
    var gymFloor: [Session]? = nil
}


struct Filter {
    let isBYGPreferred: Bool?
    let isPopular: Bool?
    let isOfferSpecific: Bool?
    let ratings: Int?
    let distance: Int?
    let priceRange:[Int]?
    let categories:[Category]?
}


struct CartItem {
    var gymName: String
    var gymAddress: String
    var gymLogo: String
    var serviceType: String
    var startDate: Double
    var endDate: Double?
    var startTime: Double?
    var endTime: Double?
    var amount: Double
    var quantity: Int
    var serviceId: String
    var scheduleId: String?
    var bookingType: String
}


struct Coupon {
    var couponTitle: String
    var couponShortTitle: String
    var couponDescription: String
    var couponId: String
}

struct Offer {
    var imageURL: String
}

struct Rating {
    var userName: String
    var rating: Int
    var comment: String?
    var date: Double
}
