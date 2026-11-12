struct Attraction {
    let images: [String]
    let name: String
    let description: String
    let descriptionFull: String
    let cityName: String
    let longitude: Double
    let latitude: Double
}

extension Attraction {
    init(_ response: AttractionResponse) {
        images = response.images
        name = response.name
        description = response.description
        descriptionFull = response.descfull
        cityName = response.geo.name
        longitude = response.geo.lon
        latitude = response.geo.lan
    }
}
