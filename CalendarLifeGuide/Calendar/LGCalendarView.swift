//
//  LGCalendarView.swift
//  CalendarLifeGuide
//
//  Created by Сергей Мельников on 28.09.2018.
//  Copyright © 2018 Сергей Мельников. All rights reserved.
//

import UIKit

private let identifier = "Cell"
private let identifierKind = "Kind"
private let secondsInDay = 86_400

class LGCalendarView: UICollectionView {
    
    private var currentCellWidth = 0
    private var currentInsetForSections: CGFloat = 0.0
    private var calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    private var data: [[(date: Date?, countEvents: Int)]?] = []
    private var startDate: Date?
    private var endDate: Date?
    
    weak var delegateLGCalendar: LGCalendarDelegate? {
        didSet {
            guard let newValue = delegateLGCalendar else { return }
            var comp = calendar.dateComponents([.year, .month], from: newValue.startDate)
            comp.timeZone = TimeZone(abbreviation: "UTC")!
            startDate = calendar.date(from: comp)
            comp = calendar.dateComponents([.year, .month], from: newValue.endDate)
            endDate = calendar.date(from: comp)
        }
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func reloadData() {
        prepareData()
        super.reloadData()
    }
    
    private func prepare() {
        dateFormatter.dateFormat = "MMMM"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        delegate = self
        dataSource = self
        register(UINib(nibName: "LGCalendarDayCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        register(UINib(nibName: "LGCalendarHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifierKind)
    }
    
    private func prepareData() {
        let tmpStart = DispatchTime.now()
        guard let startDate = startDate, let endDate = endDate else { return }
        let startMonth = calendar.component(.month, from: startDate)
        let startYear = calendar.component(.year, from: startDate)
        let endMonth = calendar.component(.month, from: endDate)
        let endYear = calendar.component(.year, from: endDate)
        let monthsPerYear = 12
        prepareSectionsAndRow((endYear - startYear - 1) * monthsPerYear + endMonth + monthsPerYear - startMonth)
        print("Время создания дат: \((DispatchTime.now().uptimeNanoseconds - tmpStart.uptimeNanoseconds) ) наносек")
    }
    
    private func prepareSectionsAndRow(_ countMonths: Int) {
        guard let startDate = startDate, let delegate = delegateLGCalendar else { return }
        let sortedEvents = delegate.events.sorted(by: { return $0 < $1 })
        var currentEventDate = 0
        data = Array(repeating: nil, count: countMonths)
        for month in 0..<countMonths {
            guard let newDate = calendar.date(byAdding: .month, value: month, to: startDate) else { fatalError("Неполучилось добавить \(month) месяцов к дате \(startDate)") }
            var additionDays = calendar.component(.weekday, from: newDate) - 2
            additionDays = additionDays >= 0 ? additionDays : 7 + additionDays
            let countDayInMonth = (calendar.range(of: .day, in: .month, for: newDate)?.count ?? 0) + additionDays
            data[month] = Array(repeating: (nil, 0), count: countDayInMonth)
            for day in 0..<countDayInMonth where day >= additionDays {
                data[month]![day].date = Date(timeIntervalSince1970: newDate.timeIntervalSince1970 + Double(secondsInDay * (day - additionDays)))
                if sortedEvents.count > 0 {
                    while currentEventDate < sortedEvents.count {
                        if sortedEvents[currentEventDate] < data[month]![day].date! {
                            if day > 0 {
                                data[month]![day - 1].countEvents += 1
                            } else {
                                data[month-1]![data[month - 1]!.count - 1].countEvents += 1
                            }
                            currentEventDate += 1
                        } else {
                            break
                        }
                    }
                }
            }
        }
    }
    
    func prepareUI() {
        updateCurrentCellWidth()
        updateCurrentInset()
        reloadData()
    }
    
    private func updateCurrentInset() {
        currentInsetForSections = (bounds.width - CGFloat(currentCellWidth * 7)) / 2
    }
    
    private func updateCurrentCellWidth() {
        currentCellWidth = Int(bounds.width) / 7
    }
    
}

extension LGCalendarView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifierKind, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard let view = view as? LGCalendarHeaderView else { fatalError() }
        guard let tmpDate = data[indexPath.section]?.first(where: { return $0.0 != nil }) else { fatalError() }
        guard let date = tmpDate.0 else { fatalError() }
        
        view.title = dateFormatter.string(from: date) + " " + String(calendar.component(.year, from: date))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: bounds.width, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: currentCellWidth, height: currentCellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0.0, left: currentInsetForSections, bottom: 0.0, right: currentInsetForSections)
    }
}

extension LGCalendarView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let dayCell = cell as? LGCalendarDayCell else { return }
        guard let delegate = delegateLGCalendar else { return }
        if let date = data[indexPath.section]?[indexPath.row].0 {
            let countEvent = data[indexPath.section]![indexPath.row].1
            let strDay = String(calendar.component(.day, from: date))
            if date < delegate.startDate {
                dayCell.prepare(strDay, type: .notFound(countEvent: countEvent))
                return
            }
            if date > delegate.endDate {
                dayCell.prepare(strDay, type: .notFound(countEvent: countEvent))
                return
            }
            let weekDay = calendar.component(.weekday, from: date) - 1
            if weekDay == 6 || weekDay == 0 {
                dayCell.prepare(strDay, type: .holiday(countEvent: countEvent))
            } else {
                dayCell.prepare(strDay, type: .workday(countEvent: countEvent))
            }
        } else {
            dayCell.prepare("", type: .clear)
        }
    }
}
