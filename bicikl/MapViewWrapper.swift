//
//  MapViewWrapper.swift
//  bicikl
//
//  Created by Heda Nikolić on 27.06.2024..
//

import SwiftUI
import MapKit
import UIKit

struct MapViewWrapper: UIViewRepresentable {
    var region: MKCoordinateRegion
    var bikeStops: [BikeStop]
    var routeData: RouteData
    var onSelectRoute: (Route) -> Void
    var onSelectBikeStop: (BikeStop) -> Void

    // Annotation carrying the BikeStop model
    private class BikeStopAnnotation: MKPointAnnotation {
        let stop: BikeStop
        init(stop: BikeStop) {
            self.stop = stop
            super.init()
            // If you want labels visible even without tap, uncomment:
            // self.title = stop.name
            self.coordinate = CLLocationCoordinate2D(
                latitude: stop.location.latitude,
                longitude: stop.location.longitude
            )
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewWrapper
        var selectedRouteName: String?   // currently highlighted route (or nil)

        init(parent: MapViewWrapper) {
            self.parent = parent
        }

        // ROUTE RENDERER – styles depend on whether this polyline is selected
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)

                if polyline.title == selectedRouteName {
                    // highlighted
                    renderer.strokeColor = UIColor.systemBlue
                    renderer.lineWidth = 7.0
                } else {
                    // normal (visible) state
                    renderer.strokeColor = UIColor.systemBlue.withAlphaComponent(0.5)
                    renderer.lineWidth = 4.0
                }
                return renderer
            }
            return MKOverlayRenderer()
        }

        // PIN VIEW – SF Symbol based on stop type (default iOS selection anim stays)
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation { return nil }

            if let a = annotation as? BikeStopAnnotation {
                let id = "BikeStop"
                let view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView
                    ?? MKMarkerAnnotationView(annotation: a, reuseIdentifier: id)

                view.annotation = a
                view.canShowCallout = true

                // choose SF Symbol by type
                let symbolName: String = {
                    switch a.stop.type.lowercased() {
                    case "pump":    return "fuelpump"
                    case "service": return "wrench.and.screwdriver.fill"
                    case "rent":    return "bicycle"
                    default:        return "mappin.circle"
                    }
                }()

                view.glyphImage = UIImage(systemName: symbolName)

                // optional: per-type colors
                switch a.stop.type.lowercased() {
                case "pump":    view.markerTintColor = .systemBlue
                case "service": view.markerTintColor = .systemGreen
                case "rent":    view.markerTintColor = .systemTeal
                default:        view.markerTintColor = .systemGray
                }

                // info button in the callout
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                
                return view
            }

            return nil
        }
        

        // When a bike stop pin is tapped, open detail (default selection clears when tapping elsewhere)
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let a = view.annotation as? BikeStopAnnotation {
                parent.onSelectBikeStop(a.stop)
            }
        }

        // Helper: restyle existing route renderers in place
        func restyleAllPolylines(_ mapView: MKMapView) {
            for overlay in mapView.overlays {
                guard let poly = overlay as? MKPolyline,
                      let r = mapView.renderer(for: poly) as? MKPolylineRenderer
                else { continue }

                if poly.title == selectedRouteName {
                    r.strokeColor = UIColor.systemBlue
                    r.lineWidth = 6.0
                } else {
                    r.strokeColor = UIColor.systemBlue.withAlphaComponent(0.5)
                    r.lineWidth = 4.0
                }
                r.setNeedsDisplay()
            }
        }

        // Route tap handler (closest polyline). Tap elsewhere clears highlight.
        @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
            let mapView = gestureRecognizer.view as! MKMapView
            let touchPoint = gestureRecognizer.location(in: mapView)
            let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)

            let closestPolyline = findClosestPolyline(to: touchMapCoordinate, in: mapView)

            if let polyline = closestPolyline,
               let routeName = polyline.title,
               let route = parent.routeData.routes.first(where: { $0.name == routeName }) {

                // Select this route
                selectedRouteName = routeName
                restyleAllPolylines(mapView)
                parent.onSelectRoute(route)

            } else {
                // Tap on empty area → clear route highlight and deselect pins
                selectedRouteName = nil
                restyleAllPolylines(mapView)
                mapView.deselectAnnotation(nil, animated: true)
            }
        }

        // Nearest-polyline helpers
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
            // threshold in meters
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
            if lengthSquared == 0 { return point.distance(to: pointA) }
            var t = ((point.x - pointA.x) * dx + (point.y - pointA.y) * dy) / lengthSquared
            t = max(0, min(1, t))
            let projection = MKMapPoint(x: pointA.x + t * dx, y: pointA.y + t * dy)
            return point.distance(to: projection)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)

        rebuildMapContent(mapView)

        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(context.coordinator.handleTapGesture(_:))
        )
        // important: don't swallow touches so annotation selection works normally
        tapGesture.cancelsTouchesInView = false
        mapView.addGestureRecognizer(tapGesture)

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Rebuild overlays/annotations whenever routeData/bikeStops change
        rebuildMapContent(uiView)
    }

    // Build all overlays/annotations
    private func rebuildMapContent(_ mapView: MKMapView) {
        // Clear overlays (routes) to avoid duplicates after data updates
        mapView.removeOverlays(mapView.overlays)

        // Keep user location if enabled; remove our annotations only
        let nonUserAnnotations = mapView.annotations.filter { !($0 is MKUserLocation) }
        mapView.removeAnnotations(nonUserAnnotations)

        // Bike stops (default selection behavior stays: enlarge until tap elsewhere)
        for stop in bikeStops {
            mapView.addAnnotation(BikeStopAnnotation(stop: stop))
        }

        // Routes
        renderAllRoutes(on: mapView)

        // Ensure initial styling reflects current selection (or none)
        // Force renderers to be created, then style via coordinator
        for overlay in mapView.overlays { _ = mapView.renderer(for: overlay) }
        if let coord = mapView.delegate as? Coordinator {
            coord.restyleAllPolylines(mapView)
        }
    }

    private func renderAllRoutes(on mapView: MKMapView) {
        for route in routeData.routes {
            addRoute(
                to: mapView,
                from: route.start.cl,
                via: route.via?.cl,
                to: route.end.cl,
                withName: route.name
            )
        }
    }

    // Draw a computed route with optional via
    func addRoute(
        to mapView: MKMapView,
        from sourceCoordinate: CLLocationCoordinate2D,
        via viaCoordinate: CLLocationCoordinate2D?,
        to destinationCoordinate: CLLocationCoordinate2D,
        withName name: String
    ) {
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)

        func request(_ a: MKMapItem, _ b: MKMapItem) -> MKDirections.Request {
            let r = MKDirections.Request()
            r.source = a
            r.destination = b
            r.transportType = .walking
            r.requestsAlternateRoutes = false
            return r
        }

        // If no via: single A→B request
        guard let viaCoordinate = viaCoordinate else {
            let directions = MKDirections(request: request(sourceItem, destinationItem))
            directions.calculate { response, error in
                if let error = error {
                    print("Error calculating directions (A→B): \(error.localizedDescription)")
                    return
                }
                guard let route = response?.routes.first else {
                    print("No routes found (A→B)")
                    return
                }
                let polyline = route.polyline
                polyline.title = name
                mapView.addOverlay(polyline)
            }
            return
        }

        // With via: A→via then via→B
        let viaItem = MKMapItem(placemark: MKPlacemark(coordinate: viaCoordinate))

        let d1 = MKDirections(request: request(sourceItem, viaItem))
        d1.calculate { res1, err1 in
            if let err1 = err1 {
                print("Error calculating directions (A→via): \(err1.localizedDescription)")
            } else if let r1 = res1?.routes.first {
                let pl1 = r1.polyline
                pl1.title = name
                mapView.addOverlay(pl1)
            } else {
                print("No routes found (A→via)")
            }

            let d2 = MKDirections(request: request(viaItem, destinationItem))
            d2.calculate { res2, err2 in
                if let err2 = err2 {
                    print("Error calculating directions (via→B): \(err2.localizedDescription)")
                } else if let r2 = res2?.routes.first {
                    let pl2 = r2.polyline
                    pl2.title = name
                    mapView.addOverlay(pl2)
                } else {
                    print("No routes found (via→B)")
                }
            }
        }
    }
}
