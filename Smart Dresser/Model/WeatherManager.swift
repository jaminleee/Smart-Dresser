//
//  WeatherManager.swift
//  Smart Dresser
//
//  Created by 이자민 on 5/8/24.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=292c10e9de665e1a093ee05c1a988e11&&units=imperial"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        
        //1. URL 인스턴스 생성
        if let url = URL(string: urlString){
            //2. URLSession 인스턴스 생성
            let session = URLSession(configuration: .default)
            
            //3. URLSession 에게 할 일 주기
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                //Data 타입으로 데이터를 받아옴..일반 string, int 가 아님
                if let safeData = data {
                    if let weather = parseJSON(weatherData: safeData){
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //4. 할 일 시작
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data)->WeatherModel? {
        
        let decoder = JSONDecoder() //an object that can decode JSON Objects
        
        do{
            
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather?[0].id
            let temp = decodedData.main?.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: id ?? 200, cityName: name ?? "Joplin", temperature: temp ?? 70)
            return weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
