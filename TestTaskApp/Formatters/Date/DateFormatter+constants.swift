//
//  DateFormatter+constants.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 9/1/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import Foundation

extension DateFormatter {
    // 27 Jul 2008, 15:55
    static let dayMonthYearAndTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy, HH:mm"
        formatter.calendar = Calendar.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter
    }()
}
