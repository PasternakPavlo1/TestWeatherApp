//
//  ForecastListViewModel.swift
//  TestWeatherApp
//
//  Created by Павло Пастернак on 09.08.2022.
//

import Foundation
import CoreLocation
import SwiftUI

// MARK: - ForecastListViewModel
class ForecastListViewModel: ObservableObject {
    
    // MARK: - AppError
    struct AppError: Identifiable {
        let id = UUID().uuidString
        let errorString: String
    }
    
    // MARK: - Properties
    @Published var forecasts: [ForecastViewModel] = []
    var appError: AppError? = nil
    @Published var isLoading: Bool = false
    @AppStorage("location") var storageLocation: String = ""
    @Published var location = ""
    @AppStorage("system") var system: Int = 0 {
        didSet {
            for i in 0..<forecasts.count {
                forecasts[i].system = system
            }
        }
    }
    
    // MARK: - Life Cycle
    init() {
        location = storageLocation
        getWeatherForecast()
    }
    
    // MARK: - Method
    func getWeatherForecast() {
        storageLocation = location
        UIApplication.shared.endEditing()
        if location == "" {
            forecasts = []
        } else {
            isLoading = true
            let apiService = APIService.shared
            CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
                if let error = error as? CLError {
                    switch error.code {
                    case .locationUnknown, .geocodeFoundNoResult , .geocodeFoundPartialResult:
                        self.appError =
                        AppError(errorString: NSLocalizedString("Unable to determine location from this text.",
                                                                comment: ""))
                    case .network:
                        self.appError =
                        AppError(errorString: NSLocalizedString("You don't appear to have a natwork connection.",
                                                                comment: ""))
                    default:
                        self.appError = AppError(errorString: error.localizedDescription)
                    }
                    self.isLoading = false
                    
                    print(error.localizedDescription)
                }
                
                if let lat = placemarks?.first?.location?.coordinate.latitude,
                   let lon = placemarks?.first?.location?.coordinate.longitude {
                    apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid=e4ade9ccb453fda961ee12bf66c312d9",
                                       dateDecodingStrategy:
                                            .secondsSince1970) { (result: Result<Forecast,APIService.APIError>) in
                        switch result {
                        case .success(let forecast):
                            DispatchQueue.main.async {
                                self.isLoading = false
                                self.forecasts = forecast.daily.map { ForecastViewModel(forecast: $0, system: self.system)}
                            }
                        case .failure(let apiError):
                            switch apiError {
                            case .error(let errorString):
                                self.isLoading = false
                                self.appError = AppError(errorString: errorString)
                                print(errorString)
                            }
                        }
                    }
                }
            }
        }
    }
}
