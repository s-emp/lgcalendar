//
//  LGCalendarHeaderView.swift
//  CalendarLifeGuide
//
//  Created by Сергей Мельников on 01.10.2018.
//  Copyright © 2018 Сергей Мельников. All rights reserved.
//

import UIKit

class LGCalendarHeaderView: UICollectionReusableView {

    @IBOutlet private var titleLabel: UILabel!
    
    var title = "" {
        didSet { titleLabel.text = title }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
