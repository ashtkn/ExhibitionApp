import UIKit
import SafariServices

class WorkCollectionViewController: UICollectionViewController {
    
    private let viewModel = WorkCollectionViewModel()
    private var dataStoreSubscriptionToken: SubscriptionToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        collectionView.register(cellType: WorkCollectionViewCell.self)
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 8
        
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

extension WorkCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.works.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: WorkCollectionViewCell.self, for: indexPath)
        let work = viewModel.works[indexPath.row]
        cell.configure(WorkCollectionViewCellModel(from: work))
        
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension WorkCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Show the page of selected work
        let work = viewModel.works[indexPath.row]
        print("Showing page of \(work.title)")
        
        let url = URL(string: "https://www.google.co.jp/")!
        let safariViewController = SFSafariViewController(url: url)
        
        DispatchQueue.main.async {
            self.present(safariViewController, animated: true, completion: nil)
        }
    }
}
