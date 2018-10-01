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
    private let dateFormatter = DateFormatter()
    private var data: [[(Date?, Int)]?] = []
    private var startDate: Date?
    private var endDate: Date?
    
    weak var delegateLGCalendar: LGCalendarDelegate? {
        didSet {
            guard let newValue = delegateLGCalendar else { return }
            var comp = Calendar.current.dateComponents([.year, .month], from: newValue.startDate)
            comp.timeZone = TimeZone(abbreviation: "UTC")!
            startDate = Calendar.current.date(from: comp)
            comp = Calendar.current.dateComponents([.year, .month], from: newValue.endDate)
            endDate = Calendar.current.date(from: comp)
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
        delegate = self
        dataSource = self
        register(UINib(nibName: "LGCalendarDayCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        register(UINib(nibName: "LGCalendarHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifierKind)
    }
    
    private func prepareData() {
        let tmpStart = DispatchTime.now()
        guard let startDate = startDate, let endDate = endDate else { return }
        guard let delegate = delegateLGCalendar else { return }
        let startMonth = Calendar.current.component(.month, from: startDate)
        let startYear = Calendar.current.component(.year, from: startDate)
        let endMonth = Calendar.current.component(.month, from: endDate)
        let endYear = Calendar.current.component(.year, from: endDate)
        let countSection = (endYear - startYear - 1) * 12 + endMonth + 12 - startMonth
        data = Array(repeating: nil, count: countSection)
        let sortedEvents = delegate.events.sorted(by: { return $0 < $1 })
        var currentEventDate = 0
        for i in 0..<countSection {
            guard let newDate = Calendar.current.date(byAdding: .month, value: i, to: startDate) else { fatalError("Неполучилось добавить \(i) месяцов к дате \(startDate)") }
            let additionDays = Calendar.current.component(.weekday, from: newDate) - 2
            let countDayInMonth = (Calendar.current.range(of: .day, in: .month, for: newDate)?.count ?? 0) + additionDays
            data[i] = Array(repeating: (nil, 0), count: countDayInMonth)
            for j in 0..<countDayInMonth where j >= additionDays {
                data[i]![j].0 = Date(timeIntervalSince1970: newDate.timeIntervalSince1970 + Double(secondsInDay * (j - additionDays)))
                if sortedEvents.count > 0 {
                    while currentEventDate < sortedEvents.count {
                        if sortedEvents[currentEventDate] < data[i]![j].0! {
                            if j > 0 {
                                data[i]![j - 1].1 += 1
                            } else {
                                data[i-1]![data[i - 1]!.count - 1].1 += 1
                            }
                            currentEventDate += 1
                        } else {
                            break
                        }
                    }
                }
            }
        }
        print("Время создания дат: \((DispatchTime.now().uptimeNanoseconds - tmpStart.uptimeNanoseconds) ) наносек")
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
        
        view.title = dateFormatter.string(from: date) + " " + String(Calendar.current.component(.year, from: date))
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
            let strDay = String(Calendar.current.component(.day, from: date))
            if date < delegate.startDate {
                dayCell.prepare(strDay, type: .notFound(countEvent: countEvent))
                return
            }
            if date > delegate.endDate {
                dayCell.prepare(strDay, type: .notFound(countEvent: countEvent))
                return
            }
            let weekDay = Calendar.current.component(.weekday, from: date) - 1
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
