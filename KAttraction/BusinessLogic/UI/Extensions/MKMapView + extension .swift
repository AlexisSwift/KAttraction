import MapKit

extension MKMapView {
    func setupCenterOnMap(_ location: CLLocation, regionRadius: CLLocationDistance = 200) {
        setRegion(MKCoordinateRegion(
            center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius
        ), animated: true)
    }
}
