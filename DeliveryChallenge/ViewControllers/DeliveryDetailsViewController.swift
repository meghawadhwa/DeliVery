import UIKit
import MapKit
import SnapKit

final class DeliveryDetailsViewController: UIViewController {
    var mapView: MKMapView!
    var deliveryDetailCell: DeliveryTableViewCell!
    var cellSuperview: UIView!
    let viewModel: DeliveryDetailsViewModelBehavior
    // MARK: Initalizer
    init(deliveryDetailsViewModel: DeliveryDetailsViewModelBehavior) {
        self.viewModel = deliveryDetailsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Map
    private func addPlacemark() {
        let placemark = MKPointAnnotation()
        let coordinates = viewModel.getMapCoordinates()
        placemark.title = coordinates.address
        placemark.coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        mapView.addAnnotation(placemark)
        mapView.showAnnotations([placemark], animated: false)
    }
    // MARK: View SetUp
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        view.backgroundColor = ColorPallete.baseBackgroundColor
        title = LocalizedStrings.deliveryDetails
        addCellSuperview()
        addCell()
        addMap()
        addPlacemark()
    }

    private func addCellSuperview() {
        cellSuperview = UIView()
        view.addSubview(cellSuperview)
        cellSuperview.snp.remakeConstraints { make in
            make.bottom.equalTo(view.snp.bottom)
            make.right.equalTo(view.snp.rightMargin)
            make.left.equalTo(view.snp.leftMargin)
        }
    }

    private func addCell() {
        deliveryDetailCell = DeliveryTableViewCell(style: .default,
        reuseIdentifier: Constants.cellIdentifier, aSuperview: cellSuperview)
        deliveryDetailCell.configureUIForDetailView(viewModel: viewModel)
        view.addSubview(deliveryDetailCell)
    }

    private func addMap() {
        mapView = MKMapView(frame: view.frame)
        view.addSubview(mapView)
            mapView.snp.makeConstraints { make in
                make.top.equalTo(view.snp.top)
                make.left.equalTo(view.snp.left)
                make.right.equalTo(view.snp.right)
                make.bottom.equalTo(cellSuperview.snp.top)
            }
    }
}
