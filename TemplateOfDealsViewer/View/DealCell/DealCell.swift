import UIKit

class DealCell: UITableViewCell {
    
    static let reuseIidentifier = String(describing: DealCell.self)
  
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var instrumentNameLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    @IBOutlet private var sideLabel: UILabel!
    
    func setDeal(deal: Deal) {
        dateLabel.text = deal.dateModifier.getString()
        instrumentNameLabel.text = deal.instrumentName
        priceLabel.text = String(round(deal.price))
        amountLabel.text = String(Int(deal.amount))

        switch deal.side {
        case .sell:
            sideLabel.text = "Sell"
            priceLabel.textColor = .red
        case .buy:
            sideLabel.text = "Buy"
            priceLabel.textColor = .green
        }
    }
}
