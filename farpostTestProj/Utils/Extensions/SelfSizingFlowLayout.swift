// https://medium.com/@wailord/using-uicollectionview-part-ii-61634553ba38

import UIKit

protocol SelfSizingFlowLayoutDelegate: AnyObject {
    func heightForItem(at indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
}

class SelfSizingFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Configurable/public properties
    public var itemsPerRow = 2 {
        didSet {
            // lazy way out, but outside the scope of this project (for now)
            self.collectionView?.reloadData()
        }
    }
    
    public var distanceBetweenRows: CGFloat = 5 {
        didSet {
            // lazy way out, but outside the scope of this project (for now)
            self.collectionView?.reloadData()
        }
    }
    
    //    fileprivate var calculatedContentWidth: CGFloat {
    //        guard let collectionView = collectionView else {
    //            return 0
    //        }
    //        let insets = collectionView.contentInset
    //        return collectionView.bounds.width - insets.left - insets.right
    //    }
    
    //    override var collectionViewContentSize: CGSize {
    //        return CGSize(width: self.calculatedContentWidth, height: self.calculatedContentHeight)
    //    }
    
    // MARK: - General required stuff
    
    public weak var delegate: SelfSizingFlowLayoutDelegate?
    
    override init() {
        super.init()
        //        self.estimatedItemSize = CGSize(width: 300, height: 100)
        self.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.itemSize = UICollectionViewFlowLayout.automaticSize
        self.minimumInteritemSpacing = 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private helpers
    
    private var calculatedAttributes: [UICollectionViewLayoutAttributes] = []
    private var calculatedContentHeight: CGFloat = 0
    
    private var usableWidthPerItem: CGFloat {
        get {
            // how much width can we use in total right now?
            let contentInsets = self.collectionView!.contentInset.left + self.collectionView!.contentInset.right
            let sectionInsets = self.sectionInset.left + self.sectionInset.right
            
            let usableWidth = self.collectionView!.frame.width - contentInsets - sectionInsets - 2
            let intercardSpacingPerRow = (CGFloat(self.itemsPerRow) - 1) * self.minimumInteritemSpacing
            let usableWidthPerCard = (usableWidth - intercardSpacingPerRow) / CGFloat(self.itemsPerRow)
            return usableWidthPerCard
        }
    }
    
    // used as to avoid calculating heights more than necessary
    private var itemHeights: [CGFloat?] = []
    
    // used for animations
    private var insertingPaths: [IndexPath] = []
    private var deletingPaths: [IndexPath] = []
}

extension SelfSizingFlowLayout {
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        let inserts = updateItems.filter { $0.updateAction == .insert }
        let deletes = updateItems.filter { $0.updateAction == .delete }
        let moves = updateItems.filter { $0.updateAction == .move }
        
        inserts.forEach {
            self.insertingPaths.append($0.indexPathAfterUpdate!)
            self.itemHeights.insert(nil, at: $0.indexPathAfterUpdate!.item)
        }
        
        deletes.forEach {
            self.deletingPaths.append($0.indexPathBeforeUpdate!)
            //            self.itemHeights.remove(at: $0.indexPathBeforeUpdate!.item)
        }
        
        moves.forEach {
            // we're moving index paths, so swap the sizes
            let old = self.itemHeights[$0.indexPathBeforeUpdate!.item]
            self.itemHeights.remove(at: $0.indexPathBeforeUpdate!.item)
            self.itemHeights.insert(old, at: $0.indexPathAfterUpdate!.item)
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        // done animating, so these paths are no longer relevant
        self.insertingPaths = []
        self.deletingPaths = []
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        if self.insertingPaths.contains(itemIndexPath) {
            attr?.alpha = 0.0
            attr?.transform = .init(scaleX: 0.2, y: 0.2)
        }
        return attr
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        if self.deletingPaths.contains(itemIndexPath) {
            attr?.alpha = 0.0
            attr?.transform = attr!.transform.translatedBy(x: 800, y: 0).scaledBy(x: 0.1, y: 0.1)
        }
        return attr
    }
    
    override func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        let attr = super.layoutAttributesForInteractivelyMovingItem(at: indexPath, withTargetPosition: position)
        attr.alpha = 0.2
        return attr
    }
}
