//
//  DynamicHeightCollectionView.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/18/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit

class DynamicHeightCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
