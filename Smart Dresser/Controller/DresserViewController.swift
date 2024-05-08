//
//  DresserViewController.swift
//  Smart Dresser
//
//  Created by 이자민 on 5/8/24.
//

import UIKit

class DresserViewController: UIViewController {
    static let identifier: String = "DresserViewController"
    var weather: WeatherModel?
    var weatherManager = WeatherManager()
    var cityName: String?
    
    private let cityNameLabel: SmartDresserLabel = .init(font: .font(.heading_2), color: .main_black)
    
    private let conditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray1
        return imageView
    }()
    
    private let temperatureLabel: SmartDresserLabel = .init(font: .font(.heading_4), color: .gray1)
    
    private let dresserLabel: SmartDresserLabel = .init(font: .font(.heading_3), color: .main_black)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        if let cityName = cityName {
            weatherManager.fetchWeather(cityName: cityName) // cityName이 있으면 fetch 호출
        }
        
        
        

    }
    
    private func setStyle() {
        view.backgroundColor = .white
        cityNameLabel.text = cityName
        conditionImageView.image = UIImage(systemName: weather?.conditionName ?? "sun.max")
        temperatureLabel.text = weather?.temperatureString
        dresserLabel.numberOfLines = 0
        if let temperature = weather?.temperature {
                    switch temperature {
                    case ..<50:
                        dresserLabel.text = "For cold weather, consider wearing a heavy coat 🥶"
                    case 50..<68:
                        dresserLabel.text = "A cardigan would be nice for cool weather 💨"
                    case 68..<77:
                        dresserLabel.text = "A light jacket would be suitable for mild weather 🧥"
                    case 77...:
                        dresserLabel.text = "For hot weather, a T-shirt would be comfortable ☀️"
                    default:
                        break
                    }
                }
    }
    
    private func setLayout() {
        self.view.addSubviews(cityNameLabel, conditionImageView, temperatureLabel, dresserLabel)
        
        cityNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        
        conditionImageView.snp.makeConstraints {
            $0.top.equalTo(cityNameLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(80)
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(conditionImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        dresserLabel.snp.makeConstraints {
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
}


extension DresserViewController: WeatherManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.weather = weather
            self.setStyle()
            self.setLayout()
            print(weather)
        }
        
    }
}
