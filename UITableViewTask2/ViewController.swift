import UIKit

// MARK: - Models
struct SettingsModel {
    let name: String
    let lastName: String?
    let photo: UIImage?
}

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

// MARK: - Main ViewController
class ViewController: UITableViewController {
    
    // MARK: - Properties
    private let allContacts: [SettingsModel] = [
        SettingsModel(name: "Joe", lastName: "Smith", photo: nil),
        SettingsModel(name: "James", lastName: "James", photo: nil),
        SettingsModel(name: "Alex", lastName: "Pushkin", photo: UIImage(named: "user1")),
        SettingsModel(name: "Jack", lastName: nil, photo: nil),
        SettingsModel(name: "Bread", lastName: "Lemon", photo: nil),
        SettingsModel(name: "Adam", lastName: "Smith", photo: nil),
        SettingsModel(name: "Aaron", lastName: "James", photo: nil),
        SettingsModel(name: "Alex", lastName: "Brown", photo: nil),
        SettingsModel(name: "Jack", lastName: "Nickols", photo: nil),
        SettingsModel(name: "Brenda", lastName: "Johnson", photo: UIImage(named: "user4")),
        SettingsModel(name: "Joe", lastName: "Smith", photo: nil),
        SettingsModel(name: "James", lastName: "James", photo: UIImage(named: "user2")),
        SettingsModel(name: "Alex", lastName: "Pit", photo: UIImage(named: "user3")),
        SettingsModel(name: "Jack", lastName: nil, photo: nil),
        SettingsModel(name: "Bread", lastName: "Johnson", photo: nil)
    ]
    
    private var displayedContacts: [(letter: String, contacts: [SettingsModel])] = []
    private lazy var tableViewHeader = ContactsHeader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        prepareInitialData()
    }
    
    // MARK: - Setup appearance
    private func setupAppearance() {
        tableView.setupHeader(header: tableViewHeader)
        tableView.headerUpdateLayout()
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.cellIdentificator)
        tableView.tableHeaderView = tableViewHeader
        tableView.backgroundColor = .systemBackground
        tableView.sectionHeaderHeight = 40
        tableView.sectionHeaderTopPadding = 0
        
        tableViewHeader.onSearchTextChanged = { [weak self] searchText in
            self?.filterContacts(searchText: searchText)
        }
    }
    
    private func prepareInitialData() {
        filterContacts(searchText: nil)
    }
    
    //MARK: - filter func
    private func filterContacts(searchText: String?) {
        guard let searchText = searchText, !searchText.isEmpty else {
            updateDisplayedContacts(allContacts)
            return
        }
        
        let searchQuery = searchText.lowercased()
        
        let contactsToFilter = allContacts.filter { contact in
            // Создаем полное имя (имя + фамилия через пробел)
            let fullName: String
            if let lastName = contact.lastName {
                fullName = "\(contact.name.lowercased()) \(lastName.lowercased())"
            } else {
                fullName = contact.name.lowercased()
            }
            
            // Проверяем вхождение поискового запроса в полное имя
            return fullName.contains(searchQuery)
        }
        
        updateDisplayedContacts(contactsToFilter)
    }
    
    private func updateDisplayedContacts(_ contacts: [SettingsModel]) {
        let sorted = contacts.sorted {
            if $0.name != $1.name { return $0.name < $1.name }
            else { return $0.lastName ?? "" < $1.lastName ?? "" }
        }
        
        let grouped = Dictionary(grouping: sorted) {
            String($0.name.prefix(1)).uppercased()
        }
        
        displayedContacts = grouped.keys.sorted().map {
            (letter: $0, contacts: grouped[$0]!)
        }
        
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return displayedContacts.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedContacts[section].contacts.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return displayedContacts[section].letter
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.cellIdentificator,
            for: indexPath
        ) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        
        let contact = displayedContacts[indexPath.section].contacts[indexPath.row]
        cell.configure(with: contact)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

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
