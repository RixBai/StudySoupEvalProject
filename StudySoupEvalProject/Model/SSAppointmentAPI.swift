//
//  SSAppointmentAPI.swift
//  StudySoupEvalProject
//
//  Created by Max on 10/13/18.
//  Copyright © 2018 Max. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class AppointmentAPI: NSObject {
    /*
     Make a GET call to the appointment api endpoint and returns the available appointments via completionHandler
     @param completionHandler: Completion handler
     */
    func appointments(completionHandler: @escaping(Schedule?) -> Void) {
        Alamofire.request(API.APPOINTMENT_URL, method: .get, encoding: URLEncoding.default, headers: [:]).responseObject { (response: DataResponse<Schedule>) in
            switch response.result {
            case .success:
                // return completionHandler in main UI thread
                DispatchQueue.main.async {
                    completionHandler(response.result.value)
                }
                break
            case .failure(let error):
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
                print(error)
                break
            }
        }
    }
    
    /*
     Make a POST call to the appointment api endpoint to create a new appointment. Returns true via completionHandler if successful, otherwise returns false
     @param guid: Device identifier
     @param appointment: A new appointment to add
     @param completionHandler: Completion handler
     */
    func createAnAppointment(guid: String, appointment: Appointment, completionHandler: @escaping(Bool) -> Void) {
        let params: Parameters = ["guid": guid, "appointment": appointment.date!];
        Alamofire.request(API.APPOINTMENT_URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: [:]).responseObject { (response: DataResponse<Appointment>) in
            switch response.result {
            case .success:
                DispatchQueue.main.async {
                    completionHandler(true)
                }
                break
            case .failure(let error):
                DispatchQueue.main.async {
                    completionHandler(false)
                }
                print(error)
                break
            }
        }
    }
    
    /*
     Make a PUT call to the appointment api endpoint to update an existing appointment. Returns true if successful via completionHandler, otherwise returns false
     @param appointment: Old appointment to be updated
     @param newAppointment: New appointment to update the old one
     @param completionHandler: Completion handler
     */
    func updateAnAppointment(appointment: Appointment, newAppointment: Appointment, completionHandler: @escaping(Bool) -> Void) {
        let params: Parameters = ["appointment": appointment.date!, "new_appointment": newAppointment.date!];
        Alamofire.request(API.APPOINTMENT_URL, method: .put, parameters: params, encoding: URLEncoding.default, headers: [:]).responseObject { (response: DataResponse<Appointment>) in
            switch response.result {
            case .success:
                DispatchQueue.main.async {
                    completionHandler(true)
                }
                break
            case .failure(let error):
                DispatchQueue.main.async {
                    completionHandler(false)
                }
                print(error)
                break
            }
        }
    }
    
    /*
     Make a DELETE call to the appointment api endpoint to delete an existing appointment. Returns true if successful via completionHandler, otherwise returns false
     @param appointment: The appointment to delete
     @param completionHandler: Completion handler
     */
    func deleteAnAppointment(appointment: Appointment, completionHandler: @escaping(Bool) -> Void) {
        let params: Parameters = ["appointment": appointment.date!];
        Alamofire.request(API.APPOINTMENT_URL, method: .delete, parameters: params, encoding: URLEncoding.default, headers: [:]).responseObject { (response: DataResponse<Appointment>) in
            switch response.result {
            case .success:
                DispatchQueue.main.async {
                    completionHandler(true)
                }
                break
            case .failure(let error):
                DispatchQueue.main.async {
                    completionHandler(false)
                }
                print(error)
                break
            }
        }
    }
}
