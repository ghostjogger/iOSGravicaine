//
//  BarrierGapPositionData.swift
//  Gravicaine
//
//  Created by Stephen Ball on 12/07/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

// X position of gaps, lower the number, the further left on screen, from 0 to 10 inclusive ; 3 to 10 inclusive for vertically overlapping barriers

import Foundation







var barriers:[Int] = [
                        1,1,1,1,1,8,8,8,8,8,
                        2,2,2,2,2,7,7,7,7,7,
                        3,3,3,3,3,6,6,6,6,6,
                        4,4,4,4,4,5,5,5,5,5,
                        
                        1,1,1,1,1,1,1,1,1,1,
                        
                        1,1,1,1,1,8,8,8,8,8,
                        2,2,2,2,2,7,7,7,7,7,
                        3,3,3,3,3,6,6,6,6,6,
                        4,4,4,4,4,5,5,5,5,5,
                        
                        1,1,1,1,1,1,1,1,1,1,
                        
                        1,1,1,1,1,8,8,8,8,8,
                        2,2,2,2,2,7,7,7,7,7,
                        3,3,3,3,3,6,6,6,6,6,
                        4,4,4,4,4,5,5,5,5,5,
                        
                        1,1,1,1,1,1,1,1,1,1,
                        
                        1,8,1,8,1,8,1,8,1,8,
                        2,7,2,7,2,7,2,7,2,7,
                        3,6,3,6,3,6,3,6,3,6,
                        4,5,4,5,4,5,4,5,4,5,
                        
                        1,1,1,1,1,1,1,1,1,1,
                        
                        1,8,1,8,1,8,1,8,1,8,
                        2,7,2,7,2,7,2,7,2,7,
                        3,6,3,6,3,6,3,6,3,6,
                        4,5,4,5,4,5,4,5,4,5,
                        
                        1,1,1,1,1,1,1,1,1,1,
                        
                        1,8,1,8,1,8,1,8,1,8,
                        2,7,2,7,2,7,2,7,2,7,
                        3,6,3,6,3,6,3,6,3,6,
                        4,5,4,5,4,5,4,5,4,5,
                        
                        1,1,1,1,1,1,1,1,1,1,
                        
                        7,4,3,1,4,6,7,4,3,1, // stepped barrier section
                        7,2,3,1,4,6,7,2,3,1,
                        4,1,8,7,6,7,4,1,8,7,
                        4,0,8,9,6,7,4,0,8,9,
                        
                        1,1,1,1,1,1,1,1,1,1, //asteroids
                        1,1,1,1,1,1,1,1,1,1,
                        1,1,1,1,1,1,1,1,1,1,
                        1,1,1,1,1,1,1,1,1,1,
                        1,1,1,1,1,1,1,1,1,1,
                        1,1,1,1,1,1,1,1,1,1,
                        1,1,1,1,1,1,1,1,1,1,
                        
                        1,1,1,1,1,1,1,1,1,1, // mines
                        1,1,1,1,1,1,1,1,1,1,
                        1,1,1,1,1,1,1,1,1,1,
                        1,1,1,1,1,1,1,1,1,1,
                        
                        7,4,3,1,4,6,7,4,3,1, // stepped barrier section
                        7,2,3,1,4,6,7,2,3,1,
                        4,1,8,7,6,7,4,1,8,7,
                        4,0,8,9,6,7,4,0,8,9,
                        
                        1,1,1,1,1,1,1,1,1,1, // lasers
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


