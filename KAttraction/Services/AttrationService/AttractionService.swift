import Foundation

protocol AttractionsServiceAbstract {
    func getAttractions(in city: City, completion: @escaping (Result<[AttractionResponse], AppError>) -> Void)
    func getAttraction(
        named name: String,
        in city: City,
        completion: @escaping (Result<Attraction, AppError>) -> Void
    )
}

final class AttractionsService: AttractionsServiceAbstract {
    private let bundle: Bundle
    private let decoder: JSONDecoder

    init(bundle: Bundle = .main, decoder: JSONDecoder = JSONDecoder()) {
        self.bundle = bundle
        self.decoder = decoder
    }

    func getAttractions(in city: City, completion: @escaping (Result<[AttractionResponse], AppError>) -> Void) {
        loadAll { result in
            completion(result.map { attractions in
                attractions.filter {
                    $0.geo.name.compare(city.name, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
                }
            })
        }
    }

    func getAttraction(
        named name: String,
        in city: City,
        completion: @escaping (Result<Attraction, AppError>) -> Void
    ) {
        getAttractions(in: city) { result in
            switch result {
            case let .success(attractions):
                guard let attraction = attractions.first(where: {
                    $0.name.compare(name, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
                }) else {
                    completion(.failure(.notFound))
                    return
                }
                completion(.success(Attraction(attraction)))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func loadAll(completion: @escaping (Result<[AttractionResponse], AppError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [bundle, decoder] in
            let result: Result<[AttractionResponse], AppError>

            do {
                guard let url = bundle.url(forResource: "Attractions", withExtension: "json") else {
                    throw AppError.resourceNotFound("Attractions.json")
                }
                result = .success(try decoder.decode([AttractionResponse].self, from: Data(contentsOf: url)))
            } catch let error as AppError {
                result = .failure(error)
            } catch {
                result = .failure(.decoding(error))
            }

            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
