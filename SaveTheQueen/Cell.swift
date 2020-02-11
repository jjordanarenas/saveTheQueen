//
//  Cell.swift
//  POC
//
//  Created by Jorge Jordán on 02/05/2019.
//  Copyright © 2019 Jorge Jordán. All rights reserved.
//

import Foundation
import SpriteKit

class Cell : SKNode {
    internal var cellCol : Int!
    internal var cellRow : Int!
    internal var image : String!
    internal var cellNeighbours : [String]!
    internal var sprite : SKSpriteNode!
    internal var roof : SKSpriteNode!
    
    init(col : Int, row : Int, image : String, neighbours : [String]) {
        super.init()
        //let texture = SKTexture(imageNamed: image)
        self.isUserInteractionEnabled = false


        
        cellCol = col
        cellRow = row
        cellNeighbours = neighbours
        sprite = SKSpriteNode(imageNamed : image);
        sprite.name = "cell\(col)\(row)"
       // print("created sprite with name \(sprite.name!)")
        //sprite.isUserInteractionEnabled = false
        self.name = "currentcell\(col)\(row)"
        //print("created cell with name \(self.name!)")
        //super.init(texture: texture, color: UIColor.clear, size: texture.size())
        addChild(sprite)
        roof = SKSpriteNode(imageNamed : "hexagon_red");
        roof.zPosition = 8
        roof.name = "cell\(col)\(row)"
        roof.isHidden = true
        roof.isUserInteractionEnabled = false
        addChild(roof)
        
        
    }
    
    override init() {
       super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
