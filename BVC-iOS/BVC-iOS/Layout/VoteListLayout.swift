
import UIKit

class VoteListLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        
        scrollDirection = UICollectionViewScrollDirection.horizontal
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 각 셀에 대한 레이아웃 정보를 만들기 전에 계산을 수행할 수 있습니다.
    override func prepare() {
        super.prepare()
        
        let PageWidth = (collectionView?.bounds.width)!
        let PageHeight = (collectionView?.bounds.height)! + 170
        itemSize = CGSize(width: PageWidth, height: PageHeight)
        
        minimumInteritemSpacing = 3
        // Cell 전환 속도 Normal or Fast
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        
        //2 CollectionView의 양사이드를 여백을 정의합니다.
        collectionView?.contentInset = UIEdgeInsets(
            top: 0,
            left: collectionView!.bounds.width / 2 - PageWidth / 2,
            bottom: 0,
            right: collectionView!.bounds.width / 2 - PageWidth / 2
        )
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //1
        let array = super.layoutAttributesForElements(in: rect)
        
        //2
        for attributes in array! {
            //3
            let frame = attributes.frame
            //4
            let distance = abs(collectionView!.contentOffset.x + collectionView!.contentInset.left - frame.origin.x)
            print("distance : \(distance)")
            print("collectionView!.contentOffset.x : \(collectionView!.contentOffset.x)")
            print("collectionView!.contentInset.left : \(collectionView!.contentInset.left)")
            print("frame.origin.x : \(frame.origin.x)")
            //5
            let scale = 0.75 * min(max(1 - distance / (collectionView!.bounds.width), 0.9), 1)
            //6
            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        }
        
        return array
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        // Snap cells to centre
        //1
        var newOffset = CGPoint()
        //2
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        //3
        let width = layout.itemSize.width + layout.minimumLineSpacing
        //4
        var offset = proposedContentOffset.x + collectionView!.contentInset.left
        
        //5
        if velocity.x > 0 {
            //ceil returns next biggest number
            offset = width * ceil(offset / width)
        }
        //6
        if velocity.x == 0 {
            //rounds the argument
            offset = width * round(offset / width)
        }
        //7
        if velocity.x < 0 {
            //removes decimal part of argument
            offset = width * floor(offset / width)
        }
        //8
        newOffset.x = offset - collectionView!.contentInset.left
        newOffset.y = proposedContentOffset.y //y will always be the same...
        return newOffset
    }
}

