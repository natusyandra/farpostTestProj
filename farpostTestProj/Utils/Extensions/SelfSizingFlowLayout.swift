/// https://medium.com/@wailord/using-uicollectionview-part-ii-61634553ba38

import UIKit

protocol SelfSizingFlowLayoutDelegate: AnyObject {
    func heightForItem(at indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
}

class SelfSizingFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - General required stuff
    
    public weak var delegate: SelfSizingFlowLayoutDelegate?
    
    override init() {
        super.init()
        self.itemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private helpers
    
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
