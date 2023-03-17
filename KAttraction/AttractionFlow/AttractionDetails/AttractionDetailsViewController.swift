import RxSwift

final class AttractionDetailsViewController: BaseViewController {
    typealias ViewModel = AttractionDetailsViewModel
    typealias Event = InputEvent
    
    private var viewModel: ViewModel
    
    // MARK: - Handlers
    var onWeatherScreen: CityHandler?
    var showImageViewer: VoidHandler?
    
    // MARK: - UI Components
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
        viewModel.handle(.load)
    }
    
    private func setupView() {
        view.background(Color.backgroundPrimary())
        
        self.viewModel.$state
            .drive { [weak self] state in
                guard let self = self else { return }
                
                self.body(state: state).embedIn(self.view)
                self.title = state.attractionName
                
                state.$detailAboutAttraction.drive { [weak self] coordinates in
                    self?.mapView.updateMap(nameAttraction: coordinates.name, latitude: coordinates.latitude, longitude: coordinates.longitude)
                }.disposed(by: self.disposeBag)
                
            }.disposed(by: disposeBag)
    }
}

// MARK: - UI
extension AttractionDetailsViewController {
    private func body(state: ViewModel.State) -> UIView {
        ScrollView {
            VStack {
                ScrollView {
                    HStack {
                        ForEach(state.$detailAboutAttraction.map({ $0.images })) { [weak self] image in
                            UIImageView()
                                .userInteractionEnabled(true)
                                .setImage(withUrl: image)
                                .size(CGSize(width: UIScreen.main.bounds.width, height: 219))
                                .onTap(store: self?.disposeBag ?? DisposeBag()) { [weak self] in
                                    self?.showImageViewer?()
                                }
                        }
                    }
                }
                .setDelegate(self)
                .isPagingEnabled(true)
                .hideScrollIndicators()
                VStack {
                    Label(text: state.attractionName)
                        .setFont(.systemFont(ofSize: 32, weight: .heavy))
                        .setTextColor(.white)
                        .multilined
                    Spacer(height: 14)
                    ViewWithData(state.$detailAboutAttraction.map({ attraction in
                        AttractionDetailsView.Config(description: attraction.description, descriptionFull: attraction.descriptionFull)
                    })) { description in
                        AttractionDetailsView(config: description)
                    }
                    Spacer(height: 24)
                    ViewWithData(state.$city.map({ city in
                        CheckWeatherView.WeatherConfig(city: city)
                    })) { [weak self] city in
                        CheckWeatherView(config: city)
                            .onTap(store: self?.disposeBag ?? DisposeBag()) { [weak self] in
                                self?.onWeatherScreen?(state.city)
                            }
                    }
                    Spacer(height: 32)
                    Label(text: L10n.onMap())
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

// MARK: - ImageViewerControllerDelegate
extension AttractionDetailsViewController: ImageViewerControllerDelegate {
    func load(_ imageURL: String, into imageView: UIImageView, completion: (() -> Void)?) {
        imageView.setImage(withUrl: imageURL) { _ in
            completion?()
        }
    }
}

// MARK: - UIScrollViewDelegate
extension AttractionDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.state.pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}

// MARK: - Action, Event
extension AttractionDetailsViewController {
    enum Action {
        case load
    }
    
    enum InputEvent {
        case loading
        case error
    }
}
