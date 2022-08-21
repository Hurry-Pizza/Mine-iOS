//
//  MapConfirmPopUPView.swift
//  HurryPizza-iOS
//
//  Created by Inho Choi on 2022/08/20.
//

import SwiftUI
import CoreLocation

struct MapConfirmPopUPView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var pathList: [CLLocationCoordinate2D]
    var mapImage: Image
    @State private var showModal = false
    
    @State var isSignupCompleted: Bool
    
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

                mapImage
					.foregroundColor(.gray)
					.padding(.top, 22)
					.frame(width: 309, height: 320)
                    .cornerRadius(13)
                    .scaledToFill()
                    .clipped()
				
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
            .onTapGesture {
                self.presentationMode.wrappedValue.dismiss()
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
                SignupView(isSignupCompleted: isSignupCompleted)
            }
		}
		.frame(height: 63)
	}
}

struct MapConfirmPopUPView_Previews: PreviewProvider {
    static var previews: some View {
        MapConfirmPopUPView(pathList: [], mapImage: Image(systemName: "person"), isSignupCompleted: false)
    }
}
