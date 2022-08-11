//
//  ForecastViewModel.swift
//  TestWeatherApp
//
//  Created by Павло Пастернак on 09.08.2022.
//

import Foundation

// MARK: - ForecastViewModel
struct ForecastViewModel {
    
    // MARK: - Properties
    let forecast: Forecast.Daily
    var system: Int
    
    // MARK: - Private Properties
    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM, d"
        return dateFormatter
    }
    
    private static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter
    }
    
    private static var numberFormatter2: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter
    }
    
    // MARK: - Method
    func convert(_ temp: Double) -> Double {
        let celsius = temp - 273.5
        if system == 0 {
            return celsius
        } else {
            return celsius * 9 / 5 + 32
        }
    }
    
    // MARK: - Computed Properties
    var day: String {
        return Self.dateFormatter.string(from: forecast.dt)
    }
    
    var overview: String {
        forecast.weather[0].description.capitalized
    }
    
    var high: String {
        return "H: \(Self.numberFormatter.string(for: convert(forecast.temp.max)) ?? "0")°"
    }
    
    var low: String {
        return "L: \(Self.numberFormatter.string(for: convert(forecast.temp.min)) ?? "0")°"
    }
    
    var pop: String {
        return "💧 \(Self.numberFormatter2.string(for: forecast.pop) ?? "0%")"
    }
    
    var clouds: String {
        return "☁︎ \(forecast.clouds)%"
    }
    
    var humidity: String {
        return "Humidity: \(forecast.humidity)%"
    }
    
    var weatherIconURL: URL {
        let urlString = "https://openweathermap.org/img/wn/\(forecast.weather[0].icon)@2x.png"
        return URL(string: urlString)!
    }
}
