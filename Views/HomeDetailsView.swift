//
//  HomeDetailsView.swift
//  34MLTask
//
//  Created by Moustafa Mohamed Gadallah on 12/12/1446 AH.
//

import SwiftUI
import Kingfisher

struct HomeDetailsView: View {
    
    var experienceModel: ExperienceModel
    @EnvironmentObject var vm: HomeViewModel
    @StateObject private var detailsVM = HomeDetailsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                experienceImageSection
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top) {
                        titleSection
                        Spacer()
                        actionsSection
                    }
                    Divider()
                    descriptionSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
        
        .background(Color(.systemBackground))
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .top)
        .onAppear {
         
            detailsVM.details = experienceModel
            detailsVM.getExperiencesDetails(experience: experienceModel)
        }
        .animation(.easeInOut(duration: 0.3), value: detailsVM.details?.id)
    }
    
    private var experienceImageSection: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                if let urlString = detailsVM.details?.coverPhoto,
                   let url = URL(string: urlString) {
                    KFImage(url)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: 400)
                        .clipped()
                } else if detailsVM.isLoading {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.orange.opacity(0.3), Color.brown.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: geo.size.width, height: 400)
                        .overlay(
                            ProgressView()
                                .scaleEffect(1.2)
                                .tint(.white)
                        )
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: geo.size.width, height: 400)
                }
                
                LinearGradient(
                    colors: [Color.clear, Color.black.opacity(0.4)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: geo.size.width, height: 400)
                
                VStack(spacing: 16) {
                    Button(action: {
                    }) {
                        Text("EXPLORE NOW")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.orange)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 14)
                            .background(Color.white, in: Rectangle())
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
                    }
                    
                    HStack {
                        Image(systemName: "eye")
                            .foregroundColor(.white)
                        Text("\(detailsVM.details?.viewsNo ?? 0) views")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                        
                        Spacer()
                        
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .frame(height: 400)
        }
        .frame(height: 400)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(detailsVM.details?.title ?? "")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .frame(minHeight: 35)
                .frame(maxWidth: .infinity, alignment: .leading)
    
            
            HStack(spacing: 6) {
                Image(systemName: "location")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    
                Text(detailsVM.details?.city?.fullname ?? "")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .frame(minHeight: 20)
                    .fontWeight(.semibold)
                
            }
        }
    }
    
    private var actionsSection: some View {
        HStack(spacing: 12) {
            Button(action: {
            }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 20))
                    .foregroundColor(.orange)
            }
            
            HStack(spacing: 4) {
                Button(action: {
                    Task {
                        if let updatedLikes = await vm.likeExperience(experienceModel.id ?? "") {
                           
                                detailsVM.details?.likesNo = updatedLikes
                            vm.updateLocalLikeCount(for: experienceModel.id ?? "", likes: updatedLikes)
                        }
                    }
                }) {
                    Image(systemName: (detailsVM.details?.likesNo ?? 0) > 0 ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundColor(.orange)
                }
                
                Text("\(detailsVM.details?.likesNo ?? 0)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
            }
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Description")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Text(detailsVM.details?.description ?? "")
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(.black)
                .lineSpacing(4)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(minHeight: 100)
            
        }
    }
}
