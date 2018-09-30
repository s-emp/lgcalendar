//
//  LGCalendarDelegate.swift
//  CalendarLifeGuide
//
//  Created by Сергей Мельников on 30/09/2018.
//  Copyright © 2018 Сергей Мельников. All rights reserved.
//

import Foundation

protocol LGCalendarDelegate {
    var startDate: Date { get }
    var endDate: Date { get }
    var events: [Date: Int] { get }
    var selectedDate: Date { get set }
    func selected(_ date: Date)
    func closeCalendar()
}
