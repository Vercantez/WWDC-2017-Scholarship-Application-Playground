import Foundation
import UIKit
import SpriteKit

public class SequencerViewController: UIViewController {
    
    public var scene: GridScene?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // 960 by 305
        scene = GridScene(size: CGSize(width: 690, height: 305))
        let skView = SKView(frame: self.view.frame)
        self.view = skView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene!.scaleMode = .aspectFit
        skView.presentScene(scene)
        
    }
    

}
