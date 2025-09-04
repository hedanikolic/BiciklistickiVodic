//
//  RouteData.swift
//  bicikl
//
//  Created by Heda Nikolić on 27.06.2024..
//

import Foundation
import CoreLocation

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
    
    var cl: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct Route: Identifiable, Codable {
    var id: String          // Firebase key
    let name: String
    let description: String
    let start: Coordinate
    let via: Coordinate?    // optional midpoint
    let end: Coordinate
}

//payload that matches Firebase JSON value (no `id` here)
private struct RoutePayload: Codable {
    let name: String
    let description: String
    let start: Coordinate
    let via: Coordinate?
    let end: Coordinate
}

class RouteData: ObservableObject {
    @Published var routes: [Route] = []

    //Point directly to the "routes" node
    private let url = URL(string: "https://biciklisticki-vodic-default-rtdb.europe-west1.firebasedatabase.app/routes.json")!

    init() {
        Task { await fetchRoutes() }
    }

    @MainActor
    func fetchRoutes() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            // Optional: quick sanity log to see bytes fetched
            print("Routes bytes:", data.count)

            // Decode as [id: RoutePayload] (payload has no id)
            let dict = try JSONDecoder().decode([String: RoutePayload].self, from: data)

            // Inject key as id and map to your Route model
            self.routes = dict.map { key, value in
                Route(
                    id: key,
                    name: value.name,
                    description: value.description,
                    start: value.start,
                    via: value.via,
                    end: value.end
                )
            }
            .sorted { $0.name < $1.name }

            print("Loaded \(self.routes.count) routes.")
        } catch {
            print("Error fetching/decoding routes:", error)
            self.routes = []
        }
    }
}

