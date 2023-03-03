import UIKit

class DealsListViewController: UIViewController {
    
    //MARK: - Private properties
    private var isSortedUp = true
    private let server = Server()
    private var allDeals: [Deal] = [] {
        didSet {
            let count = allDeals.count
            if count < 1000 {
                view.activityStartAnimating(activityColor: .systemIndigo, backgroundColor: .gray)
            } else {
                view.activityStopAnimating()
            }
            if count % 1000 == 0 {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - @IBOutlet
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var criteriaPicker: CriteriaPicker!
    
    //MARK: DetailsViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupCriteriaPicker()
        guard let criteria = criteriaPicker.selectedCriteria else { return }
        getData(sortedBy: criteria)
        updateBarButton()
    }
    
    //MARK: - Objective-C
    @objc private func criteriaPicked() {
        DispatchQueue.main.async {
            self.criteriaPicker.sortByChosenCriteria(deals: &self.allDeals, isSortedUp: self.isSortedUp)
            self.tableView.reloadData()
        }
    }

    @objc func changeSortingDirection() {
       isSortedUp = !isSortedUp
       updateBarButton()
        DispatchQueue.main.async {
            self.criteriaPicker.sortByChosenCriteria(deals: &self.allDeals, isSortedUp: self.isSortedUp)
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Private methods
    private func setupTableView() {
        navigationItem.title = "Deals"
        tableView.register(UINib(nibName: DealCell.reuseIidentifier, bundle: nil), forCellReuseIdentifier: DealCell.reuseIidentifier)
        tableView.register(UINib(nibName: HeaderCell.reuseIidentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: HeaderCell.reuseIidentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        tableView.separatorColor = .systemIndigo
    }
    
    private func setupCriteriaPicker() {
        criteriaPicker.addTarget(self, action: #selector(criteriaPicked), for: .valueChanged)
        criteriaPicker.selectedCriteria = .date
    }
    
    private func getData(sortedBy: Criteria) {
        server.subscribeToDeals { [weak self] deals in
            guard let self = self else { return }
            var sortedDeals = [Deal]()
            DispatchQueue.main.async {
                sortedDeals.append(contentsOf: deals)
                self.criteriaPicker.sortByChosenCriteria(deals: &sortedDeals, isSortedUp: self.isSortedUp)
                self.allDeals.append(contentsOf: sortedDeals)
            }
        }
    }
        
    private func updateBarButton() {
        let downButton =
        UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(changeSortingDirection))
        downButton.tintColor = .systemIndigo
        let upButton =
        UIBarButtonItem(image: UIImage(systemName: "chevron.up"), style: .plain, target: self, action: #selector(changeSortingDirection))
        upButton.tintColor = .systemIndigo
        if isSortedUp {
            navigationItem.rightBarButtonItem = upButton
        } else {
            navigationItem.rightBarButtonItem = downButton
        }
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate
extension DealsListViewController: UITableViewDataSource, UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allDeals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DealCell.reuseIidentifier, for: indexPath) as! DealCell
        let deal = allDeals[indexPath.row]
        cell.setDeal(deal: deal)
        return cell
    }
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderCell.reuseIidentifier) as! HeaderCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
