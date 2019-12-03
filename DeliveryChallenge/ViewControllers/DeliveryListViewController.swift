import UIKit
import SnapKit
import Toast_Swift

final class DeliveryListViewController: UIViewController {
    let tableView = UITableView()
    var deliveryListViewModel: DeliveryListViewModelBehavior
    var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.defaultFontSize)
        label.textColor = ColorPallete.themeColor
        label.text =  LocalizedStrings.pullToRefresh
        label.isHidden = true
        return label
    }()
    private var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.attributedTitle = NSAttributedString(string: LocalizedStrings.pullToRefresh)
        control.tintColor = ColorPallete.themeColor
        control.endRefreshing()
        control.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return control
    }()
    var tableViewFooterRefresh: UIActivityIndicatorView = {
        let footerView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
            footerView.hidesWhenStopped = true
            footerView.color = ColorPallete.themeColor
            return footerView
    }()

    // MARK: Initalizer
    init(deliveryListViewModel: DeliveryListViewModelBehavior) {
        self.deliveryListViewModel = deliveryListViewModel
        super.init(nibName: nil, bundle: nil)
        self.deliveryListViewModel.errorCompletionHandler = handleError(error:)
        self.deliveryListViewModel.successCompletionHandler = refreshTableView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Configurations
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        title = LocalizedStrings.deliveryTitle
        view.backgroundColor = ColorPallete.baseBackgroundColor
        setUpTableView()
        setupInfoLabel()
        fetchDeliveries()
    }

    private func setupInfoLabel() {
        view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(InfoLabelConstants.height)
       }
    }

    private func setUpTableView() {
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DeliveryTableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.snp.makeConstraints { make in
                   make.edges.equalToSuperview()
        }
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = tableViewFooterRefresh
    }

    private func setUpInfoLabelBeforeFetch() {
        tableView.refreshControl?.attributedTitle = NSAttributedString(string:LocalizedStrings.infoFetchingDeliveries)
        tableView.refreshControl?.beginRefreshing()
        infoLabel.isHidden = true
    }

    private func setUpInfoLabelAfterFetch() {
        infoLabel.isHidden = deliveryListViewModel.shouldShowInfoLabel()
    }

    private func fetchDeliveries() {
        setUpInfoLabelBeforeFetch()
        deliveryListViewModel.getDeliveries()
    }

    private func refreshTableView() {
        DispatchQueue.main.async {
            self.setUpInfoLabelAfterFetch()
            self.tableViewFooterRefresh.stopAnimating()
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }

    @objc func handleRefresh(_ control: UIRefreshControl) {
        setUpInfoLabelBeforeFetch()
        deliveryListViewModel.refreshDeliveries()
    }

    private func handleError(error: ErrorModel) {
        DispatchQueue.main.async {
            self.setUpInfoLabelAfterFetch()
            self.tableView.tableFooterView = nil
            self.tableView.refreshControl?.endRefreshing()
            self.view.makeToast(error.description, duration:Constants.toastDuration , position: .bottom, style: ToastStyle())
        }
    }
}
