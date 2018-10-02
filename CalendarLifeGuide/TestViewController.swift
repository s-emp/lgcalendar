//
//  TestViewController.swift
//  CalendarLifeGuide
//
//  Created by Сергей Мельников on 28.09.2018.
//  Copyright © 2018 Сергей Мельников. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet var calendarView: LGCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.delegateLGCalendar = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        calendarView.prepareUI()
        super.viewDidAppear(animated)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TestViewController: LGCalendarDelegate {
    var startDate: Date {
        var tmp = DateComponents()
        tmp.timeZone = TimeZone.current
        tmp.year = 2010
        tmp.month = 1
        tmp.day = 2
        tmp.hour = 3
        
        return Calendar.current.date(from: tmp)!
    }
    
    var endDate: Date {
        return Date(timeIntervalSince1970: 1262386123.0).addingTimeInterval(86_400 * 1200)
    }
    
    var events: [Date] {
        return []
    }
    
    var selectedDate: Date {
        get {
            return Date()
        }
        set {
            ()
        }
    }
    
    func selected(_ date: Date) {
        ()
    }
    
    func closeCalendar() {
        ()
    }
    
    
}
