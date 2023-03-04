//
//  Public.swift
//  COWStatusCrumb
//
//  Created by XQF on 04.03.23.
//

import Foundation

private let apiKey = "a6b243f000737fa523434d1e8fc4d1a7"

// MARK: - OpenWeather URLs

let dailyUrl = "https://api.openweathermap.org/data/2.5/weather?&appid=\(apiKey)&units=metric&lang=en"

struct DailyWeatherMain: Codable {
    let temp: Double
    let feels_like: Double
    let humidity: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
}

struct DailyWeather: Codable {
    let main: DailyWeatherMain
    let name: String
    let weather: [WeatherDescription]
    let wind: Wind
    let visibility: Int
}
struct WeatherDescription: Codable {
    let description: String
    let id: Int
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
}

struct DailyWeatherModel {
    let cityName: String
    let temperature: String
    let description: String
    let maxTemp: String
    let minTemp: String
    let feelsLike: Double
    let humidity: Double
    let id: String
    let visibility: Int
    let pressure: Int
    let windSpeed: Double
    var minMaxTemp: String {
        return "Маx. \(maxTemp), Min. \(minTemp)"
    }
}

func modelIdentifier() -> String {
    var sysinfo = utsname()
    uname(&sysinfo)
    return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
}

func setCrumbDate() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM"
    
    let newStr: String = dateFormatter.string(from: Date())
    
    if (newStr + " ▶").utf8CString.count <= 256 {
        StatusManager.sharedInstance().setCrumb(newStr)
    } else {
        StatusManager.sharedInstance().setCrumb("Length Error")
    }
}

func setCrumbWeather() {
    let locationDataManager = LocationManager()
    guard let lat = locationDataManager.locationManager.location?.coordinate.latitude else {
        return
    }
    guard let long = locationDataManager.locationManager.location?.coordinate.longitude else {
        return
    }
    fetchWeather(lat: lat, lon: long) { str in
        if (str + " ▶").utf8CString.count <= 256 {
            StatusManager.sharedInstance().setCrumb(str)
        } else {
            StatusManager.sharedInstance().setCrumb("Length Error")
        }
    } failure: { error in
        StatusManager.sharedInstance().setCrumb("error")
    }
}

func fetchWeather (lat: Double, lon: Double, success: @escaping (_ str: String) -> Void, failure: @escaping (_ error: String) -> Void){
    /*
    let locatedDailyUrl = dailyUrl + "&lon=\(lon)&lat=\(lat)"
    AF.request(locatedDailyUrl).responseDecodable(of: DailyWeather.self) { response in
        switch response.result {
        case .success(let weather):
            print("weather: \(weather)")
            let temp = Double(round(10 * weather.main.temp) / 10)
            print("temp: \(temp)")
            let tempStr = "\(temp) Grad"
            success(tempStr)
        case .failure(let error):
            print(error.localizedDescription)
            failure(error.localizedDescription)
        }
    }*/
}
