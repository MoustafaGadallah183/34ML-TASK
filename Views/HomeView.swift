//
//  HomeView.swift
//  34MLTask
//
//  Created by Moustafa Mohamed Gadallah on 11/12/1446 AH.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @StateObject private var keyboard = KeyboardResponder()
    @State private var selectedItem: ExperienceModel? = nil
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        ScrollView {
            VStack( alignment: .leading,spacing: 0) {
                SearchBarView(searchText: $vm.searchText)
                    .focused($isSearchFocused)
                
                
                if !isSearchFocused {
                    
                    welcomeText
                        .transition(.opacity)
                    recommnededView
                        .cornerRadius(10)
                        .transition(.opacity)
                  
                }
            
               
                mostRecentView.ignoresSafeArea()
               
            }
        }
     
        .scrollDisabled(!keyboard.isKeyboardVisible)


       .animation(.easeOut(duration: 0.25), value: keyboard.isKeyboardVisible)
      
   
       .onChange(of: vm.searchText) { oldValue, newValue in
           if oldValue != newValue {
                 Task {
                     vm.performSearch()
                 }
             }
       }
        
    }
    
    
    
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
}

extension HomeView {
    private var welcomeText: some View {
        VStack(alignment :.leading , spacing: 5) {
            Text("Welcome!")
                .font(.headline)
                .fontWeight(.heavy)
            Text("Now you can explore any experneice in 360 degree and get all details about it in all one place")
                .font(.subheadline)
                .lineLimit(4)
                .fontWeight(.semibold)

                .minimumScaleFactor(0.7)
            
        }
        .padding([.leading , .top , .trailing] , 20)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var recommnededView: some View {
        
        
        VStack(alignment: .leading) {
            
           
            Text("RECOMMENDED EXPERIENCES")
                .font(.headline)
                .fontWeight(.heavy)
                .fontDesign(.rounded)
                .padding(.top , 20 )
                .padding(.leading , 10)
                .padding(.bottom, 4)
            TabView {
                ForEach($vm.recommendedExpeirneces) { $item in
                    HomeRowView(experienceModel: item)
                        .onTapGesture {
                            vm.selectedExperimentModel = item
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                vm.showDetail = true
                                }
                    }
                       
                }
                
     
            }
            .cornerRadius(10)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 250)
            
        }

     
       
    }
    
    private var mostRecentView: some View {
        VStack(alignment: .leading) {
            if !isSearchFocused {
                Text("MOST RECENT")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .fontDesign(.rounded)
                    .padding(.top , 20 )
                    .padding(.leading , 10)
                    .transition(.opacity)
            }
            
            List {
                ForEach($vm.mostRecentExpeirneces) { $item in
                    HomeRowView(experienceModel: item)
                        .padding(.vertical, 20)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .onTapGesture {
                            vm.selectedExperimentModel = item
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                vm.showDetail = true
                                }
                    }
                }
                
     
            }
            .listStyle(PlainListStyle())
            .cornerRadius(10)
            .frame(height: UIScreen.main.bounds.height)
            .padding([.leading, .trailing, .bottom]  , 10)
            .ignoresSafeArea(edges: .bottom)
        }
       
    }
}

