//
//  BarrierTypesData.swift
//  Gravicaine
//
//  Created by Stephen Ball on 12/7/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

// types of barrier from 1 to 3 inclusive
// 1 vertical straight movement
// 2 diagonal straight movement
// 3 curvy movement
// 4 asteroid cluster

import Foundation

var barrierTypes:[Int] = [
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             
                             5,5,6,7,5,5,7,6,6,7,
                             4,4,4,4,4,4,4,4,4,4,
                             
                             2,2,2,2,2,2,2,2,2,2,
                             2,2,2,2,2,2,2,2,2,2,
                             2,2,2,2,2,2,2,2,2,2,
                             2,2,2,2,2,2,2,2,2,2,
                             
                             4,4,4,4,4,4,4,4,4,4,
                             
                             3,3,3,3,3,3,3,3,3,3,
                             3,3,3,3,3,3,3,3,3,3,
                             3,3,3,3,3,3,3,3,3,3,
                             3,3,3,3,3,3,3,3,3,3,
                             
                             4,4,4,4,4,4,4,4,4,4,
                             
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             
                             5,5,6,7,5,5,7,6,6,7,
                             
                             2,2,2,2,2,2,2,2,2,2,
                             2,2,2,2,2,2,2,2,2,2,
                             2,2,2,2,2,2,2,2,2,2,
                             2,2,2,2,2,2,2,2,2,2,
                             
                             6,7,5,7,6,5,5,5,7,6,
                             
                             3,3,3,3,3,3,3,3,3,3,
                             3,3,3,3,3,3,3,3,3,3,
                             3,3,3,3,3,3,3,3,3,3,
                             3,3,3,3,3,3,3,3,3,3,
                             
                             5,6,5,7,5,6,6,5,7,7,
                             
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1
]
