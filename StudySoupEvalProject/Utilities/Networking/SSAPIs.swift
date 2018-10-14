//
//  SSAPIs.swift
//  StudySoupEvalProject
//
//  Created by Max on 10/13/18.
//  Copyright © 2018 Max. All rights reserved.
//

import Foundation

class API: NSObject {
     /*
     API endpoint for appointment management
     GET: returns upcoming appointments in datetimes e.x. {"available":[{"2018-10-12":[8,14,16]},{"2018-10-13":[8,14,19]},{"2018-10-14":[10,13,19]}]}
     POST: creates an appointment. Params: {guid: {device identifier}, appointment: {datetime}}
     PUT: updates an existing appointment. Params: {appointment: {datetime}, new_appointment: {datetime}}
     DELETE: destroys an appointment. Params: {appointment: {datetime}}
     */
    static let APPOINTMENT_URL = "https://tutor.studysoup.com/api/schedule"
}
