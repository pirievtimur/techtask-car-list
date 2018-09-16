//
//  CarCell.swift
//  car-list
//
//  Created by Timur Piriev on 9/16/18.
//  Copyright © 2018 Timur Piriev. All rights reserved.
//

import UIKit

protocol ExpandableCellDelegate: class {
    func updateCell(_ cell: UITableViewCell)
}

class CarCell: UITableViewCell {
    
    static let identifier = "CarCell"
    
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var carOwnersStackView: UIStackView!
    
    weak var delegate: ExpandableCellDelegate?

    private var carModel: CarModel?
    
    func updateWithModel(model: CarModel) {
        let carName = "\(model.model)"
        let carDescription = "(\(model.type), \(model.color))"
        carLabel.text = carName + " " + carDescription
        carModel = model
    }
    
    func expand() {
        guard let carModel = self.carModel,
            let carOwners = carModel.owners,
            carOwners.count > 0,
            let delegate = self.delegate else { return }
        
        if carOwnersStackView.arrangedSubviews.isEmpty {
            let titleLabel = createLabel(text: "Previous owners: ", fontSize: 17)
            carOwnersStackView.addArrangedSubview(titleLabel)
            carOwners.forEach {
                let label = createLabel(text: " - \($0.name) \($0.phone)", fontSize: 17)
                carOwnersStackView.addArrangedSubview(label)
            }
        } else {
            carOwnersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        }

        delegate.updateCell(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        carModel = nil
        carOwnersStackView
            .arrangedSubviews
            .forEach { $0.removeFromSuperview() }
    }
}

private extension CarCell {
    func createLabel(text: String, fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: fontSize)
        
        return label
    }
}
