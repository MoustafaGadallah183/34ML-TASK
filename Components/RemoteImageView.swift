//
//  RemoteImageView.swift
//  34MLTask
//
//  Created by Moustafa Mohamed Gadallah on 11/12/1446 AH.
//

import SwiftUI
import Kingfisher

struct RemoteImageView: View {
    
    let url: URL?
    var contentMode: SwiftUI.ContentMode = .fill
    var cornerRadius: CGFloat = 12
    var height: CGFloat? = nil
    var experienceModel: ExperienceModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                }
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .frame(maxWidth: .infinity)
                .ifLet(height) { view, height in
                    view.frame(height: height)
                }
                .clipped()
                .cornerRadius(cornerRadius)
         
            
            HStack {
                
                HStack(spacing: 5) {
                    Image(systemName: "eye.fill")
                        .foregroundColor(.white)
                    
                    
                    Text(experienceModel.viewsNo?.description ?? "")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                    
                }
                .padding(.leading , 15)
                
                Spacer()
                
                Image(systemName: "photo.on.rectangle.angled")
                    .foregroundColor(.white)
                    .padding(6)
                
                    .padding( .trailing, 20)
            }
       
        }
      
        
        .frame(maxWidth: .infinity)
        
        
    }
}

extension View {
    @ViewBuilder
    func ifLet<T, Content: View>(
        _ value: T?,
        transform: (Self, T) -> Content
    ) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
}
