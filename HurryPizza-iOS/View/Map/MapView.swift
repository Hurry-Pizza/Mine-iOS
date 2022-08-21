//
//  MapView.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

// TODO: 거리가 23이내로 들어오면 만들어주기 최소 5개의 점을 찍고난 후

import SwiftUI
import MapKit
import UIKit
import Combine

struct MapView: View {
    @Environment(\.presentationMode) var presentationMode
    
	@StateObject private var manager = LocationManager()
	@State private var lineCoorinate: [CLLocationCoordinate2D] = []
	@State private var showCompleteModal: Bool = true
    
    private let mapDelegate = MapDelegate()

	var body: some View {
		ZStack {
			CustomMapView(
				point: manager.region,
				coordinates: $manager.coordinates,
				delegate: mapDelegate,
				map: mapDelegate.map,
				lineCoordinates: $manager.lineCoordinates,
				showCompleteModal: $showCompleteModal,
                needToCapture: $manager.needToCaptureMap,
				manager: manager
            )

			Rectangle()
				.foregroundColor(.blue)
				.cornerRadius(20)
				.frame(width: 10, height: 10)
            
            VStack {
                HStack {
                    Button {
						manager.manager.stopUpdatingLocation()
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.junctionRed)
                                .cornerRadius(12)
                                .frame(width: 100, height: 40)
                            
                            Text("Quit")
                                .font(.system(size: 20, weight: .semibold, design: .default))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(.junctionBlack)
                            .cornerRadius(8)
                            .frame(width: 120, height: 40)
                        
                        HStack {
                            Image("timer_icon")
                                .font(.system(size: 22))
                            
                            Text("\(Int(exactly: $manager.elapsedSeconds.wrappedValue / 3600)!)h \(Int(exactly: $manager.elapsedSeconds.wrappedValue / 60)!)m")
                                .font(.system(size: 20, weight: .semibold, design: .default))
                                .foregroundColor(.junctionWhite)
                        }
                    }
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
                .padding(.top, 64)
                
                Spacer()
            }
            
            if manager.elapsedSeconds > 5 && manager.capturedMap != nil {
                MapConfirmPopUPView(
                    pathList: manager.coordinates,
                    mapImage: manager.capturedMap!
                )
            }
            
            if showCompleteModal && manager.capturedMap != nil {
                MapConfirmPopUPView(
                    pathList: manager.coordinates,
                    mapImage: manager.capturedMap!
                )
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .onAppear(perform: {
            self.manager.initializeTimer()
        })
	}
}

struct CustomMapView: UIViewRepresentable {
	var point: MKCoordinateRegion

	@Binding var coordinates: [CLLocationCoordinate2D]

	let delegate: MapDelegate

	@State var map: MKMapView
	@State var isDrawn: Bool = false

	@Binding var lineCoordinates: [CLLocationCoordinate2D]
	@Binding var showCompleteModal: Bool
    @Binding var needToCapture: Bool
	var manager: LocationManager

	func makeUIView(context: Context) -> some UIView {
		map.setRegion(point, animated: true)
		map.isZoomEnabled = false
		map.isPitchEnabled = false
		map.isScrollEnabled = false
		map.delegate = delegate

		return map
	}

	func updateUIView(_ uiView: UIViewType, context: Context) {

		let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
		map.setRegion(MKCoordinateRegion(center: lineCoordinates.last ?? point.center, span: span), animated: true)

		if lineCoordinates.count > 1 {
			Task {
				let line = MKPolyline(coordinates: lineCoordinates, count: coordinates.count)

				map.addOverlay(line)
			}
			if lineCoordinates.count > 5 && fetchDistance(lineCoordinates.first!, lineCoordinates.last!) < 23 {
				showCompleteModal.toggle()
				
				manager.manager.stopUpdatingLocation()
				
				var finalLatitude = 0.0
				var finalLongitude = 0.0
				
				for ele in lineCoordinates {
					finalLatitude += ele.latitude
					finalLongitude += ele.longitude
				}
				
				finalLatitude /= Double(lineCoordinates.count)
				finalLongitude /= Double(lineCoordinates.count)
				
				let finalCoordinate = CLLocationCoordinate2D(latitude: finalLatitude, longitude: finalLongitude)
				
				let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
				map.setRegion(.init(center: finalCoordinate, span: span), animated: false)
				
                needToCapture = true
			}
		}

	}
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
	@Published var region = MKCoordinateRegion()
	@Published var currentCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
	@Published var lineCoordinates: [CLLocationCoordinate2D] = []
	@Published var coordinates: [CLLocationCoordinate2D] = []
    @Published var elapsedSeconds: Int = 0
    @Published var capturedMap: Image?
    @Published var needToCaptureMap: Bool = false
    
    private var timer: Timer?
    
	let manager = CLLocationManager()
    
    private var subscription = Set<AnyCancellable>()

	override init() {
		super.init()
		manager.delegate = self
		manager.desiredAccuracy = kCLLocationAccuracyBest
		manager.requestWhenInUseAuthorization()
		manager.startUpdatingLocation()
	}
    
    func initializeTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(addSecond),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc
    func addSecond() {
        self.elapsedSeconds += 1
        
        #warning("TODO: 테스트용 지워야 됨")
        // TODO: 테스트용 지워야 됨
//        if capturedMap == nil && (self.elapsedSeconds > 5 || needToCaptureMap) {
        if capturedMap == nil && needToCaptureMap {
            capturedMap = Image(uiImage: takeCapture())
        }
    }
    
    func takeCapture() -> UIImage {
        var image: UIImage?
        guard let currentLayer = UIApplication.shared.windows.first { $0.isKeyWindow }?.layer else { return UIImage() }
        let currentScale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(currentLayer.frame.size, false, currentScale)
        guard let currentContext = UIGraphicsGetCurrentContext() else { return UIImage() }
        currentLayer.render(in: currentContext)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.map { location in
			let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
			let center = CLLocationCoordinate2D(latitude: round(location.coordinate.latitude * 10_000_000) / 10_000_000, longitude: round(location.coordinate.longitude * 1_000_000) / 1_000_000)

            if lineCoordinates.isEmpty {
                lineCoordinates.append(center)
                region = MKCoordinateRegion(center: center, span: span)
			}
            
			coordinates.append(center)

			if coordinates.count >= 10 {
				let averageCoordinate = averageCoordinate()
				print("Distance :", CLLocation(latitude: lineCoordinates.last!.latitude, longitude: lineCoordinates.last!.longitude)
					.distance(from: CLLocation(latitude: averageCoordinate.latitude, longitude: averageCoordinate.longitude)))
				if fetchDistance(lineCoordinates.last!, averageCoordinate) > 23 {
					lineCoordinates.append(averageCoordinate)
					print("Line ] ", lineCoordinates, averageCoordinate)
					coordinates = []
				} else {
					coordinates = []
				}
			}
		}
	}

	func averageCoordinate() -> CLLocationCoordinate2D {
		var averageLatitude = 0.0
		var averageLongitude = 0.0

		for ele in coordinates {
			averageLatitude += ele.latitude
			averageLongitude += ele.longitude
		}

		averageLatitude /= Double(coordinates.count)
		averageLongitude /= Double(coordinates.count)

		var averageLocation = CLLocation(latitude: averageLatitude, longitude: averageLongitude)
		var exceptCoordinate = coordinates[0]
		var exceptIndex = 0

		for i in 1..<coordinates.count {
			if averageLocation.distance(from: CLLocation(latitude: coordinates[i].latitude, longitude: coordinates[i].longitude)) >
				averageLocation.distance(from: CLLocation(latitude: exceptCoordinate.latitude, longitude: exceptCoordinate.longitude)) {
				exceptCoordinate = coordinates[i]
				exceptIndex = i
			}
		}

		coordinates.remove(at: exceptIndex)

		averageLatitude = 0.0
		averageLongitude = 0.0

		for ele in coordinates {
			averageLatitude += ele.latitude
			averageLongitude += ele.longitude
		}
		averageLatitude /= Double(coordinates.count)
		averageLongitude /= Double(coordinates.count)

		print("Ave :", averageLatitude, averageLongitude)
		return CLLocationCoordinate2D(latitude: averageLatitude, longitude: averageLongitude)
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
			print("Coordinate :", overlay.coordinate)
			if overlay.coordinate.latitude < 30 || overlay.coordinate.latitude > 37 || overlay.coordinate.longitude < 123 || overlay.coordinate.longitude > 132 {
				return MKOverlayRenderer()
			}
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

fileprivate func fetchDistance(_ coordinate1: CLLocationCoordinate2D, _ coordinate2: CLLocationCoordinate2D) -> Double {
	return CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
		.distance(from: CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude))
}
