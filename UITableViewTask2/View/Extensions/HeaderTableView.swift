import UIKit

// MARK: - TableView Header Setup
extension UITableView {
    func setupHeader(header: UIView) {
        header.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderView = header
        header.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        header.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        header.layer.cornerRadius = 20
        header.backgroundColor = .systemBackground
    }
    
    func headerUpdateLayout() {
        guard let tableHeader = tableHeaderView else { return }
        tableHeader.setNeedsLayout()
        tableHeader.layoutIfNeeded()
    }
}
