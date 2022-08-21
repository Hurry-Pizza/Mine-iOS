//
//  ContentView.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import SwiftUI

struct ContentView: View {
    @State var isContentReady : Bool = false
    
    var body: some View {
        
        ZStack{
            
           HomeView()
            
            if !isContentReady {
                SplashView()
                    .transition(.opacity)
            }
        }
        .onAppear{
            print("ContentView - onAppear() called")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                print("ContentView - 1.5초 뒤")
                withAnimation{isContentReady.toggle()}
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
