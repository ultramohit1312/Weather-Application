//
//  WeatherData.swift
//  Clima
//
//  Created by Mohit Sinha on 14/08/23.

//

import Foundation

struct WeatherData : Codable {
    let name : String
    let main : Main
    let weather : [Weather]
}

struct Main : Codable{
    let temp : Double
    let humidity : Int
    let pressure : Int
}

struct Weather : Codable {
     let description : String
    let id : Int

          }
