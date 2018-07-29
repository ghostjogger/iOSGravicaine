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
// 5 asteroid belt vertical
// 6,7,8 static laser batteries left,centre,right respectively

import Foundation

var barrierTypes:[Int] = [
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             
                             4,5,5,4,5,5,4,5,5,4,
                             
                             2,2,2,2,2,2,2,2,2,2,
                             2,2,2,2,2,2,2,2,2,2,
                             2,2,2,2,2,2,2,2,2,2,
                             2,2,2,2,2,2,2,2,2,2,
                             
                             4,4,5,4,5,5,4,5,4,4,
                             
                             3,3,3,3,3,3,3,3,3,3,
                             3,3,3,3,3,3,3,3,3,3,
                             3,3,3,3,3,3,3,3,3,3,
                             3,3,3,3,3,3,3,3,3,3,
                             
                             4,5,4,5,4,5,4,5,4,5,
                             
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             1,1,1,1,1,1,1,1,1,1,
                             
                             6,6,6,7,7,7,7,8,8,8,
                             
                             2,2,2,2,2,2,2,2,2,2,
                             2,2,2,2,2,2,2,2,2,2,
                             2,2,2,2,2,2,2,2,2,2,
                             2,2,2,2,2,2,2,2,2,2,
                             
                             7,7,6,8,7,6,8,7,6,8,
                             
                             3,3,3,3,3,3,3,3,3,3,
                             3,3,3,3,3,3,3,3,3,3,
                             3,3,3,3,3,3,3,3,3,3,
                             3,3,3,3,3,3,3,3,3,3,
                             
                             6,8,6,8,6,8,7,7,8,6,
                             
                             9,1,10,1,9,10,9,1,10,1,    //stepped barrier section
                             9,2,10,2,9,10,9,2,10,2,
                             9,1,10,1,9,10,9,1,10,1,   
                             9,2,10,2,9,10,9,2,10,2,
                             
                             5,11,12,4,14,13,11,14,12,13,    // asteroids
                             13,12,14,11,13,14,4,12,11,5,
                             13,13,5,14,14,11,11,5,12,12,
                             13,13,4,14,14,11,11,4,12,12,
                             13,14,4,13,14,4,13,14,13,5,
                             13,12,14,11,13,14,4,12,11,5,
                             5,11,12,4,14,13,11,14,12,13,
                             
                             15,16,15,16,15,16,15,16,15,16, // mines
                             17,18,17,18,17,18,17,18,17,18,
                             15,18,16,17,18,15,17,16,15,18,
                             16,17,18,15,17,16,15,18,16,18,
                             
                             9,1,10,1,9,10,9,1,10,1,    //stepped barrier section
                             9,2,10,2,9,10,9,2,10,2,
                             9,1,10,1,9,10,9,1,10,1,
                             9,2,10,2,9,10,9,2,10,2,
                             
                             6,7,8,6,7,8,6,8,6,8, //lasers
                             6,8,6,8,6,8,6,8,6,8,
                             7,8,6,8,6,8,6,8,6,7,
                             19,20,19,20,7,19,20,19,20,7,
                             6,20,8,19,7,6,20,8,19,20,
                             7,8,6,8,6,8,6,8,6,7,
                             
                             2,3,1,1,3,2,1,2,1,3, //more barriers
                             2,3,3,2,2,3,2,2,3,3,
                             9,1,10,1,9,10,9,1,10,1,
                             9,2,10,2,9,10,9,2,10,2,
                             9,2,10,2,9,10,9,2,10,2,
                             9,1,10,1,9,10,9,1,10,1,
                             2,3,3,2,2,3,2,2,3,3,
                             2,3,1,1,3,2,1,2,1,3,
                             
                             17,14,18,13,15,12,16,11,4,5, // mixed types
                             18,13,19,17,14,20,12,11,17,18,
                             6,19,8,20,7,8,16,6,15,4,
                             17,19,18,20,11,12,13,14,11,12,
                             19,20,19,20,7,19,20,19,20,7,
                             6,20,8,19,7,6,20,8,19,20,
                             13,13,5,14,14,11,11,5,12,12,
                             13,13,4,14,14,11,11,4,12,12,
                             
                             9,3,10,3,9,10,9,3,10,3,    //stepped barrier section
                             9,2,10,2,9,10,9,2,10,2,
                             9,3,10,3,9,10,9,3,10,1,
                             9,2,10,2,9,10,9,2,10,2,
                             
                             3,2,3,2,3,2,3,2,3,2,
                             1,2,2,1,1,2,2,1,1,2,
                             3,2,3,2,3,2,3,2,3,2,
                             1,2,2,1,1,2,2,1,1,2,
                             1,20,1,19,2,19,2,20,19,20,
                             
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
