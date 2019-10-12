import UIKit
import SafariServices
import SnapKit

class WorkCollectionViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.register(cellType: WorkCollectionViewCell.self)
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            
            // Configure layout
            self.collectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            
            let layout = UICollectionViewFlowLayout()
            // layout.minimumInteritemSpacing = 15
            self.collectionView.collectionViewLayout = layout
        }
    }
    
    lazy var scanProgressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: 317
        , height: 6))

    private var dataStoreSubscriptionToken: SubscriptionToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataStoreSubscriptionToken = DataStore.shared.subscribe { [weak self] in
            self?.collectionView.reloadData()
        }
        scanProgressView.setProgress(0.6, animated: false)
        scanProgressView.layer.masksToBounds = true
        scanProgressView.layer.cornerRadius = 3.0
    }
    
    func setupLayout() {
        scanProgressView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
            make.width.equalTo(317)
            make.height.equalTo(6)
        }
    }
}


// MARK: UICollectionViewDelegateFlowLayout

extension WorkCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    private var cellSize: CGSize {
        let prototypeCell = collectionView.getNib(cellType: WorkCollectionViewCell.self)
        prototypeCell.bounds.size.width = cellWidth
        prototypeCell.contentView.bounds.size.width = cellWidth
        
        let size = prototypeCell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        
        return size
    }
    
    private var cellWidth: CGFloat {
        let availableWidth = collectionView.bounds.inset(by: collectionView.adjustedContentInset).width
        let interColumnSpace = CGFloat(8)
        let numColumns = CGFloat(1)
        let numInterColumnSpaces = numColumns - 1
        
        return ((availableWidth - interColumnSpace * numInterColumnSpaces) / numColumns).rounded(.down)
    }
}

// MARK: UICollectionViewDataSource

extension WorkCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataStore.shared.works.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: WorkCollectionViewCell.self, for: indexPath)
        let work = DataStore.shared.works[indexPath.row]
        cell.configure(WorkCollectionViewCellModel(from: work))
        
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension WorkCollectionViewController: UICollectionViewDelegate {
    
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
