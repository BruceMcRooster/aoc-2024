import Algorithms

struct Day18: AdventDay {
  var data: String
  
  let width: Int
  let height: Int
  let fallenBytes: Int
  
  init(data: String) {
    self.data = data
    self.width = 70
    self.height = 70
    self.fallenBytes = 1024
  }
  
  init(data: String, width: Int, height: Int, fallenBytes: Int) {
    self.data = data
    self.width = width
    self.height = height
    self.fallenBytes = fallenBytes
  }

  struct Position: Hashable, Equatable {
    let x, y: Int
    
    func distanceTo(_ other: Position) -> Int {
      abs(x - other.x) * abs(x - other.x) + abs(y - other.y) * abs(y - other.y)
    }
  }
  
  func findPath(withBlockedPositions fallenPositions: Set<Position>) -> Set<Position>? {
    let start = Position(x: 0, y: 0)
    let end = Position(x: width, y: height)
    
    var priorityQueue = [(cost: Int, position: Position, parent: Position?)]()
    
    var bestCosts: [Position: Int] = [:]
    var cameFrom: [Position: Position] = [:]
    
    func enqueue(_ position: Position, cost: Int, from parent: Position?) {
      let totalCost = cost + position.distanceTo(end)
      for i in priorityQueue.indices {
        if totalCost < priorityQueue[i].cost + priorityQueue[i].position.distanceTo(end) {
          priorityQueue.insert((cost, position, parent), at: i)
          return
        }
      }
      priorityQueue.append((cost, position, parent)) // If there are no elements
    }
    
    func getNeighbors(of position: Position) -> [Position] {
      var neighbors: [Position] = []
      if position.x > 0 && !fallenPositions.contains(Position(x: position.x - 1, y: position.y)) {
        neighbors.append(Position(x: position.x - 1, y: position.y))
      }
      if position.x < width && !fallenPositions.contains(Position(x: position.x + 1, y: position.y)) {
        neighbors.append(Position(x: position.x + 1, y: position.y))
      }
      if position.y > 0 && !fallenPositions.contains(Position(x: position.x, y: position.y - 1)) {
        neighbors.append(Position(x: position.x, y: position.y - 1))
      }
      if position.y < height && !fallenPositions.contains(Position(x: position.x, y: position.y + 1)) {
        neighbors.append(Position(x: position.x, y: position.y + 1))
      }
      return neighbors
    }
    
    func backTrackFromEnd() -> Set<Position> {
      var currPos = end
      
      var prev: Set<Position> = [currPos]
      
      while currPos != start {
        currPos = cameFrom[currPos]!
        prev.insert(currPos)
      }
      
      assert(currPos == start)
      prev.insert(currPos)
      
      return prev
    }
    
    enqueue(start, cost: 0, from: nil)
    
    while !priorityQueue.isEmpty {
      let (cost, position, parent) = priorityQueue.removeFirst()
      if position == end {
        cameFrom[end] = parent
        return backTrackFromEnd()
      }
      if cost < bestCosts[position, default: Int.max] {
        bestCosts[position] = cost
        cameFrom[position] = parent
        
        let neighbors = getNeighbors(of: position)
        neighbors.forEach { enqueue($0, cost: cost + 1, from: position) }
      }
    }
    return nil
  }
  
  func part1() -> Any {
    
    func drop(bytes: Int) -> Set<Position> {
      let lines = data.split(separator: "\n").filter { !$0.isEmpty }
      
      var fallenPositions = Set<Position>()
      
      for byte in 0..<bytes {
        let split = lines[byte].split(separator: ",", maxSplits: 1)
        let x = Int(split[0])!
        let y = Int(split[1])!
        
        fallenPositions.insert(Position(x: x, y: y))
      }
      return fallenPositions
    }
    
    let fallenPositions = drop(bytes: fallenBytes)
    
    if let prevPositions = findPath(withBlockedPositions: fallenPositions) {
      return prevPositions.count - 1
    }
    
    fatalError("Did not find end")
  }

  func part2() -> Any {
    let fallPositions: [Position] = data
      .split(separator: "\n")
      .filter({ !$0.isEmpty })
      .map({
        let split = $0.split(separator: ",", maxSplits: 1)
        return Position(x: Int(split[0])!, y: Int(split[1])!)
      })
    
    func dropPosition(_ byte: Int, insertingInto fallenPositions: inout Set<Position>) -> Position {
      return fallenPositions.insert(fallPositions[byte]).memberAfterInsert
    }
    
    var fallenPositions = Set<Position>()
    
    for byte in 0..<fallenBytes { // We know it won't be blocked for the first bytes given to part 1
      let _ = dropPosition(byte, insertingInto: &fallenPositions)
    }
    
    var checkingPosition: Position
    var currByte = fallenBytes
    var currBestPath: Set<Position> = findPath(withBlockedPositions: fallenPositions)!
    
    while true {
      checkingPosition = dropPosition(currByte, insertingInto: &fallenPositions)
      currByte += 1
      
      // If it doesn't interfere with the current path, don't worry about it
      guard currBestPath.contains(checkingPosition) else { continue }
      
      // If it's nil, we found a position that blocked complete traversal
      guard let newBestPath = findPath(withBlockedPositions: fallenPositions) else { break }
      
      currBestPath = newBestPath
    }
    
    return "\(checkingPosition.x),\(checkingPosition.y)"
  }
}
