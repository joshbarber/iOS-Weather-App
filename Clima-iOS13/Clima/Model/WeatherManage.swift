//
//  WeatherManage.swift
//  Clima
//
//  Created by Joshua Barber on 5/12/20.
//

import Foundation
import CoreLocation

protocol WeatherDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManage, _ weather: WeatherModel)
    func didFailWithError(with error: Error) //func to help pass errors out of WeatherManager
}


struct WeatherManage{
    
    //any class or property that sets themselves as the delegate must have WeatherDelegate protocol adopted
    //we don't care who the delegate is or what class they are, as long as they are of type WeatherDelegate
    var delegate: WeatherDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1532aca9723ca1e411f5bf099e4903d4&units=imperial"
    
    func fetchWeather(cityName: String){
        if let cityName = cityName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            let urlString = "\(weatherURL)&q=\(cityName)"
            performRequest(with: urlString)
        }
    }
    
    func fetchWeather(_ latitude:CLLocationDegrees, _ longitude: CLLocationDegrees){
        
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    
    func performRequest(with urlString: String){ //function to retrieve the data
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            //here we utilize a closure as a completion handler
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{ //this means we recieved an error
                    self.delegate?.didFailWithError(with: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = self.parseJSON(with: safeData){
                        //whoever is set as the delegate performs this method
                        self.delegate?.didUpdateWeather(self, weather)
                        
                    }
                }
                
            }
            task.resume()
            
        }
    }
    
    func parseJSON(with weatherData: Data) -> WeatherModel?{ //has to be made an optional since we can return a nil
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let weatherID = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            //created a struct to load the data we recieved
            let weather = WeatherModel(conditionID: weatherID, cityName: name, temperature: temp)
            return weather
            
            
        } catch{
            delegate?.didFailWithError(with: error)
            return nil
        }
        
        
        
    }
    
    
}

