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
    
    @IBAction func touchScrollToDate(_ sender: Any) {
        let date = Date(timeIntervalSince1970: 1275386123.0)
        print("Scroll to: \(date)")
        calendarView.scrollToDate(date, animated: true)
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
        
        return Date(timeIntervalSince1970: 1538352720)
    }
    
    var endDate: Date {
        return Date(timeIntervalSince1970: 1549036224)
    }
    
    var events: [Date] {
        return [Date(timeIntervalSince1970: 1538697600), Date(timeIntervalSince1970: 1538784000), Date(timeIntervalSince1970: 1538784600), Date(timeIntervalSince1970: 1538957400), Date(timeIntervalSince1970: 1538957520), Date(timeIntervalSince1970: 1538957540)]
    }
    
    var selectedDate: Date {
        get {
            return Date(timeIntervalSince1970: 1538957540)
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
