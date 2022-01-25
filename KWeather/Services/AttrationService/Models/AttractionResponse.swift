struct AttractionResponse: Decodable {
    let description: String
    let descfull: String
    let geo: Geoposition
    let images: [String]
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case description = "desc"
        case descfull
        case geo
        case images
        case name
    }
}

struct Geoposition: Decodable {
    let lan: Double
    let lon: Double
    let name: String
}
