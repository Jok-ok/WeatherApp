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
        self.setupTable()
    }
    
    func configure(with cities: [String]) {
        self.items = cities
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.invalidateIntrinsicContentSize()
    }
    
    private func setupTable() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register( CityCollectionViewCell.self, forCellWithReuseIdentifier: String.init(describing: CityCollectionViewCell.self))
    }
    func collectionViewSize() -> CGSize {
        collectionView.collectionViewLayout.collectionViewContentSize
    }
}


//MARK: - UICollectionViewDelegate
extension CitiesCollectionViewAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output.didSelectCityView(with: items[indexPath.item])
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}
//MARK: - UICollectionViewDataSource
extension CitiesCollectionViewAdapter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: CityCollectionViewCell.self),
                    for: indexPath) as? CityCollectionViewCell
        else { return UICollectionViewCell() }
        
    
        cell.configure(with: items[indexPath.item])
        
        return cell
    }
}
