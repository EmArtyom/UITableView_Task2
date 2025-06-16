import UIKit

final class SettingsTableViewCell : UITableViewCell {
    
    private let contactName = UILabel()
    private let contactLastName = UILabel()
    private let contactPhoto = UIImageView()
    
    static let cellIdentificator = "CellIdentificator"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [contactName, contactLastName, contactPhoto].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            contactName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contactName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contactName.heightAnchor.constraint(equalToConstant: 40),

            contactLastName.leadingAnchor.constraint(equalTo: contactName.trailingAnchor, constant: 8),
            contactLastName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            contactPhoto.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contactPhoto.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contactPhoto.widthAnchor.constraint(equalToConstant: 50),
            contactPhoto.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        contentView.backgroundColor = .clear
        
        [contactName, contactLastName].forEach({ contact in
            contact.font = .systemFont(ofSize: 24, weight: .regular)
            contact.textColor = .label
        })
        
        contactPhoto.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contactName.text = nil
        contactLastName.text = nil
        contactPhoto.image = nil
    }
        
    func configure(with model: SettingsModel) {
        contactName.text = model.name
        contactLastName.text = model.lastName
        contactPhoto.image = model.photo
    }
}
