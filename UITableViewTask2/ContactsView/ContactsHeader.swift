import UIKit

// MARK: - ContactsHeader
final class ContactsHeader: UIView, UISearchBarDelegate {
    private let searchBar = UISearchBar()
    var onSearchTextChanged: ((String?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayoutAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayoutAppearance() {
        let titleHeader = UILabel()
        titleHeader.text = "Контакты"
        titleHeader.textColor = .label
        titleHeader.font = .systemFont(ofSize: 30, weight: .bold)
        titleHeader.textAlignment = .left
        
        searchBar.delegate = self
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        
        let separatorLine = UIView()
        separatorLine.layer.borderWidth = 2
        separatorLine.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        addSubview(titleHeader)
        addSubview(searchBar)
        addSubview(separatorLine)
        
        titleHeader.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleHeader.topAnchor.constraint(equalTo: topAnchor),
            titleHeader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleHeader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleHeader.heightAnchor.constraint(equalToConstant: 30),
            
            searchBar.topAnchor.constraint(equalTo: titleHeader.bottomAnchor, constant: 5),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            separatorLine.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        onSearchTextChanged?(searchText.isEmpty ? nil : searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        onSearchTextChanged?(nil)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

#Preview {
    ViewController()
}
