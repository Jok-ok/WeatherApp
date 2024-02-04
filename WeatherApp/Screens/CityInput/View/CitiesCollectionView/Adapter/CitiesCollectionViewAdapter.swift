import UIKit

final class CitiesCollectionViewAdapter: NSObject {
    private let output: CitiesCollectionViewAdapterOutput
    private let collectionView: UICollectionView
    private var items: [Suggest]
    
    init(output: CitiesCollectionViewAdapterOutput, collectionView: UICollectionView) {
        self.output = output
        self.collectionView = collectionView
        self.items = []
        super.init()
        self.setupTable()
    }
    
    func configure(with suggests: [Suggest]) {
        self.items = suggests
        collectionView.reloadData()
    }
    
    private func setupTable() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register( CityCollectionViewCell.self, forCellWithReuseIdentifier: String.init(describing: CityCollectionViewCell.self))
    }
}


//MARK: - UICollectionViewDelegate
extension CitiesCollectionViewAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output.didSelectCityView(with: items[indexPath.item].title.text)
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
        
    
        cell.configure(with: items[indexPath.item].title.text, subtitle: items[indexPath.item].subtitle?.text)
        
        return cell
    }
}
