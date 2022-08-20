//
//  HomeView.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Image("mine_home_bg")
                
                LottieView(jsonName: "Mine")
                    .frame(width: 180, height: 240, alignment: .center)
                    .padding(.top, 30)
                
                VStack {
                    HStack {
                        Image("info_button")
                        Spacer()
                        Image("rank_button")
                    }
                    .padding(.top, 64)
                    .padding(.leading, 80)
                    .padding(.trailing, 80)
                    
                    Spacer()
                    
                    NavigationLink(destination: MapView()) {
                        ZStack {
                            Rectangle()
                                .frame(width: 359, height: 60, alignment: .center)
                                .cornerRadius(13)
                                .foregroundColor(.junctionWhite)
                            
                            HStack {
                                Spacer(minLength: 114)
                                
                                Text("Start your way")
                                    .foregroundColor(.junctionThirdGreen)
                                    .font(.system(size: 20, weight: .semibold, design: .default))
                                
                                Spacer()
                                
                                Image(systemName: "chevron.forward")
                                    .font(Font.system(size: 18, weight: .semibold))
                                    .foregroundColor(.junctionThirdGreen)
                                    .padding(.trailing, 10)
                            }
                        }
                        .padding(.leading, 80)
                        .padding(.trailing, 80)
                        .padding(.bottom, 110)
                    }
                }
                
            }
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
