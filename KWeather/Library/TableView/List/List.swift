public struct ListSection {
    public typealias Header = CellViewModel
    public typealias Footer = CellViewModel
    public typealias Item = CellViewModel
    public let header: Header?
    public var items: [Item]
    public let footer: Footer?

    public init(
        header: ListSection.Header? = nil,
        items: [ListSection.Item],
        footer: ListSection.Footer? = nil
    ) {
        self.header = header
        self.items = items
        self.footer = footer
    }
}

public protocol List: AnyObject {
    typealias Section = ListSection

    var sections: [Section] { get }

    // MARK: - Getters
    func item(at index: Int, section: Int) -> Section.Item
    func items(ofSection section: Int) -> [Section.Item]
    func header(ofSection section: Int) -> Section.Header?
    func footer(ofSection section: Int) -> Section.Footer?

    // MARK: - Setters
    func set(sections: [Section])
    func set(section: Section)
    func set(items: [Section.Item])
    func set(headers: [Section.Header])
    func set(footers: [Section.Header])
}

public extension List {
    func header(ofSection section: Int) -> Section.Header? {
        return sections[safe: section]?.header
    }

    func item(at index: Int, section: Int) -> Section.Item {
        return items(ofSection: section)[index]
    }

    func items(ofSection section: Int) -> [Section.Item] {
        return sections[safe: section]?.items ?? []
    }

    func footer(ofSection section: Int) -> Section.Footer? {
        return sections[safe: section]?.footer
    }
}
