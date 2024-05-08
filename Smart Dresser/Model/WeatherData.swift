//
//  WeatherData.swift
//  Smart Dresser
//
//  Created by 이자민 on 5/8/24.
//

import UIKit

//JSON로 디코딩 인코딩 가능한 객체는 Codable 프로토콜을 따라야함
struct WeatherData : Codable {
    //도시 이름
    let name: String?
    let main : WeatherMain?
    let weather: [Weather]?
    //편의성을 위해 image 프로퍼티 정의
}

//main 에 해당
struct WeatherMain : Codable {
    //온도
    let temp: Double
    //습도
    let humidity: Double
}

//weather 에 해당
struct Weather : Codable {
    let description: String
    //id 값에 따라 아이콘 출력을 위해 필요
    let id: Int
}




