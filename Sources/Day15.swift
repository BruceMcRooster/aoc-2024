import Algorithms

struct Day15: AdventDay {
  var data: String

  struct Map {
    let width: Int
    let height: Int
    let isWide: Bool
    
    private(set) var robotPosition: (x: Int, y: Int)
    
    enum GridPiece {
      case wall, box, robot, leftBox, rightBox
    }
    
    var map = [GridPiece?]()
    
    init(fromData data: String, isWide: Bool = false) {
      self.isWide = isWide
      var width: Int?
      var lineCount = 0
      for (index, char) in data.enumerated() {
        guard char != "\n" else {
          if width == nil { width = index }
          lineCount += 1
          continue
        }
        let piece: GridPiece? = switch char {
        case "#": .wall
        case "O": .box
        case "@": .robot
        case ".": nil
        default: fatalError( "Unknown character \(char)")
        }
        
        if isWide {
          if piece == .robot {
            map.append(.robot)
            map.append(nil)
          } else if piece == .box {
            map.append(.leftBox)
            map.append(.rightBox)
          } else {
            map.append(piece)
            map.append(piece)
          }
        } else {
          map.append(piece)
        }
      }
      self.width = width! * ((isWide) ? 2 : 1)
      self.height = lineCount + 1 // because we trim the last \n when splitting
      
      let robotIndex = map.firstIndex(of: .robot)!
      
      self.robotPosition = (robotIndex % self.width, robotIndex / self.width)
      
      // No regular boxes in a wide map
      assert(!self.isWide || !self.map.contains(where: { $0 == .box }))
    }
    
    subscript (x: Int, y: Int) -> GridPiece? {
      get {
        assert(0 <= x && x < width, "Attempted to read position (\(x), \(y))")
        assert(0 <= y && y < height, "Attempted to read position (\(x), \(y))")
        return map[y * width + x]
      }
      set(value) {
        assert(0 <= x && x < width, "Attempted to write position (\(x), \(y))")
        assert(0 <= y && y < height, "Attempted to write position (\(x), \(y))")
        map[y * width + x] = value
      }
    }
    
    func printBoard() {
      for y in 0..<height {
        for x in 0..<width {
          if let piece = self[x, y] {
            switch piece {
            case .wall:
              print("#", terminator: "")
            case .box:
              print("O", terminator: "")
            case .robot:
              print("@", terminator: "")
            case .leftBox:
              print("[", terminator: "")
            case .rightBox:
              print("]", terminator: "")
            }
          } else {
            print(".", terminator: "")
          }
        }
        print()
      }
    }
    
    enum Direction {
      case up, down, left, right
      
      func movePoint(x: Int, y: Int) -> (x: Int, y: Int) {
        switch self {
        case .up:
          (x, y - 1)
        case .down:
          (x, y + 1)
        case .left:
          (x - 1, y)
        case .right:
          (x + 1, y)
        }
      }
      func invert() -> Direction {
        switch self {
        case .up:
          .down
        case .down:
            .up
        case .left:
            .right
        case .right:
            .left
        }
      }
    }
    
    mutating func tryPush(_ direction: Direction, fromRobotPosition position: (x: Int, y: Int)) -> Bool {
      let attemptedPosition = direction.movePoint(x: position.x, y: position.y)
      
      if self[attemptedPosition.x, attemptedPosition.y] == nil {
        return true
      }
      
      if self[attemptedPosition.x, attemptedPosition.y] == .wall {
        return false
      }
      
      if !isWide {
        var checkingPosition = attemptedPosition
        while self[checkingPosition.x, checkingPosition.y] == .box {
          checkingPosition = direction.movePoint(x: checkingPosition.x, y: checkingPosition.y)
        }
        if self[checkingPosition.x, checkingPosition.y] == nil {
          self[checkingPosition.x, checkingPosition.y] = .box
          self[attemptedPosition.x, attemptedPosition.y] = nil
          return true
        } else { return false }// otherwise it's a wall and we can't move
      } else { // Wide board, boxes in the way
        if direction == .left || direction == .right {
          var checkingPosition = attemptedPosition
          while self[checkingPosition.x, checkingPosition.y] == .leftBox || self[checkingPosition.x, checkingPosition.y] == .rightBox {
            checkingPosition = direction.movePoint(x: checkingPosition.x, y: checkingPosition.y)
          }
          if self[checkingPosition.x, checkingPosition.y] == nil {
            let inverse = direction.invert()
            assert(inverse == .left || inverse == .right)
            var prevPosition = inverse.movePoint(x: checkingPosition.x, y: checkingPosition.y)
            while self[prevPosition.x, prevPosition.y] == .leftBox || self[prevPosition.x, prevPosition.y] == .rightBox {
              self[checkingPosition.x, checkingPosition.y] = self[prevPosition.x, prevPosition.y]
              checkingPosition = prevPosition
              prevPosition = inverse.movePoint(x: prevPosition.x, y: prevPosition.y)
            }
            let oneBack = direction.movePoint(x: prevPosition.x, y: prevPosition.y)
            assert(direction == .left && self[oneBack.x, oneBack.y] == .rightBox
                   || direction == .right && self[oneBack.x, oneBack.y] == .leftBox,
                   "Oneback (at \(oneBack)) was not a \((direction == .left ? "rightBox" : "leftBox")) box, instead it was \(String(describing: self[oneBack.x, oneBack.y]))"
            )
            self[oneBack.x, oneBack.y] = nil
            return true
          } else { return false } // Found a wall after a chain of boxes
        } else { // Up or down wide grid
          
          func canPushBox(leftPosition: (x: Int, y: Int), up: Bool) -> Bool {
            assert(self[leftPosition.x, leftPosition.y] == .leftBox, "Was not called with valid left side of box at \(leftPosition)")
            let offset = up ? -1 : 1
            
            let aboveLeftSide = self[leftPosition.x, leftPosition.y + offset]
            let aboveRightSide = self[leftPosition.x + 1, leftPosition.y + offset]
            
            if aboveLeftSide == .wall || aboveRightSide == .wall {
              return false
            } else if aboveLeftSide == nil && aboveRightSide == nil {
              return true
            } else if aboveLeftSide == .leftBox {
              assert(aboveRightSide == .rightBox, "Incorrect double boxes found at (\(leftPosition.x), \(leftPosition.y + offset)")
              
              return canPushBox(leftPosition: (leftPosition.x, leftPosition.y + offset), up: up)
            } else {
              let canPushLeft = aboveLeftSide == nil || canPushBox(leftPosition: (leftPosition.x - 1, leftPosition.y + offset), up: up)
              let canPushRight = aboveRightSide == nil || canPushBox(leftPosition: (leftPosition.x + 1, leftPosition.y + offset), up: up)
              return canPushLeft && canPushRight
            }
          }
          
          func pushBox(leftPosition: (x: Int, y: Int), up: Bool) {
            assert(self[leftPosition.x, leftPosition.y] == .leftBox, "Was not called with valid left side box at \(leftPosition)")
            let offset = up ? -1 : 1
            
            let aboveLeftSide = self[leftPosition.x, leftPosition.y + offset]
            let aboveRightSide = self[leftPosition.x + 1, leftPosition.y + offset]
            
            if aboveLeftSide == nil && aboveRightSide == nil {
              self[leftPosition.x, leftPosition.y + offset] = .leftBox
              self[leftPosition.x + 1, leftPosition.y + offset] = .rightBox
              self[leftPosition.x, leftPosition.y] = nil
              self[leftPosition.x + 1, leftPosition.y] = nil
            } else if aboveLeftSide == .leftBox {
              pushBox(leftPosition: (leftPosition.x, leftPosition.y + offset), up: up)
              self[leftPosition.x, leftPosition.y + offset] = .leftBox
              self[leftPosition.x + 1, leftPosition.y + offset] = .rightBox
              self[leftPosition.x, leftPosition.y] = nil
              self[leftPosition.x + 1, leftPosition.y] = nil
            } else {
              if aboveLeftSide == .rightBox {
                pushBox(leftPosition: (leftPosition.x - 1, leftPosition.y + offset), up: up)
              }
              if aboveRightSide == .leftBox {
                pushBox(leftPosition: (leftPosition.x + 1, leftPosition.y + offset), up: up)
              }
              self[leftPosition.x, leftPosition.y + offset] = .leftBox
              self[leftPosition.x + 1, leftPosition.y + offset] = .rightBox
              self[leftPosition.x, leftPosition.y] = nil
              self[leftPosition.x + 1, leftPosition.y] = nil
            }
          }
          
          if self[attemptedPosition.x, attemptedPosition.y] == .leftBox {
            guard canPushBox(leftPosition: attemptedPosition, up: direction == .up) else { return false }
            pushBox(leftPosition: attemptedPosition, up: direction == .up)
          } else {
            assert(self[attemptedPosition.x, attemptedPosition.y] == .rightBox)
            guard canPushBox(leftPosition: (attemptedPosition.x - 1, attemptedPosition.y), up: direction == .up) else { return false }
            pushBox(leftPosition: (attemptedPosition.x - 1, attemptedPosition.y), up: direction == .up)
          }
          return true
        }
      }
    }
    
    mutating func moveRobot(_ direction: Direction) {
      guard tryPush(direction, fromRobotPosition: robotPosition) else { return }
      
      self[robotPosition.x, robotPosition.y] = nil
      let nextPosition = direction.movePoint(x: robotPosition.x, y: robotPosition.y)
      assert(self[nextPosition.x, nextPosition.y] == nil, "Path was not properly cleared, there was \(self[nextPosition.x, nextPosition.y]!) in the way")
      robotPosition = nextPosition
      self[robotPosition.x, robotPosition.y] = .robot
    }
  }
  
  func part1() -> Any {
    let split = data.split(separator: "\n\n")
    assert(split.count == 2)
    
    var map = Map(fromData: String(split.first!))
    let moves = split[1]
    
    for move in moves {
      guard move != "\n" else { continue }
      let direction: Map.Direction = switch move {
      case ">": .right
      case "<": .left
      case "^": .up
      case "v": .down
      default: fatalError("Unexpected move instruction: \(move)")
      }
      
      map.moveRobot(direction)
    }
    
    var gpsCount = 0
    for x in 0..<map.width {
      for y in 0..<map.height {
        if map[x, y] == .box { gpsCount += x + (100 * y)}
      }
    }
    return gpsCount
  }

  func part2() -> Any {
    let split = data.split(separator: "\n\n")
    assert(split.count == 2)
    
    var map = Map(fromData: String(split.first!), isWide: true)
    
    let moves = split[1]
    
    for move in moves {
      guard move != "\n" else { continue }
      let direction: Map.Direction = switch move {
      case ">": .right
      case "<": .left
      case "^": .up
      case "v": .down
      default: fatalError("Unexpected move instruction: \(move)")
      }

      map.moveRobot(direction)
    }
    
    var gpsCount = 0
    for x in 0..<map.width {
      for y in 0..<map.height {
        if map[x, y] == .leftBox { gpsCount += x + (100 * y)}
      }
    }
    return gpsCount
  }
}
