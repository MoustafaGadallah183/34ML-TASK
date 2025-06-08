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
    @EnvironmentObject var vm : HomeViewModel
    @StateObject private var detailsVM = HomeDetailsViewModel()

    var body: some View {
        ScrollView {
            VStack {
                expeirenceImageSection
                    .shadow( color: Color.black.opacity(0.3), radius: 10  , x: 0, y: 10 )
                
                VStack(alignment: .leading , spacing: 16) {
//                    titleSection
                    Divider()
//                    descriptionSection
                    Divider()
                 
//                    mapLayer
                }
                
            }
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .task {
          await  detailsVM.getExpriencesDetails(experience: vm.selectedExperimentModel)
        }
        .overlay(alignment: .topLeading) {
          //  backBtn
        }
        
        
        
    }
}

extension HomeDetailsView {
    
    private var expeirenceImageSection: some View {
       
        KFImage(URL(string:  detailsVM.details?.coverPhoto ?? ""))
                   .placeholder {
                       ProgressView() 
                   }
                   .resizable()
                   .aspectRatio(contentMode: .fill)
                   .clipped()
                   .cornerRadius(12)
                    
           
 
        .frame(height: 300)
        .tabViewStyle(PageTabViewStyle())
    }
    
    
}
