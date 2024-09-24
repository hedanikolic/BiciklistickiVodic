//
//  BikeStopData.swift
//  bicikl
//
//  Created by Heda Nikolić on 27.06.2024..
//

import Foundation

struct BikeStop : Identifiable, Codable {
    var id = UUID().uuidString
    let name: String
    let latitude: Double
    let longitude: Double
}


class BikeStopData: ObservableObject{
    
    @Published var bikeStops:[BikeStop] = []
    
}
