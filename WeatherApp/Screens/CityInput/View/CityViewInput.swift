protocol CityViewInput: AnyObject {
    func setupInitialState(model: CityPresenterModel)
    func configureCollectionViewData(with titles: [String], subtitles: [String?])
}
