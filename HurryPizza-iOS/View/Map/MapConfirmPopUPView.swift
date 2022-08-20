//
//  MapConfirmPopUPView.swift
//  HurryPizza-iOS
//
//  Created by Inho Choi on 2022/08/20.
//

import SwiftUI
import CoreLocation

struct MapConfirmPopUPView: View {
    var pathList: [CLLocationCoordinate2D]
    @State private var showModal = false
    
    var body: some View {
		ZStack {
			Rectangle()
				.foregroundColor(Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.5))
				.ignoresSafeArea()
			
			Card()
			
		}
    }
	
	@ViewBuilder
	private func Card() -> some View {
		ZStack {
			Rectangle()
				.foregroundColor(.junctionWhite)
				.cornerRadius(17)
			
			VStack {
				Text("Congratulations!")
					.foregroundColor(.junctionThirdGreen)
					.font(.title3)
					.padding(.top, 24)
				
				Text("Do you want to save this area?")
					.foregroundColor(.junctionGray)
					.font(.system(size: 17))
					.padding(.top, 5)
				
				Rectangle()
					.foregroundColor(.gray)
					.cornerRadius(13)
					.padding(.top, 22)
					.frame(width: 309, height: 320)
				
				Spacer()
				
				CustomButton()
			}
		}
		.cornerRadius(17)
		.frame(width: 358, height: 501)
		
	}
	
	@ViewBuilder
	private func CustomButton() -> some View {
        
		HStack(spacing: 0) {
			ZStack {
				Rectangle()
					.foregroundColor(Color(hex: "70A072"))
				
				Text("Cancel")
					.foregroundColor(Color(hex: "A6CDA7"))
			}
			ZStack {
				Rectangle()
					.foregroundColor(.junctionGreen)
				
				Text("Save")
					.foregroundColor(.junctionWhite)
			}
            .onTapGesture {
                RouteManager.shared.savePathAtUserDefaults(pathList)
                showModal = true
            }
            .fullScreenCover(isPresented: $showModal) {
                SignupView()
            }
		}
		.frame(height: 63)
	}
}

struct MapConfirmPopUPView_Previews: PreviewProvider {
    static var previews: some View {
        MapConfirmPopUPView(pathList: [])
    }
}
