import UIKit

final class StandartTextField: UITextField {
    private let placeholderView = UIView()
    private var xPad: CGFloat = 0
    private var yPad: CGFloat = 0
    

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        delegate = self
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: xPad, dy: yPad)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: xPad, dy: yPad)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: xPad, dy: yPad)
    }
    
    public func setPadding(xInset: CGFloat, yInset: CGFloat) {
        xPad = xInset
        yPad = yInset
    }
}

// MARK: - Appearance
private extension StandartTextField {
    func configureAppearance() {
        let attributedString = NSAttributedString(string: "Email", attributes: [
            .foregroundColor: UIColor.getAppColor(.accentOp),
            .font: FontLibrary.body
        ])
        attributedPlaceholder = attributedString
        
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .getAppColor(.accentColor)
        font = FontLibrary.body

        layer.borderWidth = 0
        layer.borderColor = UIColor.getAppColor(.accentColor)?.cgColor
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
}

// MARK: - Animation
extension StandartTextField: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 4) { [weak self] in
            guard let self = self else {return}
            self.layer.borderWidth = 3
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) { [weak self] in
            guard let self = self else {return}
            self.layer.borderWidth = 0
        }
    }
}
