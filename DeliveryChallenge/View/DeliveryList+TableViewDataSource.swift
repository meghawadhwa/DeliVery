import UIKit

extension DeliveryListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryListViewModel.countOfDeliveries()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let identifier = Constants.cellIdentifier
        if let aCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? DeliveryTableViewCell {
            aCell.configureUI(viewModel: deliveryListViewModel, index: indexPath.row)
            cell = aCell
        }
        return cell
    }
}
