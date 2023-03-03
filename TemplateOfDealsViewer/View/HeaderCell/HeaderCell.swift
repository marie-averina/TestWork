import UIKit

class HeaderCell: UITableViewHeaderFooterView {
    
    static let reuseIidentifier = String(describing: HeaderCell.self)
  
    @IBOutlet weak var amountTitleLabel: UILabel!
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var sideTitleLabel: UILabel!
}
