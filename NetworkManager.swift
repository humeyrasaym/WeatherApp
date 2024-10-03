//
//  NetworkManager.swift
//  Clima
//
//  Created by Hümeyra SAYIM on 7/21/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import CoreLocation
import UIKit


protocol NetworkManagerDelegate {
    func didUpdateWeather(_ networkManager: NetworkManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct NetworkManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=7828461f7c899c6c249ebfb1112d5fed&units=metric"
    
    var delegate: NetworkManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // 1. create url
        if let url = URL(string: urlString) {
            
            // 2. create url session
            let session = URLSession(configuration: .default)
            
            // 3. give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            // 4. start the task
            task.resume()
        }
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            print(weather.conditionName)
            print(weather.temperatureString)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

/*
 func calculator(n1: Int, n2: Int, operation: (Int, Int) -> Int) -> Int {
 return operation(n1, n2)
 }
 
 // uzun yol
 func multiply(no1: Int, no2: Int) -> Int {
 return no1 * no2
 }
 
 print(calculator(n1: 2, n2: 5, operation: multiply))
 
 // closure ile kisa yol
 let result = calculator(n1: 2, n2: 5) {$0 * $1}
 print(result)
 */

/*
 let array = [2, 4, 5]
 
 \\ arraydeki her elemana 1 ekledi. closure ile cok kisa oldu.
 print(array.map{$0 + 1})
 */


