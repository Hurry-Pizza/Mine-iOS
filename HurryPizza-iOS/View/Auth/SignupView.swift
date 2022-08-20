//
//  SignupView.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import SwiftUI

struct SignupView: View {
    private let viewModel = SignupViewModel()
    
    var body: some View {
        Button {
            viewModel.signup()
        } label: {
            Text("Sign up")
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
