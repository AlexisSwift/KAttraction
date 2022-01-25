import RxSwift

final class CityWeatherViewContoller: UIViewController {
    typealias ViewModel = CityWeatherViewModel
    typealias Event = InputEvent
    
    private var loadingView = LoadingView()
    
    private var viewModel: ViewModel
    private let disposeBag = DisposeBag()
    
//    private var mapView = MapView()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Localization.SearchFlow.CityWeather.weatherInCity
        setupView()
        setupBindings()
        viewModel.handle(.load)
    }
    
    private func setupView() {
        self.view.background(Palette.backgroundPrimary)
        
        self.viewModel.$state
            .drive { [weak self] state in
                guard let self = self else { return }
                self.body(state: state).embedIn(self.view)
                
//                state.$city.drive { coordinates in
//                    self.mapView.updateMap(nameAttraction: coordinates.name, latitude: coordinates.latitude, longitude: coordinates.longitude)
//                }.disposed(by: self.disposeBag)
                
            }.disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        viewModel.$event.drive { [weak self] event in
            self?.handle(event)
        }
        .disposed(by: disposeBag)
    }

    func handle(_ event: Event) {
        switch event {
        case .setBackground(let weatherStatus):
            loadingView.hideLoading()
            setBackgroundImage(weatherStatus: weatherStatus)
        case .loading:
            loadingView.embedInWithInsets(view)
        }
    }
    
    private func setBackgroundImage(weatherStatus: WeatherType) {
        let backgroundImage: UIImage?
        
        switch weatherStatus {
        case .clear, .tornado, .thunderstorm :
            backgroundImage = Asset.WeatherBackground.clear
        case .clouds, .mist:
            backgroundImage = Asset.WeatherBackground.cloudy
        case .rain, .drizzle:
            backgroundImage = Asset.WeatherBackground.rain
        case .snow:
            backgroundImage = Asset.WeatherBackground.snow
        }
        
        let backgroundImageView = UIImageView(image: backgroundImage)
        
        view.insertSubview(backgroundImageView, at: 0)
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - UI
extension CityWeatherViewContoller {
    private func body(state: ViewModel.State) -> UIView {
        VStack {
            ScrollView {
                VStack {
//                    mapView
//                        .height(144)
                    VStack {
                        Label(text: state.city.name)
                            .setFont(.systemFont(ofSize: 32, weight: .heavy))
                            .setTextColor(.black)
                        Spacer(height: 8)
                        ViewWithData(state.$todayDate) { date in
                            Label(text: "\(Localization.SearchFlow.CityWeather.DaysDiscription.today), \(date)")
                                .setFont(.systemFont(ofSize: 16, weight: .medium))
                                .setTextColor(.black)
                        }
                    }
                    .layoutMargins(vInset: 16, hInset: 24)
                    
                    ScrollView {
                        HStack {
                            ForEach(state.$todayWeather, spacerSize: 8) { weather in
                                WeatherView(config: weather)
                            }
                        }
                        .layoutMargins(hInset: 18)
                    }
                    .hideScrollIndicators()
                    
                    VStack {
                        ViewWithData(state.$tomorrowDate) { date in
                            Label(text: "\(Localization.SearchFlow.CityWeather.DaysDiscription.tomorrow), \(date)")
                                .setFont(.systemFont(ofSize: 16, weight: .medium))
                                .setTextColor(.black)
                        }
                    }.layoutMargins(vInset: 16, hInset: 24)
                    
                    ScrollView {
                        HStack {
                            ForEach(state.$tomorrowWeather, spacerSize: 8) { weather in
                                WeatherView(config: weather)
                            }
                        }
                        .layoutMargins(hInset: 18)
                    }
                    .hideScrollIndicators()
                    FlexibleSpacer()
                }
            }
        }
    }
}

extension CityWeatherViewContoller {
    enum Action {
        case load
    }
    
    enum InputEvent {
        case loading
        case setBackground(weatherStatus: WeatherType)
    }
}
