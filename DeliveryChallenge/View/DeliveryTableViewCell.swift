import UIKit
import SDWebImage
import SnapKit

private struct DeliveryCellConstants {
    static let cornerRadius: CGFloat = 10.0
    static let numberOfLines = 0
    static let defaultFontSize: CGFloat = 14.0
    static let defaultImageSize = CGSize(width: 60.0, height: 60.0)
    static let topLeftOffset = 10.0
    static let bottomRightOffset = -10.0
}

final class DeliveryTableViewCell: UITableViewCell {
    var desiredSuperView: UIView!
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPallete.cellBackgroundColor
        view.layer.cornerRadius = DeliveryCellConstants.cornerRadius
        return view
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorPallete.labelTextColor
        label.numberOfLines = DeliveryCellConstants.numberOfLines
        label.font = UIFont.boldSystemFont(ofSize: DeliveryCellConstants.defaultFontSize)
        return label
    }()

    let deliveryImage: UIImageView = {
        let deliveryImage = UIImageView()
        deliveryImage.image = UIImage(named: Constants.placeHolderImageName)
        deliveryImage.contentMode = UIView.ContentMode.scaleAspectFill
        deliveryImage.clipsToBounds = true
        return deliveryImage
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        desiredSuperView = contentView
        setUpView()
    }

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, aSuperview: UIView) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        desiredSuperView = aSuperview
        setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setUpView() {
        addSubViews()
        selectionStyle = .none
    }

    private func addSubViews() {
        desiredSuperView.addSubview(cellView)
        cellView.addSubview(descriptionLabel)
        cellView.addSubview(deliveryImage)
        addConstraints()
    }

    private func addConstraints() {
         deliveryImage.snp.makeConstraints { make in
            make.left.top.equalTo(DeliveryCellConstants.topLeftOffset)
            make.size.equalTo(DeliveryCellConstants.defaultImageSize)
            make.bottom.lessThanOrEqualTo(DeliveryCellConstants.bottomRightOffset)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(DeliveryCellConstants.topLeftOffset)
            make.left.equalTo(deliveryImage.snp.right).offset(DeliveryCellConstants.topLeftOffset)
            make.right.equalTo(DeliveryCellConstants.bottomRightOffset)
            make.bottom.greaterThanOrEqualTo(cellView.snp.bottom)
                .offset(DeliveryCellConstants.bottomRightOffset)
            make.centerY.equalTo(cellView.snp.centerY)
        }
        cellView.snp.makeConstraints { make in
            make.top.equalTo(desiredSuperView.snp.topMargin)
            make.left.equalTo(desiredSuperView.snp.leftMargin)
            make.right.equalTo(desiredSuperView.snp.rightMargin)
            make.bottom.equalTo(desiredSuperView.snp.bottomMargin)
        }
    }

     func setUpImageView(_ imageUrl: URL?) {
        let placeHolderImage = UIImage.init(named: Constants.placeHolderImageName)
        deliveryImage.sd_setImage(with: imageUrl, placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
    }

    func configureUI(viewModel: DeliveryListViewModelBehavior, index: Int) {
        setUpImageView(viewModel.getImageUrl(forIndex: index))
        descriptionLabel.text = viewModel.getDescriptionText(forIndex: index)
    }

    // Used different configuration for detail view
    func configureUIForDetailView(viewModel: DeliveryDetailsViewModelBehavior) {
        setUpImageView(viewModel.getImageUrl())
        descriptionLabel.text = viewModel.getDescriptionText()
    }
}
