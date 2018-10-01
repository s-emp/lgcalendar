//
//  LGCalendarDelegate.swift
//  CalendarLifeGuide
//
//  Created by Сергей Мельников on 30/09/2018.
//  Copyright © 2018 Сергей Мельников. All rights reserved.
//

import Foundation

protocol LGCalendarDelegate: AnyObject {
    
    /// Минимальная дата отображаемая в календаре. Она будет округлена до первого дня месяца, что бы корректно построить календарь.
    var startDate: Date { get }
    
    /// Максимальная дата отображаемая в календаре. Она будет округлена до последнего дня/часа/минуты/секунды месяца, что бы корректно построить календарь.
    var endDate: Date { get }
    
    var events: [Date] { get }
    var selectedDate: Date { get set }
    func selected(_ date: Date)
    func closeCalendar()
}
