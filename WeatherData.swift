//
//  WeatherData.swift
//  Clima
//
//  Created by Hümeyra SAYIM on 10/1/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let weather: [Weather]
    let main: Main
}

struct Weather: Codable {
    let id: Int
    let description: String
}


struct Main: Codable {
    let temp: Double
}
