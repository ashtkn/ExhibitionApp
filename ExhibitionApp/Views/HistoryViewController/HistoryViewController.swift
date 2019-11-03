import UIKit
import SafariServices
import SnapKit

final class HistoryViewController: UIViewController {
    
    private static let padding: CGFloat = 15
    
    private weak var headerTitleLabel: UILabel! {
        didSet {
            self.headerTitleLabel.text = viewModel.headerTitleLabelText
        }
    }
    
    private weak var scannedWorksCounterTextLabel: UILabel! {
        didSet {
            self.scannedWorksCounterTextLabel.text = viewModel.scannedWorksCounterTextLabelText
        }
    }
    
    private weak var scannedWorksCounterNumberLabel: UILabel! {
        didSet {
            self.scannedWorksCounterNumberLabel.text = viewModel.scannedWorksCounterNumberLabelText
        }
    }
    
    private weak var scannedWorksCounterProgressView: UIProgressView! {
        didSet {
            let value = viewModel.scannedWorksCounterProgressViewValue
            self.scannedWorksCounterProgressView.setProgress(value, animated: false)
        }
    }
    
    private weak var scannedWorksCollectionView: UICollectionView! {
        didSet {
            self.scannedWorksCollectionView.dataSource = self
            self.scannedWorksCollectionView.delegate = self
            self.scannedWorksCollectionView.register(cellType: WorkCollectionViewCell.self)
            self.scannedWorksCollectionView.register(WorkCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WorkCollectionHeaderView.className)
        }
    }

    private var viewModel = HistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews()
        self.updateSubviews()
        
        // Subscribe DataStore
        viewModel.setDataStoreSubscription { [unowned self] in
            self.updateSubviews()
        }
    }
    
    private func setupSubviews() {
        var containerView = UIView()
        self.view.addSubview(containerView)
        
        let safeArea = self.view.safeArea
        containerView.backgroundColor = ColorManager.default.getColor(name: .backgroundWhite)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(safeArea.top)
            make.bottom.equalTo(safeArea.bottom)
            make.leading.equalTo(safeArea.leading)
            make.trailing.equalTo(safeArea.trailing)
        }
        
        let subContainerViews = HistoryViewController.addSubContainers(parent: &containerView)
        
        var headerViewContainer = subContainerViews.headerViewContainer
        self.headerTitleLabel = HistoryViewController.addHeaderView(parent: &headerViewContainer)
        
        var scannedWorksCounterViewContainer = subContainerViews.counterViewContainer
        let scannedWorksCounterView = HistoryViewController.addScannedWorksCounterView(parent: &scannedWorksCounterViewContainer)
        self.scannedWorksCounterTextLabel = scannedWorksCounterView.textLabel
        self.scannedWorksCounterNumberLabel = scannedWorksCounterView.numberLabel
        self.scannedWorksCounterProgressView = scannedWorksCounterView.progressView

        var scannedWorksCollectionViewContainer = subContainerViews.collectionViewContainer
        self.scannedWorksCollectionView = HistoryViewController.addScannedWorksCollectionView(parent: &scannedWorksCollectionViewContainer)
    }
    
    private func updateSubviews() {
        self.scannedWorksCounterNumberLabel.text = viewModel.scannedWorksCounterNumberLabelText
        
        let value = viewModel.scannedWorksCounterProgressViewValue
        self.scannedWorksCounterProgressView.setProgress(value, animated: false)
        
        updateScannedWorksCollectionView()
    }
    
    private func updateScannedWorksCollectionView() {
        self.scannedWorksCollectionView.reloadData()
        
        var backgroundViewContainer = UIView()
        self.scannedWorksCollectionView.backgroundView = backgroundViewContainer
        if viewModel.unlockedWorks.count == 0 {
            HistoryViewController.addScannedWorksCollectionViewBackgroundViewSubviews(parent: &backgroundViewContainer)
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension HistoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let prototypeCell = scannedWorksCollectionView.getNib(cellType: WorkCollectionViewCell.self)
        prototypeCell.bounds.size.width = cellWidth
        prototypeCell.contentView.bounds.size.width = cellWidth
        
        let size = prototypeCell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        return size
    }
    
    private var cellWidth: CGFloat {
        let padding = HistoryViewController.padding
        let availableWidth = scannedWorksCollectionView.bounds.inset(by: scannedWorksCollectionView.adjustedContentInset).width
        let interColumnSpace = padding
        let numColumns = CGFloat(1)
        let numInterColumnSpaces = numColumns - 1
        
        return ((availableWidth - interColumnSpace * numInterColumnSpaces) / numColumns).rounded(.down) - padding * 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 56)
    }

}

// MARK: UICollectionViewDataSource

extension HistoryViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.unlockedWorks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: WorkCollectionViewCell.self, for: indexPath)
        let work = viewModel.unlockedWorks[indexPath.row]
        cell.configure(WorkCollectionViewCellModel(from: work))
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WorkCollectionHeaderView.className, for: indexPath)
        return header
    }
}

// MARK: UICollectionViewDelegate

extension HistoryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let work = viewModel.unlockedWorks[indexPath.row]
        let url = URL(string: work.url)!
        let safariViewController = SFSafariViewController(url: url)
        
        DispatchQueue.main.async { [unowned self] in
            self.present(safariViewController, animated: true, completion: nil)
        }
    }
}

// MARK: - Views

extension HistoryViewController {
    
    private static func addSubContainers(parent containerView: inout UIView) -> (headerViewContainer: UIView, counterViewContainer: UIView, collectionViewContainer: UIView) {
        let headerViewContainer = UIView()
        containerView.addSubview(headerViewContainer)
        
        headerViewContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(112)
        }
        
        let counterViewContainer = UIView()
        containerView.addSubview(counterViewContainer)
        
        counterViewContainer.snp.makeConstraints { make in
            make.top.equalTo(headerViewContainer.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(233)
        }
        
        let collectionViewContainer = UIView()
        containerView.addSubview(collectionViewContainer)
                
        collectionViewContainer.snp.makeConstraints { make in
            make.top.equalTo(counterViewContainer.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        return (headerViewContainer, counterViewContainer, collectionViewContainer)
    }
    
    private static func addHeaderView(parent containerView: inout UIView) -> UILabel {
        let headerView = UIView()
        containerView.addSubview(headerView)
        
        headerView.backgroundColor = ColorManager.default.getColor(name: .headerWhite)
        headerView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        let label = UILabel()
        headerView.addSubview(label)
        
        label.textColor = ColorManager.default.getColor(name: .iconBlack)
        label.font = .mainFont(ofSize: 16)
        
        label.snp.makeConstraints { make in
            make.top.equalTo(52)
            make.centerX.equalToSuperview()
        }
        
        return label
    }
    
    private static func addScannedWorksCounterView(parent containerView: inout UIView) -> (textLabel: UILabel, numberLabel: UILabel, progressView: UIProgressView) {
        let scannedWorksCounterView = UIView()
        containerView.addSubview(scannedWorksCounterView)
        
        scannedWorksCounterView.snp.makeConstraints{ (make) -> Void in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        // Text Label
        let counterTextLabel = UILabel()
        scannedWorksCounterView.addSubview(counterTextLabel)

        counterTextLabel.textColor = ColorManager.default.getColor(name: .iconBlack)
        counterTextLabel.font = .mainFont(ofSize: 18)
        
        counterTextLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview().inset(36)
            make.centerX.equalToSuperview()
        }
        
        // Number Label
        let counterNumberLabel = UILabel()
        scannedWorksCounterView.addSubview(counterNumberLabel)
        
        counterNumberLabel.textColor = ColorManager.default.getColor(name: .iconBlack)
        counterNumberLabel.font = UIFont(name: "Futura-Bold", size:96)
        
        counterNumberLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // Progress View
        // FIXME: not working
        let counterProgressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: 317, height: 6))
        scannedWorksCounterView.addSubview(counterProgressView)
        
        counterProgressView.layer.masksToBounds = true
        counterProgressView.layer.cornerRadius = 3.0
        
        counterProgressView.snp.makeConstraints{ make -> Void in
            make.bottom.equalToSuperview().inset(36)
            make.centerX.equalToSuperview()
        }
        
        return (counterTextLabel, counterNumberLabel, counterProgressView)
    }
    
    private static func addScannedWorksCollectionView(parent containerView: inout UIView) -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .init(top: padding , left: 0, bottom: 0, right: 0)
        flowLayout.minimumLineSpacing = padding
        
        let scannedWorksCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        scannedWorksCollectionView.backgroundColor = .clear
        containerView.addSubview(scannedWorksCollectionView)
        
        scannedWorksCollectionView.snp.remakeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        return scannedWorksCollectionView
    }
}

extension HistoryViewController {
    private static func addScannedWorksCollectionViewBackgroundViewSubviews(parent containerView: inout UIView) {
        let textLabel = UILabel()
        textLabel.text = "スキャンがありません"
        containerView.addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let emojiLabel = UILabel()
        emojiLabel.text = "😅😅😅"
        containerView.addSubview(emojiLabel)
        
        emojiLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-36)
        }
    }
}
