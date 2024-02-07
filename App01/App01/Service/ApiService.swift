//
//  ApiService.swift
//  App01
//
//  Created by Getter Saar on 03.01.2024.
//

import Foundation


class ApiService{
    
    let API_URL: String = "https://api.openweathermap.org/data/2.5/"
    let API_KEY: String = "57b32531bffa3163b84aaae455d17587"
    
    
    var data: Data!
    var tempe: Double!

    
    func createRequestUrl(lat: Double, lon: Double) -> String {
       return API_URL + "weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(API_KEY)"
    }
    
    
    
    struct WeatherData: Codable {
        let main: Main
    }
    
    struct Main: Codable {
        let temp: Double
    }
    
    func get(lat: Double, lon: Double) async {
        print("Get request")
        let urlString = createRequestUrl(lat: lat, lon: lon)
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            let decoder = JSONDecoder()

            let weatherData = try decoder.decode(WeatherData.self, from: data)

            let temperature = round(weatherData.main.temp)
            tempe = temperature

        } catch {
            print("Error: \(error)")
        }
    }

    
    func getTemp() -> Double {
        return tempe
    }


    func printJson(_ data: Data){
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                print("Error: Cannot convert JSON object to Pretty JSON data")
                return
            }
            guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                print("Error: Could print JSON in String")
                return
            }

            print(prettyPrintedJson)
        } catch {
            print("Error: Trying to convert JSON data to string")
            return
        }
    }
}
