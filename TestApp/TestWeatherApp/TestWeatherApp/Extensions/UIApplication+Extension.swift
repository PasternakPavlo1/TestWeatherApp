//
//  UIApplication+Extension.swift
//  TestWeatherApp
//
//  Created by Павло Пастернак on 10.08.2022.
//

import UIKit

// MARK: - UIApplication
extension UIApplication {
    
    // MARK: - Method
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
