import UIKit

final class StandartButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureAppearance()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Appearance

private extension StandartButton {
    func configureAppearance() {

        addTarget(self, action: #selector(onTouchDownAnimation), for: .touchDown)
        addTarget(self, action: #selector(onTouchUpAnimation), for: .touchUpInside)
        addTarget(self, action: #selector(onTouchUpAnimation), for: .touchUpOutside)
        translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 15, *) {
            var conf = UIButton.Configuration.filled()

            conf.cornerStyle = .medium
            conf.baseForegroundColor = .buttonFontColor
            conf.baseBackgroundColor = .accentColor
            
            conf.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
            
            conf.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outcoming = incoming
                outcoming.font = UIFont.boldSystemFont(ofSize: 18)
                return outcoming
            }
            
            configuration =   conf
        }
        else {
            backgroundColor = .accentColor
            tintColor = .buttonFontColor
            layer.cornerRadius = 8
            layer.masksToBounds = true
        
            contentEdgeInsets = .init(top: 10, left: 20, bottom: 10, right: 20)
            titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        }

    }
    
    @objc func onTouchDownAnimation() {
        guard state != .disabled else { return }
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .allowUserInteraction) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    @objc func onTouchUpAnimation() {
        guard state != .disabled else { return }
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .allowUserInteraction) {
            self.transform = CGAffineTransform.identity
        }
    }
}

