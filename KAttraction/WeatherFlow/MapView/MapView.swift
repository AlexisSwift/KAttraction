import MapKit
import SnapKit

final class MapView: UIView {
    
    private let mapView = MKMapView()
    private let mark = MKPointAnnotation()
    
    init() {
        super.init(frame: .zero)
        setupMap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMap() {
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.mapType = .standard
        mapView.addAnnotation(mark)
        addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.top.right.left.bottom.equalToSuperview()
        }
    }
    
    func updateMap(nameAttraction: String, latitude: Double, longitude: Double) {
        mapView.setupCenterOnMap(CLLocation(latitude: latitude, longitude: longitude))
        mark.title = nameAttraction
        mark.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
