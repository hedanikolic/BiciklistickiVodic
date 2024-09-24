//
//  MapView.swift
//  bicikl
//
//  Created by Heda Nikolić on 27.06.2024..
//

import SwiftUI
import MapKit

struct OsijekMapView: View {
    
    @EnvironmentObject var bikeStopData: BikeStopData
    @EnvironmentObject var routeData: RouteData

    @State private var selectedRoute: Route? = nil
    @State private var showRouteDetail = false

    private let osijekLocation = CLLocation(latitude: 45.5550, longitude: 18.6955)
    
    var osijekRegion: MKCoordinateRegion {
        return MKCoordinateRegion(center: osijekLocation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }

    var body: some View {
        NavigationView {
            VStack {
                MapViewWrapper(region: osijekRegion, bikeStops: bikeStopData.bikeStops, routeData: routeData, onSelectRoute: { route in
                    self.selectedRoute = route
                    self.showRouteDetail = true
                })
                .sheet(isPresented: $showRouteDetail) {
                    if let route = selectedRoute {
                        RouteDetailView(route: route)
                    } else {
                        Text("No route selected")
                    }
                }
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
            .edgesIgnoringSafeArea(.horizontal)
        }
    }
}
