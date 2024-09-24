//
//  MapViewWrapper.swift
//  bicikl
//
//  Created by Heda Nikolić on 27.06.2024..
//

import SwiftUI
import MapKit

struct MapViewWrapper: UIViewRepresentable {
    var region: MKCoordinateRegion
    var bikeStops: [BikeStop]
    var routeData: RouteData
    var onSelectRoute: (Route) -> Void

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewWrapper

        init(parent: MapViewWrapper) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 4.0
                return renderer
            }
            return MKOverlayRenderer()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: true)

        // Add annotations for bike stops
        for bikeStop in bikeStops {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: bikeStop.latitude, longitude: bikeStop.longitude)
            annotation.title = bikeStop.name
            mapView.addAnnotation(annotation)
        }

        
        let routes: [(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D)] = [
            (start: CLLocationCoordinate2D(latitude: 45.56119, longitude: 18.68025), end: CLLocationCoordinate2D(latitude: 45.55241, longitude: 18.73033)), // Kapucinska - Zeleno polje
            (start: CLLocationCoordinate2D(latitude: 45.55819, longitude: 18.68273), end: CLLocationCoordinate2D(latitude: 45.55446, longitude: 18.72192)), // Trznica - Trg bana J. J.
            (start: CLLocationCoordinate2D(latitude: 45.56696, longitude: 18.66481), end: CLLocationCoordinate2D(latitude: 45.55830, longitude: 18.70706)), // Promenada(desna obala)
            (start: CLLocationCoordinate2D(latitude: 45.56764, longitude: 18.66958), end: CLLocationCoordinate2D(latitude: 45.56335, longitude: 18.71748)), // Promenada(lijeva obala)
            (start: CLLocationCoordinate2D(latitude: 45.54529, longitude: 18.69267), end: CLLocationCoordinate2D(latitude: 45.56134, longitude: 18.70059)), // Gradski vrt - Tudmanov most
            (start: CLLocationCoordinate2D(latitude: 45.56273, longitude: 18.70186), end: CLLocationCoordinate2D(latitude: 45.59401, longitude: 18.74005)), // Tudmanov most - Bilje
            (start: CLLocationCoordinate2D(latitude: 45.56034, longitude: 18.68564), end: CLLocationCoordinate2D(latitude: 45.55722, longitude: 18.69680)), // Stepinceva - Trpimirova
            (start: CLLocationCoordinate2D(latitude: 45.54519, longitude: 18.68119), end: CLLocationCoordinate2D(latitude: 45.54677, longitude: 18.72901)), // Gacka - Divaltova
            (start: CLLocationCoordinate2D(latitude: 45.55885, longitude: 18.66218), end: CLLocationCoordinate2D(latitude: 45.55727, longitude: 18.68585)), // Gundulićeva
            (start: CLLocationCoordinate2D(latitude: 45.54202, longitude: 18.70901), end: CLLocationCoordinate2D(latitude: 45.55868, longitude: 18.70540)), // Svačićeva
            (start: CLLocationCoordinate2D(latitude: 45.54241, longitude: 18.70895), end: CLLocationCoordinate2D(latitude: 45.54349, longitude: 18.71831)), // Opatijska
            (start: CLLocationCoordinate2D(latitude: 45.54389, longitude: 18.69671), end: CLLocationCoordinate2D(latitude: 45.54286, longitude: 18.70154)), // Ul. Woodrowa Wilsona - Kutinska
            (start: CLLocationCoordinate2D(latitude: 45.55422, longitude: 18.67573), end: CLLocationCoordinate2D(latitude: 45.54631, longitude: 18.67865)), // Vinkovačka
            (start: CLLocationCoordinate2D(latitude: 45.54157, longitude: 18.64762), end: CLLocationCoordinate2D(latitude: 45.55112, longitude: 18.63393)), // Borova - Portanova
            (start: CLLocationCoordinate2D(latitude: 45.55612, longitude: 18.63499), end: CLLocationCoordinate2D(latitude: 45.55729, longitude: 18.64051)), // Svilajska (uz Portanovu)
            (start: CLLocationCoordinate2D(latitude: 45.55622, longitude: 18.67854), end: CLLocationCoordinate2D(latitude: 45.55823, longitude: 18.67843)), // Prolaz Ante Slaviceka
            (start: CLLocationCoordinate2D(latitude: 45.54949, longitude: 18.69810), end: CLLocationCoordinate2D(latitude: 45.55214, longitude: 18.70159)) // Setaliste Joze Petrovica (Sjenjak)
        ]
        
        
        for (index, route) in routes.enumerated() {
            let routeName = routeData.routes[index].name
            addRoute(to: mapView, from: route.start, to: route.end, withName: routeName)
        }

        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTapGesture(_:)))
        mapView.addGestureRecognizer(tapGesture)

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update the map view if needed
    }

    func addRoute(to mapView: MKMapView, from sourceCoordinate: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D, withName name: String) {
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print("Error calculating directions: \(error.localizedDescription)")
                return
            }
            guard let route = response?.routes.first else {
                print("No routes found")
                return
            }
            print("Route calculated: \(route)")
            let polyline = route.polyline
            polyline.title = name
            mapView.addOverlay(polyline)
        }
    }
}
// Setting the tap gesture for routes
extension MapViewWrapper.Coordinator {
    @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        let mapView = gestureRecognizer.view as! MKMapView
        let touchPoint = gestureRecognizer.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)

        // Find the closest polyline
        let closestPolyline = findClosestPolyline(to: touchMapCoordinate, in: mapView)

        if let polyline = closestPolyline {
            if let routeName = polyline.title, let route = parent.routeData.routes.first(where: { $0.name == routeName }) {
                parent.onSelectRoute(route)
            }
        }
    }

    func findClosestPolyline(to coordinate: CLLocationCoordinate2D, in mapView: MKMapView) -> MKPolyline? {
        var closestPolyline: MKPolyline? = nil
        var closestDistance: CLLocationDistance = .greatestFiniteMagnitude

        for overlay in mapView.overlays {
            if let polyline = overlay as? MKPolyline {
                let distance = distance(from: coordinate, to: polyline)
                if distance < closestDistance {
                    closestDistance = distance
                    closestPolyline = polyline
                }
            }
        }
        // Set your desired threshold distance here
        return closestDistance < 20 ? closestPolyline : nil
    }

    func distance(from coordinate: CLLocationCoordinate2D, to polyline: MKPolyline) -> CLLocationDistance {
        var minDistance: CLLocationDistance = .greatestFiniteMagnitude

        let point = MKMapPoint(coordinate)

        for i in 0..<polyline.pointCount - 1 {
            let pointA = polyline.points()[i]
            let pointB = polyline.points()[i + 1]

            let segmentDistance = distanceFromPoint(point, toSegmentBetween: pointA, and: pointB)
            minDistance = min(minDistance, segmentDistance)
        }

        return minDistance
    }

    func distanceFromPoint(_ point: MKMapPoint, toSegmentBetween pointA: MKMapPoint, and pointB: MKMapPoint) -> CLLocationDistance {
        let dx = pointB.x - pointA.x
        let dy = pointB.y - pointA.y
        let lengthSquared = dx * dx + dy * dy

        if lengthSquared == 0 {
            return point.distance(to: pointA)
        }

        var t = ((point.x - pointA.x) * dx + (point.y - pointA.y) * dy) / lengthSquared
        t = max(0, min(1, t))

        let projection = MKMapPoint(x: pointA.x + t * dx, y: pointA.y + t * dy)
        return point.distance(to: projection)
    }
}
