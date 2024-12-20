import Algorithms

struct Day20: AdventDay {
  var data: String

  var picosecondCutoff: Int
  
  init(data: String) {
    self.data = data
    self.picosecondCutoff = 100
  }
  
  init(data: String, picosecondCutoff: Int) {
    self.data = data
    self.picosecondCutoff = picosecondCutoff
  }
  
  func part1() -> Any {
    struct Position: Hashable {
      let x: Int
      let y: Int
    }
    
    var startPosition: Position = Position(x: -1, y: -1)
    var endPosition: Position = Position(x: -1, y: -1)
    
    var validPositions: Set<Position> = []
    
    var width: Int?
    var height = 0
    
    for (index, char) in data.enumerated() {
      guard char != "\n" else {
        if width == nil {
          width = index
        }
        height += 1
        continue
      }
      
      guard char != "#" else { continue }
      
      let position = Position(x: width.map { index % ($0 + 1) } ?? index, y: height)
      
      if char == "S" {
        startPosition = position
      } else if char == "E" {
        endPosition = position
      }
      
      validPositions.insert(position)
    }
    
    assert(startPosition != Position(x: -1, y: -1))
    assert(endPosition != Position(x: -1, y: -1))
    
    var picosecondsToEnd = [Position: Int]()
    
    func getPicosecondsToTraverse() -> Int {
      var queue = [(position: endPosition, cost: 0)]
      
      while !queue.isEmpty {
        let (position, cost) = queue.removeFirst()
        
        guard picosecondsToEnd[position] == nil else { continue }
        
        picosecondsToEnd[position] = cost
        
        if validPositions.contains(Position(x: position.x - 1, y: position.y)) {
          queue.append((Position(x: position.x - 1, y: position.y), cost + 1))
        }
        if validPositions.contains(Position(x: position.x + 1, y: position.y)) {
          queue.append((Position(x: position.x + 1, y: position.y), cost + 1))
        }
        if validPositions.contains(Position(x: position.x, y: position.y - 1)) {
          queue.append((Position(x: position.x, y: position.y - 1), cost + 1))
        }
        if validPositions.contains(Position(x: position.x, y: position.y + 1)) {
          queue.append((Position(x: position.x, y: position.y + 1), cost + 1))
        }
      }
      
      return picosecondsToEnd[startPosition]!
    }
    
    let noCheatTraverseTime = getPicosecondsToTraverse()
        
    func findCheatCounts() -> Int {
      func getNeighbors(to position: Position) -> [(position: Position, needsCheat: Bool)] {
        var neighbors = [(Position, Bool)]()
        
        if validPositions.contains(Position(x: position.x - 1, y: position.y)) {
          neighbors.append((Position(x: position.x - 1, y: position.y), false))
        } else if validPositions.contains(Position(x: position.x - 2, y: position.y)) {
          neighbors.append((Position(x: position.x - 2, y: position.y), true))
        }
        
        if validPositions.contains(Position(x: position.x + 1, y: position.y)) {
          neighbors.append((Position(x: position.x + 1, y: position.y), false))
        } else if validPositions.contains(Position(x: position.x + 2, y: position.y)) {
          neighbors.append((Position(x: position.x + 2, y: position.y), true))
        }
        
        if validPositions.contains(Position(x: position.x, y: position.y - 1)) {
          neighbors.append((Position(x: position.x, y: position.y - 1), false))
        } else if validPositions.contains(Position(x: position.x, y: position.y - 2)) {
          neighbors.append((Position(x: position.x, y: position.y - 2), true))
        }
        
        if validPositions.contains(Position(x: position.x, y: position.y + 1)) {
          neighbors.append((Position(x: position.x, y: position.y + 1), false))
        } else if validPositions.contains(Position(x: position.x, y: position.y + 2)) {
          neighbors.append((Position(x: position.x, y: position.y + 2), true))
        }
        
        return neighbors
      }
      
      var queue = [(position: Position, time: Int, hasCheated: Bool)]()
      queue.append((position: startPosition, time: 0, hasCheated: false))
      
      var waysCount = 0
      
      while !queue.isEmpty {
        let (position, time, hasCheated) = queue.removeFirst()
        
        guard time + picosecondsToEnd[position]! <= noCheatTraverseTime else { continue }
        guard time <= noCheatTraverseTime - picosecondCutoff else { continue }
        
        guard !hasCheated else {
          let timeToEndFrom = picosecondsToEnd[position]!
          
          if time + timeToEndFrom <= noCheatTraverseTime - picosecondCutoff {
            waysCount += 1
          }
          
          continue
        }
        
        for (neighbor, needsCheats) in getNeighbors(to: position) {
          queue.append((neighbor, time + (needsCheats ? 2 : 1), needsCheats))
        }
      }
      return waysCount
    }
    
    return findCheatCounts()
  }

  func part2() -> Any {
    return 0
  }
}
