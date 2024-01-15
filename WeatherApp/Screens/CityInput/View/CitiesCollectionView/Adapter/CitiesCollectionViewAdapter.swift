import UIKit

final class CitiesCollectionViewAdapter: NSObject {
    private let output: CitiesCollectionViewAdapterOutput
    private let collectionView: UICollectionView
    private var items: [String]
    
    init(output: CitiesCollectionViewAdapterOutput, collectionView: UICollectionView) {
        self.output = output
        self.collectionView = collectionView
        self.items = []
        super.init()
    }
    
    func configure(with cities: [String]) {
        self.items = cities
        collectionView.reloadData()
    }
    
    private func setupTable() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register( CityCollectionViewCell.self, forCellWithReuseIdentifier: String.init(describing: CityCollectionViewCell.self))
    }
}

extension CitiesCollectionViewAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

extension CitiesCollectionViewAdapter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: CityCollectionViewCell.self),
                    for: indexPath) as? CityCollectionViewCell
        else { return UICollectionViewCell ()}
        
        cell.configure(with: items[indexPath.item])
        
        return cell
    }
    
    
}
