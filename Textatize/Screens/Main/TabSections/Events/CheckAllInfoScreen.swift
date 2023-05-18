//
//  CheckAllInfoScreen.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/18/23.
//

import SwiftUI

struct CheckAllInfoScreen: View {
    @Environment(\.dismiss) var dismiss
    
    var name: String
    var date: String
    var location: String
    var orientation: String
    var camera: String
    var hostName: String
    
    var body: some View {
        ZStack {
            AppColors.Onboarding.redLinearGradientBackground
                .ignoresSafeArea()
            
            Button {
                dismiss()
            } label: {
                HStack {
                    Image(systemName: "arrow.left")
                    Text("Back")
                }
                .accentColor(AppColors.Onboarding.loginScreenForegroundColor)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            
            VStack {
                
                Text("Check all Information")
                    .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
                
                Spacer()
                
                VStack {
                    
                    Text("Description")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                        .padding()
                    
                    HStack(spacing: 0) {
                        
                        VStack(spacing: 15) {
                            Group {
                                HStack {
                                    Text("Name: ")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text(name)
                                        .font(.caption)
                                }
                                
                                HStack {
                                    Text("Date: ")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text(date)
                                        .font(.caption)
                                }
                                
                                HStack {
                                    Text("Location: ")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text(location)
                                        .font(.caption)
                                }
                               
                            }
                            .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        
                        VStack(spacing: 15) {
                            
                            Group {
                                HStack {
                                    Text("Orientation: ")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text(orientation)
                                        .font(.caption)
                                }
                                
                                HStack {
                                    Text("Camera: ")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text(camera)
                                        .font(.caption)
                                }
                                
                                HStack {
                                    Text("Host Name: ")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text(hostName)
                                        .font(.caption)
                                }
                               
                            }
                            .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    
                    Text("Template")
                        .font(.headline)
                        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()

                    HStack {
                        ForEach(0..<3) { _ in
                            Image(systemName: "photo")
                                .resizable()
                                .padding()
                                .frame(width: UIScreen.main.bounds.width * 0.20, height: UIScreen.main.bounds.width * 0.20)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    Text("Gallery")
                        .font(.headline)
                        .foregroundColor(AppColors.Onboarding.loginScreenForegroundColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()

                    HStack {
                        ForEach(0..<3) { _ in
                            Image(systemName: "photo")
                                .resizable()
                                .padding()
                                .frame(width: UIScreen.main.bounds.width * 0.20, height: UIScreen.main.bounds.width * 0.20)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                }
                
                Spacer()
                
                CustomButtonView(filled: true, name: "Save")
                    .padding()
                
            }
            .customBackground()
            .padding(.vertical, 45)
            .padding(.horizontal)
            
        }
    }
}

struct CheckAllInfoScreen_Previews: PreviewProvider {
    static var previews: some View {
        CheckAllInfoScreen(name: "Holidays", date: "10/11/12", location: "Rome", orientation: "Portrait", camera: "Front", hostName: "Anna")
    }
}
