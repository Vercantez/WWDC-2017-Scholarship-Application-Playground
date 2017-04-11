import Foundation
import SpriteKit

class Button: SKSpriteNode {
    var on = false
    var onActionHandler: ()->Void
    var offActionHandler: ()->Void
    var currentColor: UIColor = .gray {
        didSet {
            self.color = currentColor
        }
    }
    
    init(withSideLength length: CGFloat, onAction:@escaping ()->Void, offAction:@escaping ()->Void) {
        self.onActionHandler = onAction
        self.offActionHandler = offAction
        super.init(texture: nil, color: .gray, size: CGSize(width: length, height: length))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        on = !on
        if on {
            currentColor = .yellow
            onActionHandler()
        }
        else {
            currentColor = .gray
            offActionHandler()
        }
    }
}
