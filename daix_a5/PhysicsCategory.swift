//
//  PhysicsCategory.swift
//  daix_a5
//
//  Created by DPC on 16/2/21.
//  Copyright © 2016年 DPC. All rights reserved.
//

struct PhysicsCategory {
    static let None:            UInt32 = 0
    static let All:             UInt32 = UInt32.max
    static let ShipCategory:    UInt32 = 0x1 << 0
    static let InvaderCategory: UInt32 = 0x1 << 1
    static let ShootCategory:   UInt32 = 0x1 << 2
    static let RockCategory:    UInt32 = 0x1 << 3
    static let SceneCategory:   UInt32 = 0x1 << 4
}
