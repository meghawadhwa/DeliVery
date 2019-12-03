import Foundation
import UIKit

extension DeliveryListViewController: UITableViewDelegate, UIScrollViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let delivery = deliveryListViewModel.getDeliveryFor(index: indexPath.row)
        let viewModel = DeliveryDetailsViewModel(delivery: delivery)
        let deliveryDetails = DeliveryDetailsViewController(deliveryDetailsViewModel: viewModel)
        navigationController?.pushViewController(deliveryDetails, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if deliveryListViewModel.shouldFetchNextData(index: indexPath.row) {
            tableView.tableFooterView = self.tableViewFooterRefresh
            self.tableViewFooterRefresh.startAnimating()
            deliveryListViewModel.getNextPageData()
        }
    }
}
