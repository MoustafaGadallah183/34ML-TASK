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
            .shadow(color: Color.black.opacity(0.4), radius: 4)
            .overlay(
                
                VStack {
                    HStack {
                        
                        if experienceModel.recommended == 1 {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                                
                                Text("Recommended")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(12)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "info.circle")
                            .font(.title2)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .padding(12)
                    
                    Spacer()
                }
            )
            .padding(.horizontal, 10)
            .padding(.top, 10)
            
            HStack {
                Text(experienceModel.title ?? "")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .fontWeight(.bold)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 3) {
                    Text("\(experienceModel.likesNo ?? 0)")
                        .foregroundColor(.black)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(.orange)
                        .onTapGesture {
                            Task {
                                await vm.likeExperience(experienceModel.id ?? "")
                            }
                        }
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        }
        .sheet(isPresented: $vm.showDetail) {
            if let item = vm.selectedExperimentModel {
                HomeDetailsView(experienceModel: item)
            }
        }
    }
}
