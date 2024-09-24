//
//  RouteDetailView.swift
//  bicikl
//
//  Created by Heda Nikolić on 27.06.2024..
//

import SwiftUI

struct RouteDetailView: View {
    var route: Route

    var body: some View {
        VStack(alignment: .leading) {
            Text(route.name)
                .font(.largeTitle)
                .padding(.bottom, 5)
            Text(String(route.description.prefix(6)))
                .font(.headline)
                .padding()
            Text(String(route.description.dropFirst(7)))
                .font(.title2)
                .padding(.vertical)
            Spacer()
        }
        .padding()
        //.navigationTitle(route.name)
    }
}


/*#Preview {
    RouteDetailView()
}*/
