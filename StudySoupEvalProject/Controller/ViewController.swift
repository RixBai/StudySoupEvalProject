//
//  ViewController.swift
//  StudySoupEvalProject
//
//  Created by Max on 10/12/18.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit
import PKHUD

let APPOINTMENT_CELL_REUSE_IDENTIFIER = "appointmentCellReuseIdentifier"
let api:AppointmentAPI = AppointmentAPI()
var newAppointments:[Appointment]?

class ViewController: UIViewController {
    // UI Controls
    @IBOutlet weak var tblAppointments: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadAppointments()
    }
    
    @IBAction func onTouchRefresh(_ sender: Any) {
        // Reload appointments when tap on the Refresh button
        reloadAppointments()
    }
    
    /*
     Call appointment api endpoint and return the appointments available
     */
    func reloadAppointments() {
        HUD.show(.progress)
        api.appointments { (schedule) in
            // return if no appointments are available
            guard let newSchedule = schedule else {
                HUD.flash(.error, delay: 1.0)
                return
            }
            guard let appointments = newSchedule.availableAppointments else {
                // reload empty appointment list
                newAppointments = []
                HUD.flash(.success, delay: 1.0)
                self.tblAppointments.reloadData()
                return
            }
            
            // Reload tableview for new appointments returned
            newAppointments = appointments
            HUD.flash(.success, delay: 1.0)
            self.tblAppointments.reloadData()
        }
    }
}

extension UIViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return 0 rows if there are no appointments
        return newAppointments?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Initialize appointment tableview cell
        var cell = tableView.dequeueReusableCell(withIdentifier: APPOINTMENT_CELL_REUSE_IDENTIFIER)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: APPOINTMENT_CELL_REUSE_IDENTIFIER)
        }

        var title = ""
        var subTitle = ""
        
        // If appointment for the row does not exist, just return a cell with empty labels
        guard let appointment = newAppointments?[indexPath.row] else {
            cell!.textLabel?.text = title
            cell!.detailTextLabel?.text = subTitle
            return cell!
        }
        
        if let date = appointment.date {
            title = date
        }
        if let times = appointment.times {
            for time in times {
                subTitle = subTitle + String(time) + "h, "
            }
            // Remove the last ", "
            subTitle = String(subTitle.dropLast(2))
        }
        
        cell!.textLabel?.text = title
        cell!.detailTextLabel?.text = subTitle
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If appointment for the row does not exist, return
        guard let appointment = newAppointments?[indexPath.row] else {
            return
        }
        // If date for the appointment does not exist, return
        guard let date = appointment.date else {
            return
        }
        // Build a message to show when tapped on a row
        var message: String = "Your appointments are at "
        if let times = appointment.times {
            for time in times {
                message = message + String(time) + "h, "
            }
            // Remove the last ", "
            message = String(message.dropLast(2))
        }
        
        // Present an alert view
        let alertController = UIAlertController(title: "Appointments for " + date, message: message, preferredStyle: UIAlertController.Style.alert)
        // Add a "OK" action to the alert
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
