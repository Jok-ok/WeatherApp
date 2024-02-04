protocol CityViewInput: AnyObject {
    func setupInitialState(model: CityPresenterModel)
    func configureCollectionViewData(with suggests: [Suggest])
}
