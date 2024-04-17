
import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    
    var WeatherManager = weatherManager()
    let locationManager = CLLocationManager()
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var inputTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        inputTextField.delegate = self
        WeatherManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    @IBAction func ButtonPressed(_ sender: UIButton) {
        
        locationManager.requestLocation()
    }
    
}


extension WeatherViewController : UITextFieldDelegate
{
  
    @IBAction func searchPressed(_ sender: UIButton) {
        
        print(inputTextField.text!)
        inputTextField.endEditing(true)
      
    }
    
  
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(inputTextField.text!)
        inputTextField.endEditing(true)
        return true
        
    }
    
  
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
     {
        if textField.text != ""
        {
            return true
        }
        else
        {
            textField.placeholder = "Type Something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = inputTextField.text{
            WeatherManager.tellWeather(cityName: city)
        }
  
        inputTextField.text = ""
    }
}





extension WeatherViewController : weatherManagerDelegate{
   
    func didUpdateWeather(weather: weatherModel) {
      
        DispatchQueue.main.sync {
            temperatureLabel.text = weather.temperatureString
            conditionImageView.image = UIImage(systemName: weather.conditionName)
            cityLabel.text = weather.cityName
        }
    }
}



extension WeatherViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            WeatherManager.fetchWeather(latitude : lat , longitude : lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
  
