//
//  WeatherData.swift
//  Clima
//
//  Created by Joshua Barber on 11/22/20.

import Foundation

struct WeatherData: Decodable{ //top level of JSON weather data
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable{
    let id: Int
}
