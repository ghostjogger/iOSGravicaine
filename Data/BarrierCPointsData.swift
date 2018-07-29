//
//  BarrierCPointsData.swift
//  Gravicaine
//
//  Created by Stephen Ball on 12/07/2018.
//  Copyright © 2018 Stephen Ball. All rights reserved.
//

// barrier curve control points , from 1 to 6 inclusive
// determine the amount of curve - higher number = more curvy

import Foundation






var barrierCpoints:[Int] = [
                            1,1,1,1,1,1,1,1,1,1,
                            1,1,1,1,1,1,1,1,1,1,
                            1,1,1,1,1,1,1,1,1,1,
                            1,1,1,1,1,1,1,1,1,1,
                            
                            1,1,1,1,1,1,1,1,1,1,
                            
                            3,3,3,3,3,3,3,3,3,3,
                            3,3,3,3,3,3,3,3,3,3,
                            3,3,3,3,3,3,3,3,3,3,
                            3,3,3,3,3,3,3,3,3,3,
                            
                            3,3,3,3,3,3,3,3,3,3,
                            
                            3,3,3,3,3,3,3,3,3,3,
                            3,3,3,3,3,3,3,3,3,3,
                            3,3,3,3,3,3,3,3,3,3,
                            3,3,3,3,3,3,3,3,3,3,
                            
                            3,3,3,3,3,3,3,3,3,3,
                            
                            1,1,1,1,1,1,1,1,1,1,
                            1,1,1,1,1,1,1,1,1,1,
                            1,1,1,1,1,1,1,1,1,1,
                            1,1,1,1,1,1,1,1,1,1,
                            
                            3,3,3,3,3,3,3,3,3,3,
                            
                            6,6,6,6,6,6,6,6,6,6,
                            6,6,6,6,6,6,6,6,6,6,
                            6,6,6,6,6,6,6,6,6,6,
                            6,6,6,6,6,6,6,6,6,6,
                            
                            6,6,6,6,6,6,6,6,6,6,
                            
                            6,6,6,6,6,6,6,6,6,6,
                            6,6,6,6,6,6,6,6,6,6,
                            6,6,6,6,6,6,6,6,6,6,
                            6,6,6,6,6,6,6,6,6,6,
                            
                            6,6,6,6,6,6,6,6,6,6,
                            
                            3,3,3,3,3,3,3,3,3,3, //stepped barrier section
                            3,3,3,3,3,3,3,3,3,3,
                            3,3,3,3,3,3,3,3,3,3,
                            3,3,3,3,3,3,3,3,3,3,
                            
                            3,1,1,1,1,1,1,1,1,1, //asteroids
                            1,1,1,1,1,1,1,1,1,1,
                            1,1,1,1,1,1,1,1,1,1,
                            1,1,1,1,1,1,1,1,1,1,
                            1,1,1,1,1,1,1,1,1,1,
                            1,1,1,1,1,1,1,1,1,1,
                            1,1,1,1,1,1,1,1,1,1,
                            
                            1,1,1,1,1,1,1,1,1,1, //mines
                            1,1,1,1,1,1,1,1,1,1,
                            1,1,1,1,1,1,1,1,1,1,
                            1,1,1,1,1,1,1,1,1,1,
                            
                            3,3,3,3,3,3,3,3,3,3, //stepped barrier section
                            3,3,3,3,3,3,3,3,3,3,
                            3,3,3,3,3,3,3,3,3,3,
                            3,3,3,3,3,3,3,3,3,3,
                            
                            3,1,1,1,1,1,1,1,1,1, //lasers
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

