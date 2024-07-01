import UIKit

final class SearchController: UISearchController {
    init(searchResultsController: UIViewController? = nil, searchResultUpdater: UISearchResultsUpdating) {
        super.init(searchResultsController: nil)
        self.searchResultsUpdater = searchResultUpdater
        configureAppearance()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(placeholder: String, clearButtonText: String? = nil) {

        if let clearButtonText {
            searchBar.setCancelButton(text: clearButtonText, with: .getAppColor(.accentColor))
        } else {
            searchBar.showsCancelButton = false
        }

        searchBar.setPlaceholderColor(.getAppColor(.accentOp), for: placeholder)
        searchBar.searchTextField.textColor = .getAppColor(.accentColor)
    }
}

// MARK: - Appearance
private extension SearchController {
    func configureAppearance() {
        configureSearchBarAppearance()
    }

    func configureSearchBarAppearance() {
        searchBar.setClearButtonColor(to: .getAppColor(.accentOp))
        searchBar.barTintColor = .getAppColor(.accentColor)
        searchBar.setIconColor(.getAppColor(.accentColor))
        searchBar.setSearchTextFieldTextColor(to: .getAppColor(.accentColor))
    }
}
