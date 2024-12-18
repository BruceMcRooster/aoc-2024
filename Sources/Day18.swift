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

  func part1() -> Any {
    struct Position: Hashable, Equatable {
      let x, y: Int
      
      func distanceTo(_ other: Position) -> Int {
        abs(x - other.x) * abs(x - other.x) + abs(y - other.y) * abs(y - other.y)
      }
    }
    
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
    
    let end = Position(x: width, y: height)
    
    var priorityQueue = [(cost: Int, position: Position)]()
    
    var bestCosts: [Position: Int] = [:]
    
    func enqueue(_ position: Position, cost: Int) {
      let totalCost = cost + position.distanceTo(end)
      for i in priorityQueue.indices {
        if totalCost < priorityQueue[i].cost + priorityQueue[i].position.distanceTo(end) {
          priorityQueue.insert((cost, position), at: i)
          return
        }
      }
      priorityQueue.append((cost, position)) // If there are no elements
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
    
    let start = Position(x: 0, y: 0)
    enqueue(start, cost: 0)
    
    while !priorityQueue.isEmpty {
      let (cost, position) = priorityQueue.removeFirst()
      if position == end {
        return cost
      }
      if cost < bestCosts[position, default: Int.max] {
        bestCosts[position] = cost
        let neighbors = getNeighbors(of: position)
        neighbors.forEach { enqueue($0, cost: cost + 1) }
      }
    }
    fatalError("Did not find end")
  }

  func part2() -> Any {
    return 0
  }
}
