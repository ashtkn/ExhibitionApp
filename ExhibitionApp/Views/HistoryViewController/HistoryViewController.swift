import UIKit
import SafariServices
import SnapKit

final class HistoryViewController: UIViewController {
    
    private let padding: CGFloat = 15
    
    private weak var headerTitleLabel: UILabel!
    private weak var scannedWorksCounterTextLabel: UILabel!
    private weak var scannedWorksCounterNumberLabel: UILabel!
    private weak var scannedWorksCounterProgressView: UIProgressView!
    private weak var scannedWorksCollectionView: UICollectionView!

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
        var containerView = self.createContainerView()
        var (headerViewContainer, counterViewContainer, collectionViewContainer)
            = HistoryViewControllerViewsBuilder.createSubContainerViews(parent: &containerView)
        
        // HeaderViewContainer
        self.headerTitleLabel
            = HistoryViewControllerViewsBuilder.buildHeaderView(parent: &headerViewContainer)
        
        // CounterViewContainer
        let counterViewContainerSubviews
            = HistoryViewControllerViewsBuilder.buildScannedWorksCounterView(parent: &counterViewContainer)
        self.scannedWorksCounterTextLabel = counterViewContainerSubviews.textLabel
        self.scannedWorksCounterNumberLabel = counterViewContainerSubviews.numberLabel
        self.scannedWorksCounterProgressView = counterViewContainerSubviews.progressView

        // CollectionViewContainer
        self.scannedWorksCollectionView
            = HistoryViewControllerViewsBuilder.buildScannedWorksCollectionView(parent: &collectionViewContainer, padding: padding)
        self.scannedWorksCollectionView.delegate = self
        self.scannedWorksCollectionView.dataSource = self
        self.scannedWorksCollectionView.register(cellType: WorkCollectionViewCell.self)
        self.scannedWorksCollectionView.register(WorkCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WorkCollectionHeaderView.className)
    }
    
    private func createContainerView() -> UIView {
        let containerView = UIView()
        self.view.addSubview(containerView)
        
        let safeArea = self.view.safeArea
        containerView.backgroundColor = AssetsManager.default.getColor(of: .background)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(safeArea.top)
            make.bottom.equalTo(safeArea.bottom)
            make.leading.equalTo(safeArea.leading)
            make.trailing.equalTo(safeArea.trailing)
        }
        
        return containerView
    }
    
    private func updateSubviews() {
        // HeaderTitleLabel
        self.headerTitleLabel.text = viewModel.headerTitleLabelText
        // ScannedWorksCounterTextLabel
        self.scannedWorksCounterTextLabel.text = viewModel.scannedWorksCounterTextLabelText
        // ScannedWorksCounterNumberLabel
        self.scannedWorksCounterNumberLabel.text = viewModel.scannedWorksCounterNumberLabelText
        // ScannedWorksCounterProgressView
        let value = viewModel.scannedWorksCounterProgressViewValue
        self.scannedWorksCounterProgressView.setProgress(value, animated: false)
        
        // ScannedWorksCollectionView
        self.scannedWorksCollectionView.reloadData()
        // BackgroundView of ScannedWorksCollectionView
        var backgroundViewContainer = UIView()
        self.scannedWorksCollectionView.backgroundView = backgroundViewContainer
        if viewModel.unlockedWorks.count == 0 {
            HistoryViewControllerViewsBuilder.buildScannedWorksCollectionViewBackgroundView(parent: &backgroundViewContainer)
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
