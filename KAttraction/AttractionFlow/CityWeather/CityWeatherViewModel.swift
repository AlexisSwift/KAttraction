import Foundation

final class CityWeatherViewModel: ViewModel {
    @DriverValue private(set) var state: State
    @DriverValue private(set) var event: Event = .loading
    
    private let weatherService: WeatherServiceAbstract
    
    init(city: City, weatherService: WeatherServiceAbstract) {
        state = State(city: city)
        self.weatherService = weatherService
    }
    
    func handle(_ action: Action) {
        switch action {
        case .load:
            loadWeather()
        }
    }
    
    private func loadWeather() {
        weatherService.getWeather(city: state.city) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                var dataToday: [WeatherView.WeatherConfig] = []
                var dataTomorrow: [WeatherView.WeatherConfig] = []
                
                guard !response.hourly.isEmpty else {
                    self.event = .empty
                    return
                }

                var calendar = Calendar(identifier: .gregorian)
                calendar.timeZone = TimeZone(secondsFromGMT: response.timezoneOffset) ?? .current
                let formatter = DateFormatter()
                formatter.locale = .current
                formatter.timeZone = calendar.timeZone
                formatter.dateStyle = .medium
                
                let todayDate = Date(timeIntervalSince1970: TimeInterval(response.hourly[0].dateTime))
                let tomorrowDate = calendar.date(byAdding: .day, value: 1, to: todayDate)
                
                for hourly in response.hourly {
                    let responseDate = Date(timeIntervalSince1970: TimeInterval(hourly.dateTime))
                    if calendar.isDate(todayDate, inSameDayAs: responseDate) {
                        let data = self.convertResponse(data: hourly, timeZone: calendar.timeZone)
                        dataToday.append(WeatherView.WeatherConfig(weatherStatus: data.weatherStatus, time: data.time))
                    } else if let tomorrowDate = tomorrowDate,
                              calendar.isDate(tomorrowDate, inSameDayAs: responseDate) {
                        let data = self.convertResponse(data: hourly, timeZone: calendar.timeZone)
                        dataTomorrow.append(WeatherView.WeatherConfig(weatherStatus: data.weatherStatus, time: data.time))
                    }
                }
                
                self.state.todayDate = formatter.string(from: todayDate)
                if let tomorrowDate = tomorrowDate {
                    self.state.tomorrowDate = formatter.string(from: tomorrowDate)
                }
                self.state.todayWeather = dataToday as! [CityWeatherViewModel.ForecastItem]
                self.state.tomorrowWeather = dataTomorrow as! [CityWeatherViewModel.ForecastItem]
                self.event = .content(weatherStatus: self.state.todayWeather.first?.weatherStatus ?? .unknown)
            case let .failure(error):
                self.event = .error(error: error)
            }
        }
    }
}

// MARK: - Controller's State
extension CityWeatherViewModel {
    final class State {
        @DriverValue fileprivate(set) var city: City
        @DriverValue fileprivate(set) var todayDate: String = ""
        @DriverValue fileprivate(set) var tomorrowDate: String = ""
        @DriverValue fileprivate(set) var todayWeather: [ForecastItem] = []
        @DriverValue fileprivate(set) var tomorrowWeather: [ForecastItem] = []
        
        init (city: City) {
            self.city = city
        }
    }
}

// MARK: - Formatter for Time And WeatherResponse
extension CityWeatherViewModel {
    
    private func formatterSecondsInDataString(sec: Double, timeZone: TimeZone) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = timeZone
        let time = Date(timeIntervalSince1970: TimeInterval(sec))
        return formatter.string(from: time)
    }
    
    private func convertResponse(data: Hourly, timeZone: TimeZone) -> ForecastItem {
        let weatherType = WeatherType(apiValue: data.weather.first?.main)
        let time = formatterSecondsInDataString(sec: data.dateTime, timeZone: timeZone)
        
        return ForecastItem(weatherStatus: weatherType, time: time)
    }
}

extension CityWeatherViewModel {
    struct ForecastItem {
        let weatherStatus: WeatherType
        let time: String
    }

    enum Action {
        case load
    }

    enum Event {
        case loading
        case content(weatherStatus: WeatherType)
        case empty
        case error(error: Error)
    }
}
