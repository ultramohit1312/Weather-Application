import UIKit
import CoreLocation
// create protocol to implemend didUpdateWeather to any class or struct
protocol weatherManagerDelegate {
    func didUpdateWeather(weather : weatherModel)
}

struct weatherManager{

    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&APPID=988c1bf94ffa3ac9050eac31dc576678&units=metric"
    
    // using the protocol as delegate
    var delegate : weatherManagerDelegate?
    
     func tellWeather(cityName : String){
       let urlString = "\(weatherURL)&q=\(cityName )"
         performRequest(urlString: urlString)
    }
    
    func fetchWeather(latitude : CLLocationDegrees , longitude : CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude )&lon=\(longitude)"
          performRequest(urlString: urlString)
    }
    
    func performRequest(urlString : String)
    {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data
                {
                    if let weather = self.jsonParse(weatherData: safeData){
                        self.delegate?.didUpdateWeather(weather : weather)
                        // passing delegate to other file with all deltails of didUpdateWeather
                    }
                }
            }
            task.resume()
        }
    }
    
    func jsonParse(weatherData : Data) -> weatherModel? //using optional as error can return nil
    {
        let jsonDecoder = JSONDecoder()
        do{
            let decodedData = try jsonDecoder.decode(WeatherData.self, from: weatherData)
          
            let name = decodedData.name
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            let weather = weatherModel(conditionID: id, temperature: temp, cityName: name)
            
          //  print(weather.temperatureString)
             return weather
            
            
            
        }
        catch{
            print(error)
         return nil
        }
    }
    
    
    }


