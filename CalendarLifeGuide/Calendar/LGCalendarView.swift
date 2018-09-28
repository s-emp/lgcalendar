//
//  LGCalendarView.swift
//  CalendarLifeGuide
//
//  Created by Сергей Мельников on 28.09.2018.
//  Copyright © 2018 Сергей Мельников. All rights reserved.
//

import UIKit

private let identifier = "Cell"
private let dayInSecond = 86_400

class LGCalendarView: UICollectionView {
    private var currentCellWidth = 0
    private var currentInsetForSections: CGFloat = 0.0
    
    var startDate = Date(timeIntervalSince1970: 1262304000.0)
    var endDate = Date()
    
    var data: [Date?] = []

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
    
    private func prepare() {
        delegate = self
        dataSource = self
        let count = Int(endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970) / dayInSecond
        data = Array(repeating: nil, count: count)
        for i in 0..<count {
            data[i] = Date(timeIntervalSince1970: startDate.timeIntervalSince1970 + Double(dayInSecond * i))
        }
        register(UINib(nibName: "LGCalendarDayCell", bundle: nil), forCellWithReuseIdentifier: identifier)
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let dayCell = cell as? LGCalendarDayCell else { return }
        let tmp = arc4random_uniform(5)
        if tmp == 0 {
            dayCell.prepare(String(indexPath.row), type: .holiday(countEvent: Int(arc4random_uniform(3))))
        } else if tmp == 1 {
            dayCell.prepare(String(indexPath.row), type: .workday(countEvent: Int(arc4random_uniform(3))))
        } else if tmp == 2 {
            dayCell.prepare(String(indexPath.row), type: .notFound(countEvent: Int(arc4random_uniform(3))))
        } else if tmp == 3 {
            dayCell.prepare(String(indexPath.row), type: .clear)
        } else if tmp == 4 {
            dayCell.prepare(String(indexPath.row), type: .selected(type: .workday(countEvent: Int(arc4random_uniform(3)))))
        } else {
            print("Typnul %(")
        }
    }
}
