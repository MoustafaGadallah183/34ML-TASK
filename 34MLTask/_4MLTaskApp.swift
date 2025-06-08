//
//  _4MLTaskApp.swift
//  34MLTask
//
//  Created by Moustafa Mohamed Gadallah on 11/12/1446 AH.
//

import SwiftUI

@main
struct _4MLTaskApp: App {
    
    @StateObject private var vm = HomeViewModel()


    var body: some Scene {
        WindowGroup {
            HomeView()
            
        }
        .environmentObject(vm)
        
    }
}
