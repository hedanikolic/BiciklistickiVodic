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

    @State private var selectedRoute: Route?
    @State private var selectedBikeStop: BikeStop?

    private let osijekLocation = CLLocation(latitude: 45.5550, longitude: 18.6955)

    var osijekRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: osijekLocation.coordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)
    }

    var body: some View {
        NavigationView {
            VStack {
                MapViewWrapper(
                    region: osijekRegion,
                    bikeStops: bikeStopData.bikeStops,
                    routeData: routeData,
                    onSelectRoute: { route in
                        selectedRoute = route
                    },
                    onSelectBikeStop: { stop in
                        selectedBikeStop = stop
                    }
                )
                // Present Route details
                .sheet(item: $selectedRoute) { route in
                    RouteDetailView(route: route)
                        .presentationDetents([.fraction(0.5)])
                        .presentationDragIndicator(.visible)
                }
                // Present BikeStop details
                .sheet(item: $selectedBikeStop) { stop in
                    BikeStopDetailView(stop: stop)
                        .presentationDetents([.fraction(0.5)])
                        .presentationDragIndicator(.visible)
                }
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
            .edgesIgnoringSafeArea(.horizontal)
        }
    }
}
