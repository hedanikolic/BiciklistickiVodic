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
        VStack(spacing: 12) {
            Text(route.name)
                .font(.title).bold()
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            HStack{
                Text("Ruta:")
                    .font(.headline)
                    .padding(.horizontal)
                Spacer()
            }
            Text(String(route.description.dropFirst(6)))
                .font(.title3)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Text(String(route.description.prefix(6)))
                .font(.headline)
                .padding(.top)
        }
        .padding([.bottom, .horizontal])
    }
}


/*#Preview {
    RouteDetailView()
}*/
