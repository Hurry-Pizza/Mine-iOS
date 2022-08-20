//
//  HomeView.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        LottieView(jsonName: "Mine")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
