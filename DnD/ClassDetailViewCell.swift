//
//  ClassDetailViewCell.swift
//  DnD
//
//  Created by Aleksey Nikolaenko on 15.07.2022.
//

import UIKit
import Combine

class ClassDetailViewCell: UITableViewCell {

    private var viewModel: ClassDetailViewModel?
    private var cancellables: Set<AnyCancellable> = []

    private lazy var spellName: UILabel = {
        let spellName = UILabel()
        spellName.translatesAutoresizingMaskIntoConstraints = false
        spellName.numberOfLines = 1
        spellName.textColor = .black
        spellName.font = UIFont.boldSystemFont(ofSize: 14)
        spellName.textAlignment = .left
        return spellName
    }()

    lazy var spellDescription: UILabel = {
        let spellDescription = UILabel()
        spellDescription.translatesAutoresizingMaskIntoConstraints = false
        spellDescription.numberOfLines = 0
        spellDescription.textColor = .black
        spellDescription.font = UIFont.systemFont(ofSize: 12)
        spellDescription.textAlignment = .left
        return spellDescription
    }()
    
    private lazy var spellDescriptionHeightConstraint = spellDescription.heightAnchor.constraint(equalToConstant: 0)
        

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(spellName)
        contentView.addSubview(spellDescription)
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            spellName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            spellName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            spellName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            spellDescription.topAnchor.constraint(equalTo: spellName.bottomAnchor, constant: 0),
            spellDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            spellDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            spellDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            spellDescriptionHeightConstraint
        ])
    }
    
    override func prepareForReuse() {
        spellDescriptionHeightConstraint.constant = 0
    }
    
    private func bindViewModel() {
        viewModel?.$spellDescriptions.sink { [weak self] newSpellspellDescriptions in
            let joinedDescription = newSpellspellDescriptions.joined(separator: " ")
            self?.spellDescription.text = joinedDescription
            self?.spellDescriptionHeightConstraint.constant = 100
        }.store(in: &cancellables)
    }

    func config(spellModel: ClassDetailsViewModel.SpellModel) {
        spellName.text = spellModel.name
        viewModel = ClassDetailViewModel(spellIndex: spellModel.index)
        bindViewModel()
    }
}


private extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
