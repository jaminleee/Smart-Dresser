//
//  ViewController.swift
//  Smart Dresser
//
//  Created by 이자민 on 5/3/24.
//

import UIKit
import SnapKit
import CoreLocation


class HomeViewController: UIViewController {
    static let identifier: String = "HomeViewController"
    
    private let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
    
    private var currentCityName: String?
    
    private let titleLabel: SmartDresserLabel = .init(font: .font(.heading_1), color: .main_black)
    
    private let descriptionLabel: SmartDresserLabel = .init(font: .font(.subtitle_1), color: .gray1)
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 16
        textField.layer.borderColor = UIColor.gray3.cgColor
        textField.layer.borderWidth = 2
        textField.layer.backgroundColor = UIColor.gray4.cgColor
        textField.setLeftPaddingPoints(20)
        textField.setRightPaddingPoints(20)
        textField.placeholder = "Type City"
        return textField
    }()
    
    private let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "location")
        imageView.tintColor = .primary
        return imageView
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .primary
        button.titleLabel?.font = .font(.heading_4)
        button.setTitleColor(.main_white, for: .normal)
        button.makeCornerRound(radius: 24)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        setLayout()
        
        
        // 위치 정보를 가져오기 위해 delegate 설정
        locationManager.delegate = self
        // 위치 정보 권한 요청
        locationManager.requestWhenInUseAuthorization()
        // 위치 업데이트 시작
        locationManager.startUpdatingLocation()
        
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(locationImageViewTapped))
        locationImageView.isUserInteractionEnabled = true
        locationImageView.addGestureRecognizer(tapGesture)
        
    }
    
    private func setStyle() {
        view.backgroundColor = .white
        titleLabel.text = "Smart Dresser"
        descriptionLabel.numberOfLines = 2
        descriptionLabel.text = "Weather-Based\nOutfit Recommendations"
        confirmButton.setTitle("search", for: .normal)
    }
    
    private func setLayout(){
        self.view.addSubviews(titleLabel, descriptionLabel, searchTextField, locationImageView, confirmButton)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(68)
            $0.width.equalTo(310)
        }
        
        locationImageView.snp.makeConstraints {
            $0.centerY.equalTo(searchTextField)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.width.equalTo(25)
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(64)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func confirmButtonTapped() {
        let cityName = searchTextField.text
        
        let dresserViewController = DresserViewController()
        dresserViewController.cityName = cityName // cityName을 DresserViewController에 전달
        navigationController?.pushViewController(dresserViewController, animated: true)
        
        print(cityName)
    }
    
    @objc private func locationImageViewTapped() {
        searchTextField.text = currentCityName
    }
    
}


extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // 위치 정보를 이용하여 현재 도시 이름 가져오기
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                return
            }
            guard let placemark = placemarks?.first else { return }
            if let city = placemark.locality {
                self.currentCityName = city
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}


