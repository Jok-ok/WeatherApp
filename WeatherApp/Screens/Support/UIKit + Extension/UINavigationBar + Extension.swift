import UIKit.UINavigationBar

extension UINavigationBar {
    func setTitleTextColor(_ color: UIColor?) {
        guard let color else { return }
        titleTextAttributes = [.foregroundColor: color]
        largeTitleTextAttributes = [.foregroundColor: color]
    }
}
