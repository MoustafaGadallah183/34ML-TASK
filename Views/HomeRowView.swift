//
//  HomeRowView.swift
//  34MLTask
//
//  Created by Moustafa Mohamed Gadallah on 11/12/1446 AH.
//

import SwiftUI
struct HomeRowView: View {
    
    @EnvironmentObject var vm : HomeViewModel
    var experienceModel: ExperienceModel
    var body: some View {
        VStack(spacing: 5) {
            
            RemoteImageView(
                url: URL(string: experienceModel.coverPhoto ?? ""),
                contentMode: .fill,
                height: 200,
                experienceModel: experienceModel
                
            )
            .cornerRadius(10)
            .clipped()
            .shadow( color: Color.black.opacity(0.4),radius: 4)
            .padding(10)

            HStack {
                    Text(experienceModel.title ?? "")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .fontWeight(.bold)
                        .lineLimit(nil)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                 
                HStack(spacing: 3){
                        Text("\(experienceModel.likesNo ?? 0)")
                            
                            .foregroundColor(.black)
                            .font(.headline)
                            .fontWeight(.bold)
                     
                        Image(systemName: "heart.fill")
                            .foregroundColor(.orange)
                        
                    }
               
            }
        
        
        }  .sheet(isPresented: $vm.showDetail) {
            if let item = vm.selectedExperimentModel {
            HomeDetailsView( experienceModel: item)
            }
            
        }
    
   
    
    }
}


