//
//  BikeStopData.swift
//  bicikl
//
//  Created by Heda Nikolić on 27.06.2024..
//

import Foundation
import CoreLocation


struct BikeStop: Identifiable, Codable {
    var id: String          // Firebase key
    let name: String
    let type: String
    let description: String
    let location: Coordinate
}

//payload that matches Firebase JSON value (no `id` here)
private struct BikeStopPayload: Codable {
    let name: String
    let type: String
    let description: String
    let location: Coordinate
}

class BikeStopData: ObservableObject {
    @Published var bikeStops: [BikeStop] = []

    //Point directly to the "routes" node
    private let url = URL(string: "https://biciklisticki-vodic-default-rtdb.europe-west1.firebasedatabase.app/bikeStops.json")!

    init() {
        Task { await fetchBikeStops() }
    }

    @MainActor
    func fetchBikeStops() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            // Optional: quick sanity log to see bytes fetched
            print("Stops bytes:", data.count)

            // Decode as [id: RoutePayload] (payload has no id)
            let dict = try JSONDecoder().decode([String: BikeStopPayload].self, from: data)

            // Inject key as id and map to your Route model
            self.bikeStops = dict.map { key, value in
                BikeStop(
                    id: key,
                    name: value.name,
                    type: value.type,
                    description: value.description,
                    location: value.location
                )
            }
            .sorted { $0.name < $1.name }

            print("Loaded \(self.bikeStops.count) bike stops.")
        } catch {
            print("Error fetching/decoding bike stops:", error)
            self.bikeStops = []
        }
    }
}

