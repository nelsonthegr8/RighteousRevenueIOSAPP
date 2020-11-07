//
//  atmCalculationResults.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 11/1/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import Foundation

class atmCalculationResult{
    var hundred = 0
    var fifty = 0
    var twenty = 0
    var ten = 0
    var five = 0
    var one = 0
    
    init()
    {
        
    }
    
    init(amount: Int, hundredEnabled: Bool, fiftyEnabled: Bool) {
        
        var remainder = amount
        
        if(hundredEnabled)
        {
            hundred = remainder / 100
            remainder = remainder - (hundred * 100)
        }
        
        if(fiftyEnabled)
        {
            fifty = remainder / 50
            remainder = remainder - (fifty * 50)
        }
        
        twenty = remainder / 20
        remainder = remainder - (twenty * 20)
        
        ten = remainder / 10
        remainder = remainder - (ten * 10)
        
        five = remainder / 5
        remainder = remainder - (five * 5)
        
        one = remainder
    }
}
