//
//  ViewController.swift
//  CalendarDemo
//
//  Created by Rommel Rico on 9/27/16.
//  Copyright © 2016 Rommel Rico. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {
    
    var store: EKEventStore?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connecting to the Event Store
        store = EKEventStore()
        store!.requestAccess(to: .event) { (success: Bool, error: Error?) in
            if let error = error {
                print("ERROR: \(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func createEvent(_ sender: AnyObject) {
        // Clicked Create Event
        
        // Creating an event.
        let event = EKEvent(eventStore: store!)
        event.title = "English 151"
        event.startDate = Date(timeIntervalSinceNow: 40 * 60.0) //30 minutes from now = Now + 30 minutes * 60 seconds
        event.endDate = Date(timeIntervalSinceNow: 60 * 60.0) //One hour = 60 minutes * 60 seconds
        event.calendar = (store?.defaultCalendarForNewEvents)!
        // TODO: Add alarm.
        // TODO: Set recurrence rules.
        
        // Set the event location
        let structuredLocation = EKStructuredLocation(title: "Camino Hall")
        let location = CLLocation(latitude: 32.7716572, longitude: -117.1927439)
        structuredLocation.geoLocation = location
        event.structuredLocation = structuredLocation
        
        // Save the event.
        do {
            try store?.save(event, span: .thisEvent, commit: true)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func readEvents(_ sender: AnyObject) {
        // Clicked Read Event
        
        // Get the appropriate calendar
        let calendar = NSCalendar.current
        
        // Create the start date components
        let startDate = Date()
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: startDate)
        
        // Create the predicate from the event store's instance method
        let predicate = store?.predicateForEvents(withStart: twoDaysAgo!, end: startDate, calendars: nil)
        
        // Fetch all events that match the predicate
        let events = store?.events(matching: predicate!)
        
        for event in events! {
            print("Event: \(event.title)")
        }
        
    }
    

}

