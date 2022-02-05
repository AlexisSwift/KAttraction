import Foundation

final class CityWeatherViewModel: ViewModel {
    
    typealias ControllerState = State
    typealias OutputEvent = CityWeatherViewContoller.InputEvent
    typealias InputAction = CityWeatherViewContoller.Action
    
    @DriverValue private(set) var state: ControllerState
    @DriverValue private(set) var event: OutputEvent = .loading
    
    private let weatherService: WeatherServiceAbstract
    
    init(city: City, weatherService: WeatherServiceAbstract) {
        state = State(city: city)
        self.weatherService = weatherService
    }
    
    func handle(_ action: InputAction) {
        switch action {
        case .load:
            loadWeather()
        }
    }
    
    private func loadWeather() {
        weatherService.getWeather(city: state.city, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                var dataToday: [WeatherView.WeatherConfig] = []
                var dataTomorrow: [WeatherView.WeatherConfig] = []
                
                let calendar = Calendar.current
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ru")
                formatter.dateStyle = .medium
                
                guard let hourlyDataTime = response.hourly.first?.dateTime else {
                    return
                }
                
                let todayDate = Date(timeIntervalSince1970: TimeInterval(hourlyDataTime))
                let tomorrowDate = calendar.date(byAdding: .day, value: 1, to: todayDate)
                
                for hourly in response.hourly {
                    let responseDate = Date(timeIntervalSince1970: TimeInterval(hourly.dateTime))
                    if todayDate.day() == responseDate.day() {
                        dataToday.append(self.convertResponse(data: hourly))
                    } else if responseDate.day() == tomorrowDate?.day() {
                        dataTomorrow.append(self.convertResponse(data: hourly))
                    }
                }
                
                self.state.todayDate = formatter.string(from: todayDate)
                if let tomorrowDate = tomorrowDate {
                    self.state.tomorrowDate = formatter.string(from: tomorrowDate)
                }
                self.state.todayWeather = dataToday
                self.state.tomorrowWeather = dataTomorrow
                self.event = .setBackground(weatherStatus: self.state.todayWeather.first?.weatherStatus ?? .clear)
            case .failure(_):
                break
            }
        })
    }
}

// MARK: - Controller's State
extension CityWeatherViewModel {
    final class State {
        @DriverValue fileprivate(set) var city: City
        @DriverValue fileprivate(set) var todayDate: String = ""
        @DriverValue fileprivate(set) var tomorrowDate: String = ""
        @DriverValue fileprivate(set) var todayWeather: [WeatherView.WeatherConfig] = []
        @DriverValue fileprivate(set) var tomorrowWeather: [WeatherView.WeatherConfig] = []
        
        init (city: City) {
            self.city = city
        }
    }
}

// MARK: - Formatter for Time And WeatherResponse
extension CityWeatherViewModel {
    
    private func formatterSecondsInDataString(sec: Double) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let time = Date(timeIntervalSince1970: TimeInterval(sec))
        return formatter.string(from: time)
    }
    
    private func convertResponse(data: Hourly) -> WeatherView.WeatherConfig {
        let weatherType = WeatherType(rawValue: data.weather.first?.main ?? "") ?? .clear
        let time = formatterSecondsInDataString(sec: data.dateTime)
        
        return WeatherView.WeatherConfig.init(weatherStatus: weatherType, time: time)
    }
}
