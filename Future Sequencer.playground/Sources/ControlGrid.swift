import Foundation
import SpriteKit

struct noteColumn {
    var notes: [Bool]
    
    init(numberOfNotes: Int) {
        notes = Array(repeating: false, count: numberOfNotes)
    }
    
    mutating func noteOn(_ i: Int) {
        if i < notes.count {
            notes[i] = true
        }
    }
    mutating func noteOff(_ i: Int) {
        if i < notes.count {
            notes[i] = false
        }
    }
}

class ControlGrid: SKNode {
    // Members and functions
    var columns: [noteColumn]
    var buttons = [[Button]]()
    let numColumns: Int
    let numRows: Int
    //let margin = 20
    let yOffset = 5
    let sideLength: CGFloat
    
    init(numberOfColumns: Int, numberOfRows: Int, width: CGFloat, height: CGFloat) {
        columns = Array(repeating: noteColumn(numberOfNotes: numberOfRows), count: numberOfColumns)
        
        numColumns = numberOfColumns
        numRows = numberOfRows
        
        sideLength = (height - CGFloat(numberOfRows+1)*CGFloat(yOffset))/CGFloat(numberOfRows)
        
        let xOffset = (width - sideLength*CGFloat(numberOfColumns))/CGFloat(numberOfColumns+1)
        
        super.init()

        for c in 0..<numberOfColumns{
            buttons.append([Button]())
            for r in 0..<numberOfRows {
                let newButton = Button(withSideLength: sideLength, onAction: {
                    self.columns[c].noteOn(r)
                }, offAction: {
                    self.columns[c].noteOff(r)
                })
                newButton.position = CGPoint(x: ((newButton.size.width + xOffset) * (CGFloat(c)) + newButton.size.width/2) + xOffset, y: ((newButton.size.height + CGFloat(yOffset)) * (CGFloat(r)) + newButton.size.height/2) + CGFloat(yOffset))
                newButton.isUserInteractionEnabled = true
                buttons[c].append(newButton)
                addChild(newButton)
            }
        }
    }
    
    func blinkButtons(inColumn column: Int) {
        for button in buttons[column] {
            if button.on {
                let fadePurple = SKAction.colorize(with: .purple, colorBlendFactor: 1, duration: 0.15)
                let fadeBack = SKAction.colorize(with: button.currentColor, colorBlendFactor: 1, duration: 0.15)
                let blink = SKAction.sequence([fadePurple, fadeBack])
                button.run(blink, completion: {button.color = button.currentColor})
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
