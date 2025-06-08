//
//  UIApplication.swift
//  34MLTask
//
//  Created by Moustafa Mohamed Gadallah on 12/12/1446 AH.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
