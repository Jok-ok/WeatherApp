import Foundation

final class HidebleSectionHeaderModel {
    let headerText: String
    let onEyeTappedAction: (() -> Void)

    init(headerText: String, onEyeTappedAction: @escaping () -> Void) {
        self.headerText = headerText
        self.onEyeTappedAction = onEyeTappedAction
    }
}
