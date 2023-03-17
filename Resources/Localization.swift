enum Localization {
    
    enum SearchFlow {
        
        enum Search {
            static let find = "Поиск"
            static let chooseYourCity = "Выбери свой город"
        }
        
        enum CityWeather {
            static let weather = "Погода"
            static let weatherInCity = "Погода в городе"
            
            enum WeatherDiscription {
                static let clear = "Ясно"
                static let clouds = "Облачно"
                static let thunderstorm = "Гроза"
                static let drizzle = "Моросящий дождь"
                static let rain = "Дождь"
                static let snow = "Снег"
                static let mist = "Туман"
                static let tornado = "Торнадо"
            }
            
            enum DaysDiscription {
                static let today = "Сегодня"
                static let tomorrow = "Завтра"
            }
        }
    }
    
    enum AttractionFlow {
        
        enum Attraction {
            static let checkWeatherTap = "Нажми, чтобы узнать погоду"
            static let attractions = "Достопримечательности"
            static let attractionsName = "Тут должно быть название"
        }
        
        enum AboutAttraction {
            static let reedMore = "Читать далее"
            static let onMap = "На карте"
            static let latitude = "Долгота"
            static let longitude = "Широта"
        }
    }
}
