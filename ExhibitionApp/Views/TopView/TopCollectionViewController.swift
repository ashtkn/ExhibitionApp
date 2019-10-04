import UIKit

class TopCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var scanButton: UIButton!
    private var dataStoreSubscriptionToken: SubscriptionToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        collectionView.register(cellType: TopCollectionViewCell.self)
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 8
        
        dataStoreSubscriptionToken = DataStore.shared.subscribe { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    @IBAction func didScanButtonTapped(_ sender: Any) {
        let cameraViewController = CameraViewController.loadViewControllerFromStoryboard()
        let arObjects = DataStore.shared.arObjects
        let arImages = DataStore.shared.arImages
        let viewModel = CameraViewModel(objects: arObjects, images: arImages)
        cameraViewController.configure(viewModel)
        DispatchQueue.main.async {
            self.present(cameraViewController, animated: true, completion: nil)
        }
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout

extension TopCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let prototypeCell = collectionView.getNib(cellType: TopCollectionViewCell.self)
        prototypeCell.bounds.size.width = cellWidth
        prototypeCell.contentView.bounds.size.width = cellWidth
        
        let size = prototypeCell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)

        return size
    }
    
    private var cellWidth: CGFloat {
        let availableWidth = collectionView.bounds.inset(by: collectionView.adjustedContentInset).width
        let interColumnSpace = CGFloat(8)
        let numColumns = CGFloat(3)
        let numInterColumnSpaces = numColumns - 1
        
        return ((availableWidth - interColumnSpace * numInterColumnSpaces) / numColumns).rounded(.down)
    }
}

// MARK: UICollectionViewDataSource

extension TopCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataStore.shared.works.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: TopCollectionViewCell.self, for: indexPath)
        let work = DataStore.shared.works[indexPath.row]
        cell.configure(TopCollectionViewCellModel(from: work))
        
        return cell
    }
    
}

// MARK: UICollectionViewDelegate

extension TopCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let work = DataStore.shared.works[indexPath.row]
        if work.isLocked { return }
        
        let detailViewController = DetailViewController.loadViewControllerFromStoryboard()
        detailViewController.configure(DetailViewModel(from: work))
        
        DispatchQueue.main.async {
            self.present(detailViewController, animated: true, completion: nil)
        }
    }
}
