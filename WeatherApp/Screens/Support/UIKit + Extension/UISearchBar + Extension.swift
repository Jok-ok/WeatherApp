import UIKit

extension UISearchBar {
    func setIconColor(_ color: UIColor?) {
        searchTextField.leftView?.tintColor = color
    }
    
    func setClearButtonColor(to color: UIColor?) {
        guard let color else { return }
        let clearImage = UIImage(systemName: "xmark")?.withTintColor(color)
        setImage(clearImage, for: .clear, state: .normal)
    }
    
    func setSearchTextFieldTextColor(to color: UIColor?) {
        guard let searchField = value(forKey: "searchField") as? UISearchTextField else { return }
        searchField.textColor = color
    }
    
    func setCancelButton(text: String, with color: UIColor?) {
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = text
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = color
    }
    
    func setPlaceholderColor(_ color: UIColor?, for placeholder: String? = nil) {
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.foregroundColor] = color

        let attributedString = NSAttributedString(string: placeholder ?? "", attributes: attributes)
        searchTextField.attributedPlaceholder = attributedString
    }
}
