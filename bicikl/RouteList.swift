//
//  RouteList.swift
//  bicikl
//
//  Created by Heda Nikolić on 27.06.2024..
//

import SwiftUI

struct RouteList: View {
    @EnvironmentObject var routeData: RouteData

    var body: some View {
        NavigationView {
            List(routeData.routes) { route in
                NavigationLink(destination: RouteDetailView(route: route)) {
                    Text(route.name)
                }
            }
            .navigationTitle("Biciklističke staze")
        }
    }
}
