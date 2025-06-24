//
//  LocationService.swift
//  FLOV
//
//  Created by 조우현 on 6/22/25.
//

import Foundation
import CoreLocation
import Combine

protocol LocationServiceType {
    var currentLocation: AnyPublisher<CLLocation?, Never> { get }
    var authorizationStatus: AnyPublisher<CLAuthorizationStatus, Never> { get }
    var infoPublisher: AnyPublisher<String, Never> { get }
    func requestLocationPermission()
}

final class LocationService: NSObject, LocationServiceType {
    private let locationManager = CLLocationManager()
    private let currentLocationSubject = PassthroughSubject<CLLocation?, Never>()
    private let authorizationStatusSubject = CurrentValueSubject<CLAuthorizationStatus, Never>(.notDetermined)
    private let infoSubject = PassthroughSubject<String, Never>()
    /// 기본위치: 서울시청
    private let defaultLocation = CLLocation(
        latitude: 37.565679812037345,
        longitude: 126.97796779294629
    )
    
    var currentLocation: AnyPublisher<CLLocation?, Never> {
        currentLocationSubject.eraseToAnyPublisher()
    }
    var authorizationStatus: AnyPublisher<CLAuthorizationStatus, Never> {
        authorizationStatusSubject.eraseToAnyPublisher()
    }
    var infoPublisher: AnyPublisher<String, Never> {
        infoSubject.eraseToAnyPublisher()
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatusSubject.send(locationManager.authorizationStatus)
    }
    
    func requestLocationPermission() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            infoSubject.send("위치 권한이 비활성화되어 있습니다.\n기본 위치로 게시물을 불러옵니다.")
            currentLocationSubject.send(defaultLocation)
        @unknown default:
            break
        }
    }
}

// MARK: - Delegate
extension LocationService: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        authorizationStatusSubject.send(status)
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            infoSubject.send("위치 권한이 비활성화되어 있습니다.\n기본 위치로 게시물을 불러옵니다.")
            currentLocationSubject.send(defaultLocation)
        default:
            break
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let loc = locations.last else { return }
        currentLocationSubject.send(loc)
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Location error: \(error.localizedDescription)")
        infoSubject.send("위치를 가져오지 못해 기본 위치로 불러옵니다.")
        currentLocationSubject.send(defaultLocation)
    }
}
