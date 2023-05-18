//
//  TemplateCard.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/18/23.
//

import SwiftUI

struct TemplateCard: View {
    
    @State private var isSelected: Bool = false
    @Binding var editSelected: Bool
    var image: Image? = nil
    
    var body: some View {
        VStack(alignment: .center) {
            
            Button {
                print("Template Image Selected")
                withAnimation {
                    isSelected.toggle()
                }
            } label: {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.width * 0.15)
//                    .background(
//                        RoundedRectangle(cornerRadius: 20, style: .continuous)
//                            .stroke(isSelected ? AppColors.Onboarding.loginButton : .gray, lineWidth: 4)
//                        
//                            
//                    )
            }
            
            VStack(alignment: .leading) {
                Button {
                    print("Edit Template Selected")
                    editSelected = true
                } label: {
                    HStack {
                        AppImages.editIcon
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Edit")
                    }
                    .foregroundColor(AppColors.Onboarding.loginButton)
                    .padding(.leading)
                }
                
                Button {
                    print("Duplicate Template Selected")
                } label: {
                    HStack {
                        AppImages.duplicateIcon
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Duplicate")
                    }
                    .foregroundColor(AppColors.Onboarding.loginButton)
                    .padding(.leading)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
                .shadow(color: isSelected ? AppColors.Onboarding.loginButton.opacity(0.75) : .black.opacity(0.2), radius: isSelected ? 15 : 5, x: 0, y: 0)
        }
        .overlay {
            AppImages.checkSmall
                .resizable()
                .frame(width: 20, height: 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding()
                .opacity(isSelected ? 1 : 0)
        }
    }
}

struct TemplateCard_Previews: PreviewProvider {
    static var previews: some View {
        TemplateCard(editSelected: .constant(false))
    }
}
