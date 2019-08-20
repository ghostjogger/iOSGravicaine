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
                        1,1,1,1,5,3,8,8,8,6,
                        7,2,2,2,6,8,8,8,8,3,
                        3,1,1,1,5,3,7,7,7,6,
                        5,2,2,2,6,8,6,6,6,6,
                        
                        1,1,1,1,1,1,1,1,1,1,
                        
                        3,1,1,1,7,8,8,8,8,8,
                        7,2,2,2,2,8,8,8,8,8,
                        3,1,1,1,3,7,7,7,7,7,
                        4,2,2,2,5,6,6,6,6,6,
                        
                        1,1,1,1,1,1,1,1,1,1,
                        
                        1,1,1,1,1,8,8,8,8,8,
                        8,4,2,2,2,8,5,8,8,8,
                        1,5,1,1,1,7,7,7,7,7,
                        2,2,4,2,2,6,6,6,6,6,
                        
                        1,1,1,1,1,1,1,1,1,1,
                        
                        1,8,1,8,1,8,1,8,1,8,
                        1,9,2,7,2,7,2,7,5,7,
                        4,6,8,6,1,6,4,6,8,6,
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
                        
                        1,5,8,1,8,4,1,5,2,5, // more barriers
                        2,5,2,3,7,2,7,2,1,7,
                        4,1,8,7,6,7,4,1,8,7,
                        7,2,3,1,4,6,7,2,3,1,
                        4,0,8,9,6,7,4,0,8,9,
                        7,4,3,1,4,6,7,4,3,1,                        
                        2,5,2,3,7,2,7,2,1,7,
                        1,5,8,1,8,4,1,5,2,5,
                        
                        1,1,1,1,1,1,1,1,1,1, //mixed types
                        1,1,1,1,1,1,1,1,1,1,
                        1,1,1,1,1,1,1,1,1,1,
                        1,1,1,1,1,1,1,1,1,1,
                        1,1,1,1,1,1,1,1,1,1,
                        1,1,1,1,1,1,1,1,1,1,
                        1,1,1,1,1,1,1,1,1,1,
                        1,1,1,1,1,1,1,1,1,1,
                        
                        3,4,5,6,6,7,8,7,6,5, // stepped barrier section
                        3,9,8,7,6,5,4,5,6,7,
                        3,4,5,6,6,7,8,7,6,5,
                        3,9,8,7,6,5,4,5,6,7,
                        7,1,3,6,4,5,7,8,3,1,
                        7,0,5,1,4,6,7,8,4,1,
                        4,6,8,3,6,7,4,6,8,7,
                        7,0,5,1,4,6,7,8,4,1,
    
                        1,4,10,6,4,10,1,3,9,5,
                        1,3,6,8,1,3,6,8,1,3,
                        1,4,10,6,4,10,1,3,9,5,
                        1,3,6,8,1,3,6,8,1,3,
                        1,1,8,1,3,1,6,1,1,1,
                        

                        
                        3,4,5,6,6,7,8,7,6,5, // stepped barrier section
                        3,9,8,7,6,5,4,5,6,7,
                        3,4,5,6,6,7,8,7,6,5,
                        3,9,8,7,6,5,4,5,6,7,
                        7,1,3,6,4,5,7,2,3,1,
                        7,0,5,1,4,6,7,8,4,1,
                        4,0,8,3,6,7,4,0,8,7,
                        7,0,5,1,4,6,7,5,5,5,
                        
                        5,5,1,1,1,1,1,1,1,1, // final section
                        4,7,6,2,1,1,1,7,3,5,
                        1,1,1,1,1,1,1,1,1,1,
                        1,1,1,1,1,1,1,1,1,1,
                        1,1,1,1,1,1,1,1,1,1,
                        4,1,6,7,1,4,1,6,7,1,
                        5,7,1,2,9,1,1,1,1,1,
                        6,1,1,4,2,6,7,10,5,1
]


