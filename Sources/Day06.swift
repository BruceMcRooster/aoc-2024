import Algorithms

struct Day06: AdventDay {
  var data: String
  
  var map: [Character]
  
  init(data: String) {
    self.data = data
    self.width = data.split(separator: "\n").first!.count
    self.height = data.split(separator: "\n").filter { !$0.isEmpty }.count
    self.map = Array(data).filter { $0 != "\n" }
  }
  
  let width: Int
  let height: Int
  
  struct Orientation: Equatable, Hashable {
    let x: Int
    let y: Int
    let direction: Direction
    
    // Disregarding orientation because I don't need it for this
    // Two orientations should be considered the same regardless
    // of the position of the guard at the time they were there
    static func == (lhs: Orientation, rhs: Orientation) -> Bool {
      lhs.x == rhs.x && lhs.y == rhs.y && lhs.direction == rhs.direction
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(x)
      hasher.combine(y)
      hasher.combine(direction)
    }
    
    enum Direction: Equatable, Hashable {
      case up, left, down, right
      func rotatedClockwise() -> Direction {
        switch self {
        case .up: .right
        case .right: .down
        case .down: .left
        case .left: .up
        }
      }
    }
    
    func advanced() -> Orientation {
      let newX = switch self.direction {
      case .left: self.x - 1
      case .right: self.x + 1
      default: self.x
      }
      
      let newY = switch self.direction {
      case .up: self.y - 1
      case .down: self.y + 1
      default: self.y
      }
      
      return Orientation(
        x: newX,
        y: newY,
        direction: self.direction
      )
    }
    
    func rotatedClockwise() -> Orientation {
      return Orientation(x: self.x, y: self.y, direction: self.direction.rotatedClockwise())
    }
  }
  
  enum OffBoardError: Error {
    case notOnBoard
  }
  
  func positionToIndex(_ position: (x: Int, y: Int)) throws(OffBoardError) -> String.Index {
    guard 0 <= position.x && position.x < width else {
      throw .notOnBoard
    }
    guard 0 <= position.y && position.y < height else {
      throw .notOnBoard
    }
    
    let offset: Int = position.x + position.y * (width + 1)
    
    let index = data.index(data.startIndex, offsetBy: offset, limitedBy: data.endIndex)
    
    if let index {
      return index
    } else {
      fatalError("Index ended up out of bounds")
    }
  }
  
  func indexToPosition(_ index: String.Index) -> (x: Int, y: Int) {
    let offset: Int = data.distance(from: data.startIndex, to: index)
    let x: Int = offset % (width + 1)
    let y: Int = offset / (width + 1)
    assert(0 <= x && x < width)
    assert(0 <= y && y < height)
    return (x, y)
  }
  
  func advance(_ orientation: Orientation, board: [Character]) throws(OffBoardError) -> Orientation {
    let nextPosition = orientation.advanced()
    guard 0 <= nextPosition.x
            && nextPosition.x < width
            && 0 <= nextPosition.y
            && nextPosition.y < height
    else { throw .notOnBoard }
    let nextIndex = nextPosition.x + (nextPosition.y * width)
    if board[nextIndex] == "." || board[nextIndex] == "^" {
      return nextPosition
    } else {
      return orientation.rotatedClockwise()
    }
  }
  
  func part1() -> Any {
    let startIndex = data.firstIndex(of: "^")!
    let startPosition = indexToPosition(startIndex)
    var orientation = Orientation(
      x: startPosition.x,
      y: startPosition.y,
      direction: .up
    )
    
    var allOrientations: Set<Orientation> = [orientation]
    
    while true {
      do {
        orientation = try advance(orientation, board: map)
        allOrientations.insert(orientation)
      } catch {
        break
      }
    }
    
    return Set(allOrientations.map { Orientation(x: $0.x, y: $0.y, direction: .up) }).count
  }
  
  enum StuckInLoop: Error {
    case stuck
  }
  
  func traverse(from startOrientation: Orientation, onBoard board: [Character]) throws(StuckInLoop) -> Set<Orientation> {
    assert(board.count == width * height)
    
    var visited: Set<Orientation> = [startOrientation]
    var orientation = startOrientation
        
    while true {
      do {
        orientation = try advance(orientation, board: board)
      } catch {
        break
      }
      if !visited.insert(orientation).inserted {
        throw StuckInLoop.stuck
      }
    }
    return visited
  }
  
  func part2() -> Any {
    let startIndex = data.firstIndex(of: "^")!
    let startPosition = indexToPosition(startIndex)
    let orientation = Orientation(
      x: startPosition.x,
      y: startPosition.y,
      direction: .up
    )
    
    let visited = Set(
      try! traverse(from: orientation, onBoard: map)
        .map { Orientation(x: $0.x, y: $0.y, direction: .up) }
    )
      .map { (x: $0.x, y: $0.y) }
      .filter { $0.x != startPosition.x || $0.y != startPosition.y }
    
    var count = 0
    
    for position in visited {
      var newBoard = map
      newBoard[position.x + (position.y * width)] = "#"
      do {
        let _ = try traverse(from: orientation, onBoard: newBoard)
        continue
      } catch {
        count += 1
      }
    }
    return count
  }
}
