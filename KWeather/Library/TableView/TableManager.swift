import UIKit

public protocol TableManagerAbstract: List {
    typealias Section = ListSection

    var tableView: TableViewProtocol? { get set }
    var scrollViewDelegate: UIScrollViewDelegate? { get set }

    func remove(sections indices: [Int], withAnimation animation: UITableView.RowAnimation)
    func remove(items: [(index: Int, section: Int)],
                removeEmptySections: Bool,
                withAnimation animation: UITableView.RowAnimation)

    func set(items: [Section.Item])
    func set(items: [Section.Item], withAnimation: UITableView.RowAnimation)

    func insert(_ elements: [(items: [(item: Section.Item, itemIndex: Int)], sectionIndex: Int)], withAnimation animation: UITableView.RowAnimation)

    func update(_ elements: [(section: Section, index: Int)], withAnimation animation: UITableView.RowAnimation)
    func update(_ elements: [(items: [(item: Section.Item, itemIndex: Int)], sectionIndex: Int)], withAnimation animation: UITableView.RowAnimation)
}

public extension TableManagerAbstract {
    func set(items: [Section.Item]) {
        set(items: items, withAnimation: .automatic)
    }

    func remove(sections indices: [Int]) {
        remove(sections: indices, withAnimation: .automatic)
    }

    func remove(items: [(index: Int, section: Int)]) {
        remove(items: items, withAnimation: .automatic)
    }

    func remove(items: [(index: Int, section: Int)], withAnimation animation: UITableView.RowAnimation) {
        remove(items: items, removeEmptySections: true, withAnimation: animation)
    }

    func remove(items: [(index: Int, section: Int)], removeEmptySections: Bool) {
        remove(items: items, removeEmptySections: removeEmptySections, withAnimation: .automatic)
    }

    func update(_ elements: [(section: Section, index: Int)]) {
        update(elements, withAnimation: .automatic)
    }

    func update(_ elements: [(items: [(item: Section.Item, itemIndex: Int)], sectionIndex: Int)]) {
        update(elements, withAnimation: .automatic)
    }

    func insert(_ elements: [(items: [(item: Section.Item, itemIndex: Int)], sectionIndex: Int)]) {
        insert(elements, withAnimation: .automatic)
    }
}

public protocol TableViewProtocol: AnyObject {
    var delegate: UITableViewDelegate? { get set }
    var dataSource: UITableViewDataSource? { get set }
    var sectionHeaderHeight: CGFloat { get set }
    var sectionFooterHeight: CGFloat { get set }
    var tableHeaderView: UIView? { get set }
    var tableFooterView: UIView? { get set }

    func reloadData()
    func insertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation)
    func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation)
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath)
    @available(iOS 11.0, *)
    func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?)
    func beginUpdates()
    func endUpdates()
    func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation)
}

extension UITableView: TableViewProtocol { }

final class BaseTableManager: NSObject, TableManagerAbstract {

    public weak var tableView: TableViewProtocol? { // UITableView? {
        didSet {
            tableView?.delegate = self
            tableView?.dataSource = self
            tableView?.sectionHeaderHeight = UITableView.automaticDimension
            tableView?.tableFooterView = UIView()
        }
    }

    public weak var scrollViewDelegate: UIScrollViewDelegate?

    public var sections: [Section] = []

    // MARK: - Getters

    public func item(at indexPath: IndexPath) -> Section.Item {
        return item(at: indexPath.row, section: indexPath.section)
    }

    // MARK: - Setters

    public func set(sections: [Section]) {
        guard Thread.current.isMainThread else {
            assertionFailure()
            return
        }

        self.sections = sections
        tableView?.reloadData()
    }

    public func set(section: Section) {
        set(sections: [section])
    }

    public func set(items: [Section.Item]) {
        set(section: Section(items: items))
    }

    public func set(headers: [Section.Header]) {
        set(
            sections: zip(sections, headers).map { (section, header) in
                return Section(header: header, items: section.items, footer: section.footer)
            }
        )
    }

    public func set(footers: [Section.Header]) {
        set(
            sections: zip(sections, footers).map { (section, footer) in
                return Section(header: section.header, items: section.items, footer: footer)
            }
        )
    }

    // MARK: - Updates

    public func set(items: [Section.Item],
                    withAnimation animation: UITableView.RowAnimation) {
        sections = [Section(items: items)]
        tableView?.reloadSections(IndexSet(integer: 0), with: .automatic)
    }

    public func remove(sections indices: [Int], withAnimation animation: UITableView.RowAnimation = .automatic) {
        guard Thread.current.isMainThread else {
            assertionFailure()
            return
        }

        var indexSet: IndexSet = .init()
        indices.sorted(by: <).forEach { index in
            sections.remove(at: index)
            indexSet.insert(index)
        }
        if indexSet.count > .zero {
            tableView?.deleteSections(indexSet, with: animation)
        }
    }

    public func remove(items: [(index: Int, section: Int)],
                       removeEmptySections: Bool,
                       withAnimation animation: UITableView.RowAnimation) {
        guard Thread.current.isMainThread else {
            assertionFailure()
            return
        }

        let sortedItems = items.sorted { (lhs, rhs) -> Bool in
            if lhs.section == rhs.section {
                return lhs.index < rhs.index
            } else {
                return lhs.section < rhs.section
            }
        }

        var countInSection: [Int: Int] = [:]
        var indexPaths: [IndexPath] = []
        var sectionsToRemove: IndexSet = .init()

        sortedItems.reversed().forEach { item in
            indexPaths.append(IndexPath(row: item.index, section: item.section))
            if removeEmptySections {
                countInSection[item.section] = countInSection[item.section, default: 0] + 1
                if countInSection[item.section] == self.items(ofSection: item.section).count {
                    sections.remove(at: item.section)
                    sectionsToRemove.insert(item.section)
                }
            }
        }

        tableView?.deleteRows(at: indexPaths, with: animation)

        if removeEmptySections {
            tableView?.deleteSections(sectionsToRemove, with: animation)
        }
    }

    public func update(
        _ elements: [(section: Section, index: Int)],
        withAnimation animation: UITableView.RowAnimation = .automatic
    ) {
        guard Thread.current.isMainThread else {
            assertionFailure()
            return
        }

        var indexSet: IndexSet = .init()
        for (section, index) in elements {
            guard sections[safe: index] != nil else {
                continue
            }
            sections[index] = section
            indexSet.insert(index)
        }
        tableView?.reloadSections(indexSet, with: animation)
    }

    public func update(
        _ elements: [(items: [(item: Section.Item, itemIndex: Int)], sectionIndex: Int)],
        withAnimation animation: UITableView.RowAnimation = .automatic
    ) {
        guard Thread.current.isMainThread else {
            assertionFailure()
            return
        }

        var indexPaths: [IndexPath] = []
        for (items, sectionIndex) in elements {
            guard let section = sections[safe: sectionIndex] else {
                continue
            }
            var replacingItems = section.items

            for (item, itemIndex) in items where section.items[safe: itemIndex] != nil {
                replacingItems[itemIndex] = item
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                indexPaths.append(indexPath)
            }

            sections[sectionIndex] = Section(
                header: section.header,
                items: replacingItems,
                footer: section.footer
            )
        }

        tableView?.reloadRows(at: indexPaths, with: animation)
    }

    public func insert(
        _ elements: [(items: [(item: Section.Item, itemIndex: Int)], sectionIndex: Int)],
        withAnimation animation: UITableView.RowAnimation
    ) {
        var newSectionIndexSet: IndexSet = .init()
        var itemsIndexPaths: [IndexPath] = []
        elements.forEach { items, sectionIndex in
            if sections.count < sectionIndex {
                let realSectionIndex = sections.count
                sections.append(Section(items: items.map { $0.item }))
                newSectionIndexSet.insert(realSectionIndex)
            } else {
                items.forEach { item in
                    sections[sectionIndex].items.insert(item.item, at: item.itemIndex)
                    itemsIndexPaths.append(IndexPath(row: item.itemIndex, section: sectionIndex))
                }
            }
        }
        tableView?.insertSections(newSectionIndexSet, with: animation)
        tableView?.insertRows(at: itemsIndexPaths, with: animation)
    }
}

extension BaseTableManager: UITableViewDataSource {
    public func numberOfSections(in _: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items(ofSection: section).count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withModel: item(at: indexPath), for: indexPath)
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerModel = header(ofSection: section) else {
            return nil
        }
        return tableView.dequeueReusableHeaderFooterView(withModel: headerModel)
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerModel = footer(ofSection: section) else {
            return nil
        }
        return tableView.dequeueReusableHeaderFooterView(withModel: footerModel)
    }
}

extension BaseTableManager: UITableViewDelegate {
    public func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let fixedHeight = (item(at: indexPath) as? CellViewModelHeightable)?.height {
            return fixedHeight
        }
        return UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let fixedHeight = (item(at: indexPath) as? CellViewModelHeightable)?.height {
            return fixedHeight
        }
        return UITableView.automaticDimension
    }

    public func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let header = header(ofSection: section) else {
            return .leastNormalMagnitude
        }
        if let fixedHeight = (header as? CellViewModelHeightable)?.height {
            return fixedHeight
        }
        return UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let footer = footer(ofSection: section) else {
            return .leastNormalMagnitude
        }
        if let fixedHeight = (footer as? CellViewModelHeightable)?.height {
            return fixedHeight
        }
        return UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = item(at: indexPath) as? CellViewModelActionable else { return }
        tableView.cellForRow(at: indexPath)?.isSelected = true
        item.onClickOnAnyModel()
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let item = item(at: indexPath) as? CellViewModelActionable else { return }
        tableView.cellForRow(at: indexPath)?.isSelected = false
        item.onUnclickOnAnyModel?()
    }
}

// MARK: - UIScrollViewDelegate

extension BaseTableManager {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        scrollViewDelegate?.scrollViewWillEndDragging?(
            scrollView,
            withVelocity: velocity,
            targetContentOffset: targetContentOffset
        )
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidScroll?(scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
}
