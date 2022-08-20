//
//  SignInView.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import SwiftUI

struct SigninView: View {
    private let viewModel = SigninViewModel()
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            TextField("Enter your email", text: $email)
                .padding()
            SecureField("Enter your password", text: $password)
                .padding()
            Button {
                viewModel.signin(email: email, password: password)
            } label: {
                Text("Sign in")
            }
        }
        .padding(.leading, 30)
        .padding(.trailing, 30)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView()
    }
}
