import RxSwift

final class AttractionDetailsViewController: UIViewController {
    typealias ViewModel = AttractionDetailsViewModel
    
    private var viewModel: ViewModel
    private let disposeBag = DisposeBag()
    private var mapView = MapView()
    
    var onWeatherScreen: CityHandler?
    
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
        viewModel.handle(.load)
    }
    
    private func setupView() {
        self.view.background(Palette.backgroundPrimary)
        
        self.viewModel.$state
            .drive { [weak self] state in
                guard let self = self else { return }
                
                self.body(state: state).embedIn(self.view)
                self.title = state.attractionName
                
                state.$detailAboutAttraction.drive { coordinates in
                    self.mapView.updateMap(nameAttraction: coordinates.name, latitude: coordinates.latitude, longitude: coordinates.longitude)
                }.disposed(by: self.disposeBag)
                
            }.disposed(by: disposeBag)
    }
}

// MARK: - UI
extension AttractionDetailsViewController {
    private func body(state: ViewModel.State) -> UIView {
        VStack {
            ScrollView {
                VStack {
                    ScrollView {
                        HStack {
                            ForEach(state.$detailAboutAttraction.map({ $0.images
                            })) { image in
                                UIImageView()
                                    .setImage(withUrl: image)
                                    .size(.init(width: UIScreen.main.bounds.width, height: 219))
                            }
                        }
                    }
                    .isPagingEnabled(true)
                    .hideScrollIndicators()
                    VStack {
                        Label(text: state.attractionName)
                            .setFont(.systemFont(ofSize: 32, weight: .heavy))
                            .setTextColor(.white)
                            .multilined
                        Spacer(height: 14)
                        ViewWithData (state.$detailAboutAttraction.map({ attraction in
                            AttractionDetailsView.Config(description: attraction.description, descriptionFull: attraction.descriptionFull)
                        })) { description in
                            AttractionDetailsView(config: description)
                        }
                        Spacer(height: 24)
                        ViewWithData (state.$city.map({ city in
                            CheckWeatherView.WeatherConfig(city: city)
                        })) { city in
                            CheckWeatherView(config: city)
                                .onTap(store: self.disposeBag) { [weak self] in
                                    self?.onWeatherScreen?(state.city)
                                }
                        }
                        Spacer(height: 32)
                        Label(text: Localization.AttractionFlow.AboutAttraction.onMap)
                            .setFont(.systemFont(ofSize: 24, weight: .heavy))
                            .setTextColor(.white)
                    }
                    .layoutMargins(inset: 24)
                    mapView
                        .height(214)
                        .cornerRadius(8)
                    Spacer(height: 24)
                }
            }
        }
    }
}

extension AttractionDetailsViewController {
    enum Action {
        case load
    }
    
    enum InputEvent {
        case error
    }
}
