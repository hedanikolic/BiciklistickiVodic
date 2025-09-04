//
//  biciklApp.swift
//  bicikl
//
//  Created by Heda Nikolić on 27.06.2024..
//

import SwiftUI

@main
struct biciklApp: App {
    
    var bikeStopData = BikeStopData()
    @StateObject var routeData = RouteData()
    
    var body: some Scene {
        WindowGroup {
            TabView{
                OsijekMapView()
                    .tabItem{
                        Label("Karta", systemImage: "map")
                    }
                
                RouteList()
                    .tabItem{
                        Label("Staze", systemImage: "bicycle")
                    }
                
                BikeStopList()
                    .tabItem{
                        Label("Stanice", systemImage: "mappin.and.ellipse")
                    }
            }
            .environmentObject(bikeStopData)
            .environmentObject(routeData)
            .preferredColorScheme(.light)
        }
    }
}
