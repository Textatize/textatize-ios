//
//  SettingsScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/17/23.
//

import SwiftUI

struct SettingsScreen: View {
    
    @StateObject private var viewModel = SettingsScreenViewModel.shared
    
    @State private var showContactInformationScreen = false
    @State private var showPasswordChangeScreen = false
    
    @State private var apiText = ""
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.Onboarding.redLinearGradientBackground
                    .ignoresSafeArea(edges: .top)
                
                VStack {
                    //Spacer()
                    Text("Settings")
                        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                        .font(.title)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top)
                    
                    VStack(spacing: 10) {
                        
                        NavigationLink {
                            ChangePasswordScreen()
                        } label: {
                            SettingsButton(name: "Password Change")
                        }
                        
                        VStack(spacing: 5) {
                            
                            Text("Your balance")
                                .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                                .fontWeight(.semibold)
                                .font(.title2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            HStack {
                                
                                HStack {
                                    AppImages.settings.logo3
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                    Text("\(viewModel.userPoints) Points")
                                        .foregroundColor(AppColors.Onboarding.loginButton)
                                        .font(.headline)
                                }
                                .padding()
                                
                                Spacer()
                                
                                Button {
                                    Task {
                                        guard let product = viewModel.products.first else { return }
                                        viewModel.purchase(product: product)

                                    }
                                } label: {
                                    CustomButtonView(filled: true, name: "Buy points")
                                        .opacity(!viewModel.products.isEmpty ? 1 : 0)
                                        .scaleEffect(!viewModel.products.isEmpty ? 1 : 0.5)
                                        .frame(width: UIScreen.main.bounds.width * 0.25)
                                        .padding(.trailing)
                                }
                            }
                            .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: 100)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(AppColors.Onboarding.loginButton, lineWidth: 2)
                            )
                            .padding()
                            
                        }
                        
                        Spacer()
                        
//                        VStack(alignment: .leading) {
//                            
//                            VStack(alignment: .leading) {
//                                Text("API Key")
//                                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
//                                    .font(.caption)
//                                
//                                TextField("Enter API Key", text: $viewModel.userAPIKey)
//                                    .foregroundColor(.black)
//                                    .padding()
//                                    .frame(height: 50)
//                                    .onboardingBorder()
//                            }
//                            .padding(.top)
//                            
//                        }
//                        .padding()
                        
//                        Button {
//                            viewModel.setAPI()
//                        } label: {
//                            CustomButtonView(filled: false, name: "Set API")
//                                .padding()
//                        }
                        
                        Button {
                            viewModel.logout()
                        } label: {
                            CustomButtonView(filled: true, name: "Logout")
                                .padding(.horizontal)
                                .padding(.bottom)
                        }

                    }
                }
                .customBackground()
            }
            .onAppear {
                viewModel.fetchProducts()
                viewModel.getAPIKey()
            }
            .toolbar(.hidden)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    private func logout() {
        TextatizeLoginManager.shared.logout()
    }
    private func setAPI() {
        if viewModel.userAPIKey == "" {
            alertTitle = "Error"
            alertMessage = "Field is empty"
            showAlert = true
        } else {
            let trimAPIKey = viewModel.userAPIKey.trimmingCharacters(in: .whitespacesAndNewlines)
            TextatizeAPI.shared.setAPI(apiKey: trimAPIKey) { error, response in
                if let error = error {
                    print("Error: \(error)")
                }
                
                if response != nil {
                    alertTitle = "Success"
                    alertMessage = "API Key Updated"
                    showAlert = true
                }
            }
        }
    }
}

struct SettingsButton: View {
    var name: String = ""
    var body: some View {
        HStack {
            Text(name)
                .padding()
            Spacer()
            AppImages.EventCard.arrowSmall
                .padding()
            
        }
        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: 50)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(AppColors.Onboarding.loginButton, lineWidth: 2)
        )
        .padding()
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
