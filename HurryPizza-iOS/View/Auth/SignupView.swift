//
//  SignupView.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import SwiftUI
import Combine

struct SignupView: View {
    @StateObject private var viewModel = SignupViewModel()
    
    @State private var email = ""
    @State private var nickname = ""
    @State private var password = ""
    
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        ZStack {
            Image("mine_home_bg")
                .scaledToFill()
            
            VStack {
                Spacer()
                
                VStack(alignment: .center, spacing: 10) {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                            .padding(.leading, 20)
                            .padding(.bottom, 10)
                        
                        TextField("Enter your email", text: $email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .padding(.top, 20)
                            .padding(.leading, 5)
                            .padding(.trailing, 20)
                            .padding(.bottom, 10)
                    }
                    
                    Divider()
                        .border(.gray, width: 2)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                            .padding(.leading, 20)
                            .padding(.bottom, 10)
                        
                        TextField("Enter your nickname", text: $nickname)
                            .textInputAutocapitalization(.never)
                            .padding(.top, 10)
                            .padding(.leading, 5)
                            .padding(.trailing, 20)
                            .padding(.bottom, 10)
                    }
                    
                    Divider()
                        .border(.gray, width: 2)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                            .padding(.leading, 20)
                            .padding(.bottom, 20)
                        
                        SecureField("Enter your password", text: $password)
                            .padding(.top, 10)
                            .padding(.leading, 5)
                            .padding(.trailing, 20)
                            .padding(.bottom, 20)
                    }
                }
                .background(Color.white)
                .cornerRadius(24)
                .padding(.leading, 30)
                .padding(.trailing, 30)
                
                HStack {
                    if $viewModel.isSignupFail.wrappedValue {
                        Text("회원가입에 실패했습니다.")
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                    ZStack(alignment: .topLeading) {
                        Button {
                            viewModel.signup(
                                email: email,
                                nickname: nickname,
                                password: password
                            )
                        } label: {
                            Text("Sign Up")
                                .frame(width: 120, height: 44, alignment: .center)
                                .foregroundColor(.white)
                        }
                        .background(AppColor.junction_blue.color)
                        .cornerRadius(12)
                        
                        Rectangle()
                            .fill(AppColor.junction_blue.color)
                            .frame(width: 20, height: 20, alignment: .topLeading)
                    }
                }
                .padding(.leading, 30)
                .padding(.trailing, 30)
            }
            .padding(.bottom, self.keyboardHeight > 0 ? 200 : 120)
            .onReceive(Publishers.keyboardHeight) {
                self.keyboardHeight = $0
            }
        }
        .ignoresSafeArea()
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
