//
//  GlobalValues.swift
//  No Bees Today
//
//  Created by Moritz Kanzler on 21.05.17.
//  Copyright © 2017 Moritz Kanzler. All rights reserved.
//

import Foundation
import UIKit

class GlobalValues {
    static var firstTakingDate: Date?
    static var currentTakingPeriod: Date?
    static private var takingTimePerDay: Date?
    
    class func initDates() -> Bool {
        
        let estimatedFTD = UserDefaults.standard.value(forKey: "FirstTakingDate") as? Date
        let estimatedCTP = UserDefaults.standard.value(forKey: "CurrentTakingPeriod") as? Date
        let estimatedTTPD = UserDefaults.standard.value(forKey: "takingTimePerDay") as? String
        
        if let ftd = estimatedFTD, let ctp = estimatedCTP, let ttpd = estimatedTTPD {
            self.setFirstTakingDate(ftd)
            self.setCurrentTakingPeriod(ctp)
            self.setTimePerDay(value: ttpd)
            return true
        } else {
            return false
        }
        
    }
    
    class func setFirstTakingDate(_ date: Date) {
        let normalizedDate = self.normalizeDate(date)
        UserDefaults.standard.set(normalizedDate, forKey: "FirstTakingDate")
        self.firstTakingDate = normalizedDate
    }
    
    class func setCurrentTakingPeriod(_ date: Date) {
        let normalizedDate = self.normalizeDate(date)
        UserDefaults.standard.set(normalizedDate, forKey: "CurrentTakingPeriod")
        self.currentTakingPeriod = self.normalizeDate(date)
    }
    
    class func setTimePerDay(value: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let formattedTime = dateFormatter.date(from: value)
        UserDefaults.standard.set(value, forKey: "takingTimePerDay")
        self.takingTimePerDay = formattedTime
    }
    
    class func getTimePerDay() -> Date? {
        
        if let takingTimePD = self.takingTimePerDay {
            let currentDate = Date()
            var dateComponents = DateComponents()
            dateComponents.year = Calendar.current.dateComponents([.year], from: currentDate).year
            dateComponents.month = Calendar.current.dateComponents([.month], from: currentDate).month
            dateComponents.day = Calendar.current.dateComponents([.day], from: currentDate).day
            dateComponents.hour = Calendar.current.dateComponents([.hour], from: takingTimePD).hour
            dateComponents.minute = Calendar.current.dateComponents([.minute], from: takingTimePD).minute
            dateComponents.second = 0
            
            return Calendar.current.date(from: dateComponents)
        } else {
            return nil
        }
    }
    
    class func normalizeDate(_ date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let rightDate = calendar.date(from: components)
        return rightDate!
    }
    
    class func getCurrentPillDayFromStorage() -> PillDay? {
        if let currentPeriod = GlobalValues.currentTakingPeriod {
            let pc = PillCycle(startDate: currentPeriod)
            return pc.getCurrentPillDay()
        } else {
            return nil
        }
    }
    
    class func updateCurrentTakingPeriodOnCycleChange() {
        if let ctp = self.currentTakingPeriod {
            let swapDate = ctp.addingTimeInterval(60 * 60 * 24 * 28)
            if swapDate < Date() {
                self.setCurrentTakingPeriod(swapDate)
            }
        }
    }

}
