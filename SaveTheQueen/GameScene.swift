//
//  GameScene.swift
//  POC
//
//  Created by Jorge Jordán on 01/05/2019.
//  Copyright © 2019 Jorge Jordán. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var cellSprite : SKSpriteNode!
    private var bee : SKSpriteNode!
    private var cell : Cell!
    private var CELL_WIDTH : CGFloat = 0.0
    private var CELL_HEIGHT : CGFloat = 0.0
    private var IS_WIDTH_OFFSET : Bool = false
    private var arrayCells : [String]!
    private var numCols : Int = 0
    private var numRows : Int = 0
    
    private var currentCol : Int = 0
    private var currentRow : Int = 0
    
    private var currentCell : Cell!
    private var previousCell : Cell!
    private var cellN : Cell!
    private var cellNE : Cell!
    private var cellSE : Cell!
    private var cellS : Cell!
    private var cellSW : Cell!
    private var cellNW : Cell!
    private var auxCell : Cell!
    
    private var matrix : [[Cell]]!
    
    private var touchedCell : Cell!
    private var previousTouchedCell : Cell!
    private var canMove : Bool = false
    
    //private var currentCell : SKSpriteNode!
    //private var previousCell : SKSpriteNode!
    
    override func didMove(to view: SKView) {
        readLevelInfo()
        //placeBee()
        //drawCellMap()
        backgroundColor = SKColor.white
        /*
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        */
    }
    
    func readLevelInfo() {
        var levelDictionary: NSDictionary!
        var cellInfo: NSDictionary!
        var positionX = 0.0
        var positionY = 0.0
        
        arrayCells = [String]()
        matrix = [[Cell]]()
        
        if let levelInfoPath = Bundle.main.path(forResource: "Level", ofType: "plist") {
            //print("READING PLIST")
            //print("Path \(path.description)")
            levelDictionary = NSDictionary(contentsOfFile: levelInfoPath.description)
        }
        
        numCols = levelDictionary!.value(forKey: "numCols") as! Int
        numRows = levelDictionary!.value(forKey: "numRows") as! Int
        
        currentCol = levelDictionary!.value(forKey: "initCol") as! Int
        currentRow = levelDictionary!.value(forKey: "initRow") as! Int
        
        //matrix = Array<Cell>(repeating: Array<Cell>(repeating: Cell(), count: numCols), count: numRows)
        
        print("NumCols \(numCols) | NumRows \(numRows)")
        
        for j in 0...numCols-1 {
            //print("j = \(j)")
            for i in 0...numRows-1 {
                //print("i = \(i)")
                //print("cell\(j)\(i)")
                cellInfo = (levelDictionary!.value(forKey: "cell\(j)\(i)") as! NSDictionary)   //"cell\(x)\(y)"
                
                cell = Cell(col: cellInfo.value(forKey: "col") as! Int, row: cellInfo.value(forKey: "row") as! Int, image: cellInfo.value(forKey: "image") as! String, neighbours: cellInfo.value(forKey: "neighbours") as! [String])
                cell.position = CGPoint(x:positionX, y:positionY)
                //cell.name = "cell\(j)\(i)"
                self.addChild(cell)
               // print("added cell with name \(cell.name!)")
                // TODO add cell to array of cells
                //matrix[j][i] = cell
                
                //print("CELL WIDTH \(cell.sprite.size.width) | CELL HEIGHT \(cell.sprite.size.height)");
                positionY += Double(cell.sprite.size.height)
            }
            if j % 2 == 0 {
                //positionY = 0.0
                positionY = Double(cell.sprite.size.height) / 2
            } else {
                positionY = 0.0
            }
            positionX += Double(cell.sprite.size.width) * 3 / 4
        }
        
        CELL_WIDTH = cell.sprite.size.width;
        CELL_HEIGHT = cell.sprite.size.height;
        
        printCurrentCell(withCol: currentCol, row: currentRow)
        //placeBee()
    }
    
    func placeBee() {
        if bee == nil {
            bee = SKSpriteNode(imageNamed: "cartoon_bee50.jpg")
        }
        //let cellName = "currentcell\(currentCol)\(currentRow)"
       // auxCell = self.childNode(withName:cellName) as? Cell
        
        bee.position = CGPoint(x:auxCell.position.x, y:auxCell.position.y)
        bee.isUserInteractionEnabled = false
        bee.name = "bee"
        self.addChild(bee)
        
        //printCurrentCell(withCol: currentCol, row: currentRow)
        //currentCell = auxCell
        //previousCell = auxCell
        //printNeighboursWithColRow()
        
        //print("VIEW WIDTH \(view!.bounds.size.width) | VIEW HEIGHT \(view!.bounds.size.height)");
    }
    
    func printCurrentCell(withCol: Int, row: Int) {
        let cellName = "currentcell\(currentCol)\(currentRow)"
        auxCell = self.childNode(withName:cellName) as? Cell
        placeBee()
        
        currentCell = auxCell
        previousCell = auxCell
        printNeighboursWithColRow()
    }
    
    func drawCellMap() {
        var positionX = 0.0
        var positionY = 0.0
        
        for j in 0...7 {
            for _ in 0...8 {
                cellSprite = SKSpriteNode(imageNamed: "hexagon_orange25")
                cellSprite.position = CGPoint(x:positionX, y:positionY)
                self.addChild(cellSprite)
            
                positionY += Double(cellSprite.size.height)
            }
            if j % 2 == 0 {
                //positionY = 0.0
                positionY = Double(cellSprite.size.height) / 2
            } else {
                positionY = 0.0
            }
            positionX += Double(cellSprite.size.width) * 3 / 4
        }
        
        CELL_WIDTH = cellSprite.size.width;
        CELL_HEIGHT = cellSprite.size.height;
        
        print("CELL WIDTH \(CELL_WIDTH) | CELL HEIGHT \(CELL_HEIGHT)");
    }
    
    func giveMeCellPositionX(atPoint pos : CGPoint) -> Int {
        var posX : Int
        print("touchX = \(pos.x)")
        posX = Int(round(pos.x / CELL_WIDTH))
        print("posX = \(posX)")
        return posX
    }
    
    func giveMeCellPositionY(atPoint pos : CGPoint) -> Int {
        var posY : Int
        posY = Int(round(pos.y / CELL_HEIGHT))
        print("posY = \(posY)")
        return posY
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let roof = self.spinnyNode?.copy() as! SKShapeNode? {
            roof.position = pos
            roof.strokeColor = SKColor.green
            self.addChild(roof)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let roof = self.spinnyNode?.copy() as! SKShapeNode? {
            roof.position = pos
            roof.strokeColor = SKColor.red
            self.addChild(roof)
        }
    }
    
    func hideNeighbours() {
        // N
        hideCellWithColRow(col: previousCell.cellCol, row: previousCell.cellRow+1)
        
        // S
        hideCellWithColRow(col: previousCell.cellCol, row: previousCell.cellRow-1)
        
        
        
        if previousCell.cellCol % 2 == 0 {
            //NE
                hideCellWithColRow(col: previousCell.cellCol+1, row: previousCell.cellRow)
            
            //SE
            hideCellWithColRow(col: previousCell.cellCol+1, row: previousCell.cellRow-1)
            
            
            //NW
            hideCellWithColRow(col: previousCell.cellCol-1, row: previousCell.cellRow)
            
            //SW
            hideCellWithColRow(col: previousCell.cellCol-1, row: previousCell.cellRow-1)
           
        } else {
            
            //NE
            hideCellWithColRow(col: previousCell.cellCol+1, row: previousCell.cellRow+1)
            
            //SE
            hideCellWithColRow(col: previousCell.cellCol+1, row: previousCell.cellRow)
            
                
            //NW
            hideCellWithColRow(col: previousCell.cellCol-1, row: previousCell.cellRow+1)
            
            
            //SW
                hideCellWithColRow(col: previousCell.cellCol-1, row: previousCell.cellRow)
           
            
        }
        
    }
    
    func printNeighboursWithColRow() {
        //hideNeighbours()
        
        if currentCell.cellNeighbours.contains("N") {
            print("N")
            printCellWithColRow(col: currentCell.cellCol, row: currentCell.cellRow+1, isAvailable: true)
        } else {
            print("--- N")
            printCellWithColRow(col: currentCell.cellCol, row: currentCell.cellRow+1, isAvailable: false)
        }
        
        if currentCell.cellNeighbours.contains("S") {
            print("S")
            printCellWithColRow(col: currentCell.cellCol, row: currentCell.cellRow-1, isAvailable: true)
        } else {
            print("--- S")
            printCellWithColRow(col: currentCell.cellCol, row: currentCell.cellRow-1, isAvailable: false)
        }

        
        if currentCell.cellCol % 2 == 0 {
            if currentCell.cellNeighbours.contains("NE") {
                print("NE")
                printCellWithColRow(col: currentCell.cellCol+1, row: currentCell.cellRow, isAvailable: true)
            } else {
                print("--- NE")
                printCellWithColRow(col: currentCell.cellCol+1, row: currentCell.cellRow, isAvailable: false)
            }
            
            if currentCell.cellNeighbours.contains("SE") {
                print("SE")
                printCellWithColRow(col: currentCell.cellCol+1, row: currentCell.cellRow-1, isAvailable: true)
            } else {
                print("--- SE")
                printCellWithColRow(col: currentCell.cellCol+1, row: currentCell.cellRow-1, isAvailable: false)
            }
            
            
            if currentCell.cellNeighbours.contains("NW") {
                print("NW")
                printCellWithColRow(col: currentCell.cellCol-1, row: currentCell.cellRow, isAvailable: true)
            } else {
                print("--- NW")
                printCellWithColRow(col: currentCell.cellCol-1, row: currentCell.cellRow, isAvailable: false)
            }
            
            
            if currentCell.cellNeighbours.contains("SW") {
                print("SW")
                printCellWithColRow(col: currentCell.cellCol-1, row: currentCell.cellRow-1, isAvailable: true)
            } else {
                print("--- SW")
                printCellWithColRow(col: currentCell.cellCol-1, row: currentCell.cellRow-1, isAvailable: false)
            }
        } else {
            
            if currentCell.cellNeighbours.contains("NE") {
                print("NE")
                printCellWithColRow(col: currentCell.cellCol+1, row: currentCell.cellRow+1, isAvailable: true)
            } else {
                print("--- NE")
                printCellWithColRow(col: currentCell.cellCol+1, row: currentCell.cellRow+1, isAvailable: false)
            }
            
            if currentCell.cellNeighbours.contains("SE") {
                print("SE")
                printCellWithColRow(col: currentCell.cellCol+1, row: currentCell.cellRow, isAvailable: true)
            } else {
                print("--- SE")
                printCellWithColRow(col: currentCell.cellCol+1, row: currentCell.cellRow, isAvailable: false)
            }
            
            
            if currentCell.cellNeighbours.contains("NW") {
                print("NW")
                printCellWithColRow(col: currentCell.cellCol-1, row: currentCell.cellRow+1, isAvailable: true)
            } else {
                print("--- NW")
                printCellWithColRow(col: currentCell.cellCol-1, row: currentCell.cellRow+1, isAvailable: false)
            }
            
            
            if currentCell.cellNeighbours.contains("SW") {
                print("SW")
                printCellWithColRow(col: currentCell.cellCol-1, row: currentCell.cellRow, isAvailable: true)
            } else {
                print("--- SW")
                printCellWithColRow(col: currentCell.cellCol-1, row: currentCell.cellRow, isAvailable: false)
            }
            
        }
        
    }
    
    /*func printNeighbours() {
        hideNeighbours()
        /*if currentCell == nil {
            print("currentCell is NIL")
        }*/
        if currentCell.cellNeighbours.contains("N") {
            print("N")
            printCellN(posX: currentCell.position.x, posY: currentCell.position.y, isAvailable: true)
        } else {
            print("--- N")
            printCellN(posX: currentCell.position.x, posY: currentCell.position.y, isAvailable: false)
        }
        
        if currentCell.cellNeighbours.contains("NE") {
            print("NE")
            printCellNE(posX: currentCell.position.x, posY: currentCell.position.y, isAvailable: true)
        } else {
            print("--- NE")
            printCellNE(posX: currentCell.position.x, posY: currentCell.position.y, isAvailable: false)
        }
        
        if currentCell.cellNeighbours.contains("SE") {
            print("SE")
            printCellSE(posX: currentCell.position.x, posY: currentCell.position.y, isAvailable: true)
        } else {
            print("--- SE")
            printCellSE(posX: currentCell.position.x, posY: currentCell.position.y, isAvailable: false)
        }
        
        if currentCell.cellNeighbours.contains("S") {
            print("S")
            printCellS(posX: currentCell.position.x, posY: currentCell.position.y, isAvailable: true)
        } else {
            print("--- S")
            printCellS(posX: currentCell.position.x, posY: currentCell.position.y, isAvailable: false)
        }
        
        if currentCell.cellNeighbours.contains("SW") {
            print("SW")
            printCellSW(posX: currentCell.position.x, posY: currentCell.position.y, isAvailable: true)
        } else {
            print("--- SW")
            printCellSW(posX: currentCell.position.x, posY: currentCell.position.y, isAvailable: false)
        }
        
        if currentCell.cellNeighbours.contains("NW") {
            print("NW")
            printCellNW(posX: currentCell.position.x, posY: currentCell.position.y, isAvailable: true)
        } else {
            print("--- NW")
            printCellNW(posX: currentCell.position.x, posY: currentCell.position.y, isAvailable: false)
        }
    }*/
    
    
    
    func printCellWithColRow(col : Int, row : Int, isAvailable : Bool) {
        if (col >= 0 && row >= 0) {
            let cellName : String = "currentcell\(col)\(row)"
            print("cell \(cellName)")
            if (isAvailable) {
                auxCell = self.childNode(withName:cellName) as? Cell
                auxCell!.roof.isHidden = false
                auxCell!.roof.texture = SKTexture(imageNamed: "hexagon_green")
                auxCell!.roof.zPosition = 9
            } else {
                auxCell = self.childNode(withName:cellName) as? Cell
                auxCell!.roof.isHidden = false
                auxCell!.roof.texture = SKTexture(imageNamed: "hexagon_red")
                auxCell!.roof.zPosition = 8
            }
        //cellN.position = CGPoint(x:posX, y:posY + CELL_HEIGHT)
//          
        //self.addChild(cellN)
            
        }
    }
    
    func hideCellWithColRow(col : Int, row : Int) {
        if (col >= 0 && row >= 0) {
            let cellName : String = "currentcell\(col)\(row)"
            print("hidding cell \(cellName)")
            auxCell = self.childNode(withName:cellName) as? Cell
            //auxCell!.roof.texture = SKTexture(imageNamed: "hexagon_blue")
            auxCell!.roof.isHidden = true
        }
    }
    
    
    
    
    /*func printCellN(posX : CGFloat, posY : CGFloat, isAvailable : Bool) {
        if (isAvailable) {
            cellN = SKSpriteNode(imageNamed: "hexagon_green")
        }else {
            cellN = SKSpriteNode(imageNamed: "hexagon_red")
        }
        cellN.position = CGPoint(x:posX, y:posY + CELL_HEIGHT)
        
        self.addChild(cellN)
    }
    
    func printCellNE(posX : CGFloat, posY : CGFloat, isAvailable : Bool) {
        if (isAvailable) {
            cellNE = SKSpriteNode(imageNamed: "hexagon_green")
        }else {
            cellNE = SKSpriteNode(imageNamed: "hexagon_red")
        }
        cellNE.position = CGPoint(x:posX + 3 * CELL_WIDTH / 4, y:posY + CELL_HEIGHT / 2)
        
        self.addChild(cellNE)
    }
    
    func printCellSE(posX : CGFloat, posY : CGFloat, isAvailable : Bool) {
        if (isAvailable) {
            cellSE = SKSpriteNode(imageNamed: "hexagon_green")
        }else {
            cellSE = SKSpriteNode(imageNamed: "hexagon_red")
        }
        cellSE.position = CGPoint(x:posX + 3 * CELL_WIDTH / 4, y:posY - CELL_HEIGHT / 2)
        
        self.addChild(cellSE)
    }

    func printCellS(posX : CGFloat, posY : CGFloat, isAvailable : Bool) {
        if (isAvailable) {
            cellS = SKSpriteNode(imageNamed: "hexagon_green")
        }else {
            cellS = SKSpriteNode(imageNamed: "hexagon_red")
        }
        cellS.position = CGPoint(x:posX, y:posY - CELL_HEIGHT)
        
        self.addChild(cellS)
    }
    
    func printCellSW(posX : CGFloat, posY : CGFloat, isAvailable : Bool) {
        if (isAvailable) {
            cellSW = SKSpriteNode(imageNamed: "hexagon_green")
        }else {
            cellSW = SKSpriteNode(imageNamed: "hexagon_red")
        }
        cellSW.position = CGPoint(x:posX - 3 * CELL_WIDTH / 4, y:posY - CELL_HEIGHT / 2)
        
        self.addChild(cellSW)
    }
    
    func printCellNW(posX : CGFloat, posY : CGFloat, isAvailable : Bool) {
        if (isAvailable) {
            cellNW = SKSpriteNode(imageNamed: "hexagon_green")
        }else {
            cellNW = SKSpriteNode(imageNamed: "hexagon_red")
        }
        cellNW.position = CGPoint(x:posX - 3 * CELL_WIDTH / 4, y:posY + CELL_HEIGHT / 2)
        
        self.addChild(cellNW)
    }*/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("touchesBegan cell begin")
        if (previousCell != nil) {
            previousCell.sprite.texture = SKTexture(imageNamed: "hexagon_orange")
            //previousCell.texture = SKTexture(imageNamed: "hexagon_orange")
        }
        /*
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        */
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("touchesEnded cell begin")
        if let touch = touches.first {
            let positionInScene = touch.location(in: self)
            //if let currentCell = self.atPoint(positionInScene) as? Cell {
            //if let currentCell = self.nodes(at: positionInScene) as? Cell {
            let cell = self.atPoint(positionInScene)
            
            //print("touched cell \(cell.name!)")
            let touchedCellName : String = "current\(cell.name!)"
            //print("trying to retrieve cell \(touchedCellName)")
            
            
            /*self.enumerateChildNodes(withName: "") { node, stop in
                if node is Cell {
                    descendants.append(node as! CustomClass)
                }
            }*/
            
            
            touchedCell = self.childNode(withName:touchedCellName) as? Cell
            if touchedCell.roof.zPosition == 9 {
                if touchedCell != nil {
                  touchedCell.roof.isHidden = true
                }
                
                if touchedCell == previousTouchedCell {
                    moveBeeToColRow(col:touchedCell.cellCol, row:touchedCell.cellRow)
                    
                    hideNeighbours()
                    
                    printNeighboursWithColRow()
                    previousCell = currentCell
                   // currentCell = touchedCell
                }
                if previousTouchedCell != nil {
                    previousTouchedCell.roof.isHidden = false
                }
                
                previousTouchedCell = touchedCell
                /*currentCell = self.childNode(withName:touchedCellName) as? Cell
                if currentCell != nil {
                //if let currentCell = self.childNode(withName: "\(touchedCellName)") {
                        print("touching cell \(currentCell.name!)")
                        //currentCell = self.atPoint(positionInScene) as? SKSpriteNode
                        currentCell.sprite.texture = SKTexture(imageNamed: "hexagon_pink")
                        //currentCell.texture = SKTexture(imageNamed: "hexagon_pink")
                 
                        //print("cell(\(currentCell.cellRow)\(currentCell.cellCol))")
                    if (previousCell != nil) {
                        hideNeighbours()
                    }
                        previousCell = currentCell
                        //printNeighbours()
                    printNeighboursWithColRow()
                }*/
            }
        }
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func moveBeeToColRow(col : Int, row : Int) {
        let cellName : String = "currentcell\(col)\(row)"
        let cell = self.childNode(withName:cellName) as? Cell
        let location = CGPoint(x: (cell?.position.x)!, y: (cell?.position.y)!)
        let moveAction = SKAction.move(to: location, duration: 0.3)
       // bee.run(moveAction)
        bee.run(moveAction, completion: {
            self.hideNeighbours()
            self.currentCell = self.touchedCell
            self.printNeighboursWithColRow()
           // self.previousCell = self.currentCell
           // self.printNeighboursWithColRow()
        })

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
