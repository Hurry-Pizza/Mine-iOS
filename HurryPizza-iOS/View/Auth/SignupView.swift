//
//  SignupView.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import SwiftUI

struct SignupView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewmodel = SignupViewModel()
    
    @State var userName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    @State var isSignupCompleted: Bool
    
    var body: some View {
        ZStack {
            Image("loginBackground")
                .resizable()
            //				.scaledToFit()
            //				.aspectRatio(contentMode: .fit)
                .ignoresSafeArea()
            
            background()
            
            VStack {
                Spacer()
                    .frame(maxHeight: 106)
                
                Text("Sing Up")
                    .foregroundColor(.junctionBlack)
                    .font(.system(size: 28))
                    .fontWeight(.bold)
                
                Text("for save your area")
                    .foregroundColor(.junctionBlack)
                    .font(.system(size: 20))
                    .padding(.top, 6)
                
                Spacer().frame(maxHeight: 72)
                
                customTextFields()
                
                Spacer()
                
                signUpButton()
                    .onTapGesture {
                        viewmodel.signup(
                            email: email,
                            nickname: userName,
                            password: password
                        )
                        isSignupCompleted = true
                    }
            }
        }
    }
    
    @ViewBuilder
    private func background() -> some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(maxHeight: 61)
                
                Image("loginCloud")
                    .resizable()
                    .scaledToFit()
                
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private func customTextFields() -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
            
            VStack(spacing: 0) {
                customtextField("userName")
                
                customtextField("email")
                
                customtextField("password")
            }
        }
        .frame(width: 357, height: 180)
        .cornerRadius(13)
    }
    
    @ViewBuilder
    private func customtextField(_ imageName: String) -> some View {
        HStack(alignment: .center) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            
            switch imageName {
            case "userName":
                TextField("User name", text: $userName)
                    .padding(.leading, 24)
                
            case "email":
                TextField("Email", text: $email)
                    .padding(.leading, 24)
            case "password":
                SecureField("Password", text: $password)
                    .padding(.leading, 24)
            default:
                Spacer()
            }
        }
        .frame(height: 60)
    }
    
    @ViewBuilder
    private func signUpButton() -> some View {
        ZStack {
            Image("loginBottom")
                .resizable()
                .scaledToFit()
            
            VStack {
                Spacer()
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.junctionGreen)
                        .cornerRadius(13)
                        .frame(width: 359, height: 60)
                    
                    Text("Sign Up")
                        .foregroundColor(.junctionWhite)
                        .fontWeight(.semibold)
                        .font(.system(size: 20))
                }
                .padding(.leading, 16)
                .padding(.trailing, 15)
            }
            .frame(width: 390, height: 137)
        }
        
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(isSignupCompleted: false)
    }
}
