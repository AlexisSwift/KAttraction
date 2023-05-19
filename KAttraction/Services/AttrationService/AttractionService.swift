protocol AttractionsServiceAbstract {
    func getAttractions(for city: String, completion: @escaping (Result<[AttractionResponse], AppError>) -> Void)
}

final class AttractionsService: AttractionsServiceAbstract {
    func getAttractions(for city: String, completion: @escaping (Result<[AttractionResponse], AppError>) -> Void) {
        NetworkRequestManager.request(BasicEndpoints.getAttractions, completion: completion)
    }
}
