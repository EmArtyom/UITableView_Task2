import UIKit

// MARK: - Main ViewController
class ViewController: UITableViewController {
    
    // MARK: - UI
    private let allContacts: [ContactModel] = [
        ContactModel(name: "Joe", lastName: "Smith", photo: nil),
        ContactModel(name: "James", lastName: "James", photo: nil),
        ContactModel(name: "Alex", lastName: "Pushkin", photo: UIImage(named: "user1")),
        ContactModel(name: "Jack", lastName: nil, photo: nil),
        ContactModel(name: "Bread", lastName: "Lemon", photo: nil),
        ContactModel(name: "Adam", lastName: "Smith", photo: nil),
        ContactModel(name: "Aaron", lastName: "James", photo: nil),
        ContactModel(name: "Alex", lastName: "Brown", photo: nil),
        ContactModel(name: "Jack", lastName: "Nickols", photo: nil),
        ContactModel(name: "Brenda", lastName: "Johnson", photo: UIImage(named: "user4")),
        ContactModel(name: "Joe", lastName: "Smith", photo: nil),
        ContactModel(name: "James", lastName: "James", photo: UIImage(named: "user2")),
        ContactModel(name: "Alex", lastName: "Pit", photo: UIImage(named: "user3")),
        ContactModel(name: "Jack", lastName: nil, photo: nil),
        ContactModel(name: "Bread", lastName: "Johnson", photo: nil)
    ]
    
    private var displayedContacts: [(letter: String, contacts: [ContactModel])] = []
    
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
    
    //MARK: - update Displayed Contacts
    private func updateDisplayedContacts(_ contacts: [ContactModel]) {
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

#Preview {
    ViewController()
}
