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
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.Onboarding.redLinearGradientBackground
                    .ignoresSafeArea(edges: .top)
                
                VStack {
                    Spacer()
                    Text("Settings")
                        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                        .font(.title)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    
                    VStack(spacing: 15) {
                        
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
                                    Text("10 Points")
                                        .foregroundColor(AppColors.Onboarding.loginButton)
                                        .font(.headline)
                                }
                                .padding()
                                
                                Spacer()
                                
                                Button {
                                    Task {
                                        guard let product = viewModel.products.first else { return }
                                        await viewModel.purchase(product: product)

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
                        Spacer()
                        
                        Button {
                            logout()
                        } label: {
                            CustomButtonView(filled: true, name: "Logout")
                                .padding()
                        }
                        
                    }
                }
                .customBackground()
            }
            .onAppear {
                Task {
                    await viewModel.fetchProducts()
                }
            }
            .toolbar(.hidden)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    private func logout() {
        TextatizeLoginManager.shared.logout()
    }
    
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
