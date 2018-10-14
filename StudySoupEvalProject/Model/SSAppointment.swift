//
//  SSAppointment.swift
//  StudySoupEvalProject
//
//  Created by Max on 10/13/18.
//  Copyright © 2018 Max. All rights reserved.
//

import Foundation
import ObjectMapper


class Schedule: Mappable {
    var availableAppointments: [Appointment]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        availableAppointments <- map["available"]
    }
}

class Appointment: Mappable {
    var date: String?
    var times: [Int]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        date = map.JSON.keys.first
        guard let currentDate = date else {
            times = nil
            return
        }
        times <- map[currentDate]
    }
}
