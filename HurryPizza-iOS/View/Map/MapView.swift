//
//  MapView.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import SwiftUI
import MapKit
import UIKit

struct MapView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
	@Published var region = MKCoordinateRegion()
	
	private let manager = CLLocationManager()
	
	var coordinates: [CLLocationCoordinate2D] = []
	
	override init() {
		super.init()
		manager.delegate = self
		manager.desiredAccuracy = kCLLocationAccuracyBest
		manager.requestWhenInUseAuthorization()
		manager.startUpdatingLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		locations.map { location in
			let center = CLLocationCoordinate2D(latitude: round(location.coordinate.latitude * 10000000) / 1000000, longitude: round(location.coordinate.longitude * 1000000) / 1000000)
			
			coordinates.append(center)
			
			let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
			region = MKCoordinateRegion(center: center, span: span)
		}
	}
} // Class LocationManager

class MapDelegate: UIViewController, MKMapViewDelegate {
	var map = MKMapView()
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if overlay is MKCircle {
				let renderer = MKCircleRenderer(overlay: overlay)
				renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
				renderer.strokeColor = UIColor.blue
				renderer.lineWidth = 2
				return renderer
			
			} else if overlay is MKPolyline {
				let renderer = MKPolylineRenderer(overlay: overlay)
				renderer.strokeColor = UIColor(named: "RouteColor")
				renderer.lineWidth = 3
				return renderer
			
			} else if overlay is MKPolygon {
				let renderer = MKPolygonRenderer(overlay: overlay)
				renderer.fillColor = UIColor(Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.25))
				renderer.strokeColor = UIColor.orange
				renderer.lineWidth = 2
				return renderer
			}
		
		return MKOverlayRenderer()
	}
}
