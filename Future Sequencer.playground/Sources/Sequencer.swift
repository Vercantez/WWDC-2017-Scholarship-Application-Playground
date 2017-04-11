import Foundation
import AVFoundation
//import CoreMotion

// Handle audio playback

// Specifically, play batch of notes

// Define playable note values in an array

//

public class Sequencer {
    // Playable notes
    let playableNotes: [UInt8] = [64, 67, 69, 72, 74, 76]
    var engine: AVAudioEngine
    var sampler: AVAudioUnitSampler
    public var distortionEffect: AVAudioUnitDistortion
    public var revEffect: AVAudioUnitReverb
    public var vel: Float = 100.0
    //var effect: AVAudioUnitEQ
    
    // MARK: Setup
    init() {
        engine = AVAudioEngine()
        sampler = AVAudioUnitSampler()
        distortionEffect = AVAudioUnitDistortion()
        distortionEffect.loadFactoryPreset(.drumsLoFi)
        revEffect = AVAudioUnitReverb()
        revEffect.loadFactoryPreset(.cathedral)
        loadSamples()
        engine.attach(sampler)
        engine.attach(distortionEffect)
        engine.attach(revEffect)
        engine.connect(sampler, to: distortionEffect, format: nil)
        engine.connect(distortionEffect, to: revEffect, format: nil)
        engine.connect(revEffect, to: engine.mainMixerNode, format: nil)
        
        //startMotion()

        setSessionPlayback()
        startEngine()
        
        
        print(self.distortionEffect.wetDryMix)
        
    }
    
    func loadSamples() {
        if let urls = Bundle.main.url(forResource: "guitar", withExtension: "wav") {
            do {
                try sampler.loadAudioFiles(at: [urls])
            } catch {
                print("Error: Failed to load files")
            }
        }
    }
    
    func setSessionPlayback() {
        let session = AVAudioSession.sharedInstance()
        do {
            try
                session.setCategory(AVAudioSessionCategoryPlayback, with:
                    AVAudioSessionCategoryOptions.mixWithOthers)
        } catch {
            print("Error: Failed to set session category")
            return
        }
        
        do {
            try session.setActive(true)
        } catch {
            print("Error: Failed to activate session")
            return
        }
    }
    
    func startEngine() {
        if engine.isRunning {
            return
        }
        
        do {
            try engine.start()
        } catch {
            print("Error: Failed to start audio playback engine")
        }
    }
    /* Not working for some reason. Moved to main playground file
    func startMotion() {
        let cmManager = CMMotionManager()
        
        cmManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: OperationQueue()) { (data, error) in
            guard let data = data else {
                return
            }
            self.vel =  ((Float(data.gravity.x) + 1.0)/2) * 100.0
            self.distortionEffect.preGain = ((Float(data.gravity.y) + 1.0)/2) * 20
            print(self.distortionEffect.preGain)
        }
        
    }
 */
    
    // MARK: Interface
    
    func playNotes(noteIndices: [Bool]) {
        for (i, noteOn) in noteIndices.enumerated() {
            if noteOn {
                sampler.startNote(playableNotes[i], withVelocity: UInt8(vel), onChannel: 0)
            }
        }
    }
    
    func stopNotes(noteIndices: [Bool]) {
        for (i, noteOn) in noteIndices.enumerated() {
            if noteOn {
                sampler.stopNote(playableNotes[i], onChannel: 0)
            }
        }
    }
}
