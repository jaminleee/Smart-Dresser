import UIKit
final class SmartDresserLabel: UILabel {
    init(
        font: UIFont,
        color: UIColor
    ) {
        super.init(frame: .zero)
        self.font = font
        self.textColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
