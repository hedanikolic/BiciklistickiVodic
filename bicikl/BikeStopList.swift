//
//  BikeStopList.swift
//  bicikl
//
//  Created by Heda Nikolić on 04.09.2025..
//

import SwiftUI

struct BikeStopList: View {
    @EnvironmentObject var bikeStopData: BikeStopData
    
    var body: some View {
        NavigationView {
            List {
                Section(header:
                    HStack{
                        Image(systemName: "wrench.and.screwdriver.fill")
                        .font(.body)
                        Text("Servisi").font(.body)
                    }) {
                    ForEach(bikeStopData.bikeStops.filter { $0.type.lowercased() == "service" }) { bikeStop in
                        NavigationLink(destination: BikeStopDetailView(stop: bikeStop)) {
                            Text(bikeStop.name)
                        }
                    }
                }
                
                Section(header: 
                    HStack{
                        Image(systemName: "fuelpump")
                        .font(.body)
                        Text("Pumpe").font(.body)
                    }) {
                    ForEach(bikeStopData.bikeStops.filter { $0.type.lowercased() == "pump" }) { bikeStop in
                        NavigationLink(destination: BikeStopDetailView(stop: bikeStop)) {
                            Text(bikeStop.name)
                        }
                    }
                }
                
                Section(header:
                    HStack{
                        Image(systemName:"bicycle")
                        .font(.body)
                        Text("Najam").font(.body)
                    }) {
                    ForEach(bikeStopData.bikeStops.filter { $0.type.lowercased() == "rent" }) { bikeStop in
                        NavigationLink(destination: BikeStopDetailView(stop: bikeStop)) {
                            Text(bikeStop.name)
                        }
                    }
                }
            }
            .navigationTitle("Biciklističke stanice")
        }
    }
}
