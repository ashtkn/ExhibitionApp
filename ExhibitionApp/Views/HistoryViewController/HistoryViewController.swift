import UIKit
import SafariServices
import SnapKit

class HistoryViewController: UIViewController {
    
    private let padding: CGFloat = 15
    
    lazy private var header = UIView()
    lazy private var headerTitle = UILabel()
    lazy private var workAcheivementView = UIView()
    lazy private var workAcheivementLabel = UILabel()
    lazy private var workAcheivementNumberLabel = UILabel()
    lazy private var workAcheivementBarView = UIProgressView(frame: CGRect(x: 0, y: 0, width: 317, height: 6))
    lazy private var workCollectionViewCellLayout = UICollectionViewFlowLayout()
    lazy private var workCollectionView = UICollectionView(frame: .zero, collectionViewLayout: workCollectionViewCellLayout)

    private var viewModel = HistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        setupHeaderView()
        setupWorkAchievementView()
        setupWorkCollectionView()
    }
    
    private func setupHeaderView() {
        self.view.addSubview(header)
        header.addSubview(headerTitle)
        header.backgroundColor = .black
        headerTitle.text = viewModel.headerTitleText
        headerTitle.textColor = .white
        headerTitle.font = .mainFont(ofSize: 16)
    }
    
    private func setupWorkAchievementView() {
        self.view.addSubview(workAcheivementView)
        workAcheivementView.addSubview(workAcheivementLabel)
        workAcheivementView.addSubview(workAcheivementNumberLabel)
        workAcheivementView.addSubview(workAcheivementBarView)
        workAcheivementLabel.text = viewModel.workAcheivementLabelText
        workAcheivementLabel.textColor = .white
        workAcheivementLabel.font = .mainFont(ofSize: 18)
        workAcheivementNumberLabel.text = "\(viewModel.unlockedWorksNumber)"
        workAcheivementNumberLabel.textColor = .white
        workAcheivementNumberLabel.font = UIFont(name: "Futura-Bold", size:96)
        workAcheivementBarView.setProgress(0.6, animated: false)
        workAcheivementBarView.layer.masksToBounds = true
        workAcheivementBarView.layer.cornerRadius = 3.0
    }
    
    private func setupWorkCollectionView() {
        self.view.addSubview(workCollectionView)
        workCollectionViewCellLayout.sectionInset = .init(top: padding , left: 0, bottom: 0, right: 0)
        workCollectionViewCellLayout.minimumLineSpacing = padding
        workCollectionView.dataSource = self
        workCollectionView.delegate = self
        workCollectionView.register(cellType: WorkCollectionViewCell.self)
        workCollectionView.register(WorkCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WorkCollectionHeaderView.className)
        
        // Subscribe DataStore
        viewModel.dataStoreSubscriptionToken = DataStore.shared.subscribe { [weak self] in
            self?.workCollectionView.reloadData()
        }
    }
    
    // FIXME: Some constraints are absolute, especially height. Desirable to arrange into aspect ratio.
    
    private func setupLayout() {
        header.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(112)
        }
        
        headerTitle.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(52)
            make.centerX.equalToSuperview()
        }
        
        workAcheivementView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(header.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(233)
        }
        
        workAcheivementLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview().inset(36)
            make.centerX.equalToSuperview()
        }
        
        workAcheivementNumberLabel.snp.makeConstraints{ (make) -> Void in
            make.center.equalToSuperview()
        }
        
        workAcheivementBarView.snp.makeConstraints{ (make) -> Void in
            make.bottom.equalToSuperview().inset(36)
            make.centerX.equalToSuperview()
        }
        
        workCollectionView.snp.remakeConstraints{ (make) -> Void in
            make.top.equalTo(workAcheivementView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
}


// MARK: UICollectionViewDelegateFlowLayout

extension HistoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    private var cellSize: CGSize {
        let prototypeCell = workCollectionView.getNib(cellType: WorkCollectionViewCell.self)
        prototypeCell.bounds.size.width = cellWidth
        prototypeCell.contentView.bounds.size.width = cellWidth
        
        let size = prototypeCell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        
        return size
    }
    
    private var cellWidth: CGFloat {
        let availableWidth = workCollectionView.bounds.inset(by: workCollectionView.adjustedContentInset).width
        let interColumnSpace = padding
        let numColumns = CGFloat(1)
        let numInterColumnSpaces = numColumns - 1
        
        return ((availableWidth - interColumnSpace * numInterColumnSpaces) / numColumns).rounded(.down) - padding*2
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
        return DataStore.shared.works.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! WorkCollectionViewCell
        let cell = collectionView.dequeueReusableCell(with: WorkCollectionViewCell.self, for: indexPath)

        let work = DataStore.shared.works[indexPath.row]
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
        let work = DataStore.shared.works[indexPath.row]
        if work.isLocked { return }
        
        let url = URL(string: work.url)!
        let safariViewController = SFSafariViewController(url: url)
        
        DispatchQueue.main.async { [unowned self] in
            self.present(safariViewController, animated: true, completion: nil)
        }
    }
}
