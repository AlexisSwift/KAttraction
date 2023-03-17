import RxSwift

final class CityWeatherViewContoller: BaseViewController {
    typealias ViewModel = CityWeatherViewModel
    typealias Event = InputEvent
    
    private var viewModel: ViewModel
    
    private lazy var mapView = MapView()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBindings()
        
        viewModel.handle(.load)
    }
    
    private func setupView() {
        title = L10n.weatherInCity()
        view.background(Color.backgroundPrimary())
        
        viewModel.$state
            .drive { [weak self] state in
                guard let self = self else { return }
                self.body(state: state).embedIn(self.view)
                
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
        case .loading:
            startLoading()
        case .setBackground(let weatherStatus):
            endLoading()
            setBackgroundImage(weatherStatus: weatherStatus)
        }
    }
}

// MARK: - UI
extension CityWeatherViewContoller {
    private func body(state: ViewModel.State) -> UIView {
        VStack {
            FlexibleGroupedSpacer(groupId: 1)
            VStack {
                Label(text: state.city.name)
                    .setFont(.systemFont(ofSize: 32, weight: .heavy))
                    .setTextColor(.black)
                    .multilined
                Spacer(height: 8)
                ViewWithData(state.$todayDate) { date in
                    Label(text: "\(L10n.today()), \(date)")
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
                    Label(text: "\(L10n.tomorrow()), \(date)")
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
            FlexibleGroupedSpacer(groupId: 1)
        }
        .linkSpacers()
    }
}

// MARK: - Action
extension CityWeatherViewContoller {
    private func setBackgroundImage(weatherStatus: WeatherType) {
        let backgroundImage: UIImage?
        
        switch weatherStatus {
        case .clear, .tornado, .thunderstorm:
            backgroundImage = Image.clearBackground()
        case .clouds, .mist:
            backgroundImage = Image.cloudyBackground()
        case .rain, .drizzle:
            backgroundImage = Image.rainBackground()
        case .snow:
            backgroundImage = Image.snowBackground()
        }
        
        let backgroundImageView = UIImageView(image: backgroundImage)
        view.insertSubview(backgroundImageView, at: 0)
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Action, Event
extension CityWeatherViewContoller {
    enum Action {
        case load
    }
    
    enum InputEvent {
        case loading
        case setBackground(weatherStatus: WeatherType)
    }
}
