//
//  LGCalendarDayCell.swift
//  CalendarLifeGuide
//
//  Created by Сергей Мельников on 28.09.2018.
//  Copyright © 2018 Сергей Мельников. All rights reserved.
//

import UIKit

indirect enum LGCalendarTypeCell {
    case notFound(countEvent: Int)
    case holiday(countEvent: Int)
    case workday(countEvent: Int)
    case selected(type: LGCalendarTypeCell)
    case clear
}

class LGCalendarDayCell: UICollectionViewCell {

    @IBOutlet private var mainView: UIView!
    @IBOutlet private var selectedView: UIView!
    @IBOutlet private var leftView: UIView!
    @IBOutlet private var centerView: UIView!
    @IBOutlet private var rightView: UIView!
    
    @IBOutlet private var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        leftView.layer.cornerRadius = 2.5
        centerView.layer.cornerRadius = 2.5
        rightView.layer.cornerRadius = 2.5
        selectedView.layer.cornerRadius = 15.0
    }
    
    func prepare(_ title: String, type: LGCalendarTypeCell) {
        selectedView.isHidden = true
        titleLabel.text = title
        mainView.isHidden = false
        switch type {
        case .clear:
            mainView.isHidden = true
        case .notFound(let countEvent):
            prepareCountEvent(countEvent)
            titleLabel.textColor = .orange
        case .holiday(let countEvent):
            prepareCountEvent(countEvent)
            titleLabel.textColor = .blue
        case .workday(let countEvent):
            prepareCountEvent(countEvent)
            titleLabel.textColor = .black
        case .selected(let typeCell):
            selectedView.isHidden = false
            switch typeCell {
            case .clear:
                mainView.isHidden = true
            case .notFound(let countEvent):
                prepareCountEvent(countEvent)
                titleLabel.textColor = .white
            case .holiday(let countEvent):
                prepareCountEvent(countEvent)
                titleLabel.textColor = .white
            case .workday(let countEvent):
                prepareCountEvent(countEvent)
                titleLabel.textColor = .white
            case .selected(_):
                fatalError("Двойная вложенность")
            }
        }
    }
    
    private func prepareCountEvent(_ count: Int) {
        if count <= 0 {
            leftView.isHidden = true
            centerView.isHidden = true
            rightView.isHidden = true
        } else if count == 1 {
            leftView.isHidden = true
            centerView.isHidden = false
            rightView.isHidden = true
        } else if count == 2 {
            leftView.isHidden = false
            centerView.isHidden = true
            rightView.isHidden = false
        } else if count >= 3 {
            leftView.isHidden = false
            centerView.isHidden = false
            rightView.isHidden = false
        }
    }
}
