
/*: 
 **Future Sequencer:** Tap the buttons and tilt iPad!

 * Try changing the frequency! (in Hertz, from 3.0 to 50.0)
 * Also try changing the effect strength! (from 0.0 to 100.0)
 
 ***Lock orientation in Portrait Mode for best experience* m**
 
*/
//#-hidden-code
import PlaygroundSupport
import CoreMotion

let viewController = SequencerViewController()
PlaygroundPage.current.liveView = viewController

var frequency: Double = 10.0 {
didSet {
    if frequency > 50.0 {
        frequency = 50.0
    }
    else if frequency < 3.0 {
        frequency = 3.0
    }
    viewController.scene!.delta = 1/frequency
}
}
var effectStrength: Float = 100.0 {
didSet {
    if effectStrength > 100.0 {
        effectStrength = 100.0
    }
    else if effectStrength < 0.0 {
        effectStrength = 0.0
    }
}
}

let cmManager = CMMotionManager()

cmManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: OperationQueue()) { (data, error) in
    guard let data = data else {
        return
    }
    viewController.scene!.sequencer!.distortionEffect.wetDryMix = (abs(Float(data.gravity.x))) * effectStrength
    viewController.scene!.sequencer!.revEffect.wetDryMix = (abs(Float(data.gravity.y))) * effectStrength

    
}
//#-end-hidden-code

//#-editable-code
frequency = 10.0

effectStrength = 100.0
//#-end-editable-code
