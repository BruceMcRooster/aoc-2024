import Algorithms

struct Day15: AdventDay {
  var data: String

  struct Map {
    let width: Int
    let height: Int
    
    private(set) var robotPosition: (x: Int, y: Int)
    
    enum GridPiece {
      case wall, box, robot
    }
    
    var map = [GridPiece?]()
    
    init(fromData data: String) {
      var width: Int?
      var lineCount = 0
      var robotIndex: Int?
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
        
        map.append(piece)
        
        if char == "@" {
          robotIndex = index - lineCount // remove an index for every \n that we have passed
        }
      }
      self.width = width!
      self.height = lineCount + 1 // because we trim the last \n when splitting
      self.robotPosition = (robotIndex! / self.width, robotIndex! % self.width)
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
    }
    
    mutating func moveRobot(_ direction: Direction) {
      let attemptedPosition = direction.movePoint(x: robotPosition.x, y: robotPosition.y)
      
      if self[attemptedPosition.x, attemptedPosition.y] == nil {
        self[robotPosition.x, robotPosition.y] = nil
        self[attemptedPosition.x, attemptedPosition.y] = .robot
        self.robotPosition = attemptedPosition
        return
      }
      
      var checkingPosition = attemptedPosition
      while self[checkingPosition.x, checkingPosition.y] == .box {
        checkingPosition = direction.movePoint(x: checkingPosition.x, y: checkingPosition.y)
      }
      if self[checkingPosition.x, checkingPosition.y] == nil {
        self[checkingPosition.x, checkingPosition.y] = .box
        self[attemptedPosition.x, attemptedPosition.y] = .robot
        self[robotPosition.x, robotPosition.y] = nil
        self.robotPosition = attemptedPosition
      } // otherwise it's a wall and we can't move, so don't have to do anything
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
    return 0
  }
}
