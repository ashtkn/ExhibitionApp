import UIKit
import SafariServices

class WorkCollectionViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
        }
    }
    
    private var dataStoreSubscriptionToken: SubscriptionToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        collectionView.register(cellType: WorkCollectionViewCell.self)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 15
        
        dataStoreSubscriptionToken = DataStore.shared.subscribe { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension WorkCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    // FIXME: This code does not seem to work
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let prototypeCell = collectionView.getNib(cellType: WorkCollectionViewCell.self)
        prototypeCell.bounds.size.width = cellWidth
        prototypeCell.contentView.bounds.size.width = cellWidth
        
        let size = prototypeCell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        
        return size
    }
    
    private var cellWidth: CGFloat {
        let availableWidth = collectionView.bounds.inset(by: collectionView.adjustedContentInset).width
        let interColumnSpace = CGFloat(8)
        let numColumns = CGFloat(2)
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
