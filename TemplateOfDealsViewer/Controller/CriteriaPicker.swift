//
//  CriteriaPicker.swift
//  TemplateOfDealsViewer
//
//  Created by Мария Аверина on 26.02.2023.
//

import UIKit

//MARK: - Sorting options
enum Criteria: Int {
    case date, instrument, price, amount, side
    static let allCriterias: [Criteria] = [date, instrument, price, amount, side]
    
    var title: String {
        switch self {
        case .date: return "Date"
        case .instrument: return "Currency"
        case .price: return "Price"
        case .amount: return "Amount"
        case .side: return "Side"
        }
    }
}

final class CriteriaPicker: UIControl {
    
    //MARK: - Publick properties
    var selectedCriteria: Criteria? = nil {
        didSet {
            self.updateSelectedCriteria()
            self.sendActions(for: .valueChanged)
        }
    }
    
    //MARK: - Private properties
    private var buttons: [UIButton] = []
    private var stackView: UIStackView!
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupView()
    }
    
    //MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stackView.frame = bounds
    }
    
    //MARK: - Objective-C
    @objc func selectedCriteria(_ sender: UIButton) {
        guard let index = self.buttons.firstIndex(of: sender),
              let criteria = Criteria(rawValue: index)
        else { return }
        
        self.selectedCriteria = criteria
    }
    
    //MARK: - Private methods
    private func setupView() {
        for criteria in Criteria.allCriterias {
            let button = UIButton(type: .system)
            button.setTitle(criteria.title, for: .normal)
            button.setTitleColor(.lightGray, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.addTarget(self, action: #selector(selectedCriteria(_:)), for: .touchUpInside)
            self.buttons.append(button)
        }
        stackView = UIStackView(arrangedSubviews: self.buttons)
        self.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
    }
    
    private func updateSelectedCriteria() {
        for (index, button) in self.buttons.enumerated() {
            guard let criteria = Criteria(rawValue: index) else { continue }
            
            button.isSelected = criteria == self.selectedCriteria
        }
    }
    
    //MARK: - Public methods
    func sortByChosenCriteria( deals: inout [Deal], isSortedUp: Bool) {
        if isSortedUp {
            switch self.selectedCriteria {
            case .date:
                deals.sort(by: {$0.dateModifier > $1.dateModifier})
            case .instrument:
                deals.sort(by: {$0.instrumentName > $1.instrumentName})
            case .price:
                deals.sort(by: {$0.price > $1.price})
            case .amount:
                deals.sort(by: {$0.amount > $1.amount})
            case .side:
                let sides = Deal.Side.allCases
                deals.sort(by:  {sides.firstIndex(of: $0.side)! >  sides.firstIndex(of: $1.side)! })
            default: break
            }
        } else {
            switch self.selectedCriteria {
            case .date:
                deals.sort(by: {$0.dateModifier < $1.dateModifier})
            case .instrument:
                deals.sort(by: {$0.instrumentName < $1.instrumentName})
            case .price:
                deals.sort(by: {$0.price < $1.price})
            case .amount:
                deals.sort(by: {$0.amount < $1.amount})
            case .side:
                let sides = Deal.Side.allCases
                deals.sort(by:  {sides.firstIndex(of: $0.side)! <  sides.firstIndex(of: $1.side)! })
            default: break
            }
        }
    }
}
