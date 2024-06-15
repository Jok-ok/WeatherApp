import UIKit

final class CitiesCollectionViewAdapter: NSObject {
    private let output: CitiesCollectionViewAdapterOutput
    private let collectionView: UICollectionView
    private var titles = [String]()
    private var subtitles = [String?]()
    
    init(output: CitiesCollectionViewAdapterOutput, collectionView: UICollectionView) {
        self.output = output
        self.collectionView = collectionView
        super.init()
        self.setupTable()
    }
    
    func configure(with titles: [String], subtitles: [String?]) {
        self.titles = titles
        self.subtitles = subtitles
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
        output.didSelectCityView(with: titles[indexPath.item], subtitle: subtitles[indexPath.item])
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}
//MARK: - UICollectionViewDataSource
extension CitiesCollectionViewAdapter: UICollectionViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        output.collectionViewDidScroll()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: CityCollectionViewCell.self),
                    for: indexPath) as? CityCollectionViewCell
        else { return UICollectionViewCell() }
        
    
        cell.configure(with: titles[indexPath.item], subtitle: subtitles[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CityCollectionViewCell else { return }
        cell.onTouchDownAnimation()

    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CityCollectionViewCell else { return }
        
        cell.onTouchUpAnimation()
        
        
    }
}
