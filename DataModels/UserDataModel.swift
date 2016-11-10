//
//  UserDataModel.swift
//  BygApp
//
//  Created by Prince Agrawal on 30/08/16.
//  Copyright © 2016 Book Your Game Fitness Pvt. Ltd. All rights reserved.
//

import Foundation

class UserDataModel {
    
    static var notificationsDictionary = [kTransactions:true,
                                          kBygMoney: true,
                                          kBygFriends:true,
                                          kOffers:true,
                                          kMessages:true]
    
    struct ValueDict {
        var dataValue: String
        var isOn: Bool
    }
    
    static var LifeStyleSelectedIndex=0
    static var FitnessLevelSelectedIndex=0
    static var LifeStyleArray = ["SEDENTARY","LIGHT ACTIVE","ACTIVE","VERY ACTIVE"]
    static var FitnessLevelArray =  ["OUT OF SHAPE","AVERAGE","ATHLETIC","ELITE"]
    
    static var GoalDict = [kFatLoss: false,
                           kMuscleGain: false,
                           kStrengthGain: false,
                           kStaminaBoost: false,
                           kInjuryRecovery: false,
                           kSkillEnhancement: false]
    
    static var PreferredWorkoutDict = [kWeightTraining: false,
                                       kFunctionalTraining: false,
                                       kAerobicActivities: false,
                                       kSportsFitness: false,
                                       kSpritualFitness: false,
                                       kOutdoorFitness: false]
    
    static var HeightDict = [kHeight: "",
                             kUnit: "cms"]
    
    static var WeightDict = [kWeight: "",
                             kIdealWeight: "",
                             kUnit: "kgs"]
    
    
    static var userDetailsDictionary = [kUserName: "",
                                        kUserId: "",
                                        kEmail: "",
                                        kEmailVerified: false,
                                        kCorporateEmailVerified: false,
                                        kPhoneNumberVerified: false,
                                        kImageURLString: "",
                                        kPhoneNumber: "",
                                        kWalletAmount: 0.0,
                                        kReferalCode: "",
                                        kReferredBy: 0.0,
                                        kCorporateEmail:"",
                                        kLifeStyle:"",
                                        kFitnessLevel:"",
                                        kRelation:"",
                                        kGender:"M",
                                        kWorkoutExperience:false,
    ]
    
}
