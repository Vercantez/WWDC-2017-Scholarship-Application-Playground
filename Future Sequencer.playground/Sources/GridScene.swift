import Foundation
import SpriteKit


public class GridScene: SKScene {
    
    public var sequencer:Sequencer?
    var grid: ControlGrid?
    let queue = DispatchQueue(label: "audioQueue", qos: .userInitiated)
    
    let numColumns = 8
    
    var currentColumn: Int = 0 {
        didSet {
            if currentColumn >= numColumns {
                currentColumn = 0
            }
        }
    }
    
    public var delta: Double = 0.1
    
    override public func didMove(to view: SKView) {
        addSequencer()
        addControlGrid()
        
        playAndHighlight()
        
    }
    
    func addSequencer() {
        sequencer = Sequencer()
    }
    
    func addControlGrid() {
        guard let sequencer = sequencer else {
            print("Error: Failed to unwrap sequencer")
            return
        }
        
        
        grid = ControlGrid(numberOfColumns: numColumns, numberOfRows: sequencer.playableNotes.count, width: self.size.width, height: self.size.height)
        
        guard let grid = grid else {
            print("Error: Failed to unwrap grid")
            return
        }
        addChild(grid)
    }
    
    func playAndHighlight() {
        guard let grid = grid else {
            print("Error: Failed to unwrap grid")
            return
        }
        grid.blinkButtons(inColumn: currentColumn)
        queue.asyncAfter(deadline: DispatchTime.now() + delta) {
            self.stopNoteColumn()
            self.playNoteColumn()
            self.playAndHighlight()
        }
    }
    
    func playNoteColumn() {
        guard let sequencer = sequencer else {
            print("Error: Failed to unwrap sequencer")
            return
        }
        guard let grid = grid else {
            print("Error: Failed to unwrap grid")
            return
        }
        sequencer.playNotes(noteIndices: grid.columns[currentColumn].notes)
        currentColumn += 1
    }
    func stopNoteColumn() {
        guard let sequencer = sequencer else {
            print("Error: Failed to unwrap sequencer")
            return
        }
        guard let grid = grid else {
            print("Error: Failed to unwrap grid")
            return
        }
        sequencer.stopNotes(noteIndices: grid.columns[currentColumn].notes)
    }
    
}
