import UIKit.UIColor

extension UIColor {
    static func getAppColor(_ color: AppColor) -> UIColor? {
        UIColor(named: color.rawValue)
    }
}
