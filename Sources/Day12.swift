import Algorithms
import DequeModule

struct Day12: AdventDay {
  
  var data: String
  
  let map: [Character]
  let width: Int

  init(data: String) {
    self.data = data
    self.map = data.filter { $0 != "\n" }
    self.width = data.distance(from: data.startIndex, to: data.firstIndex(of: "\n")!)
  }
  
  func part1() -> Any {
    var checked = Set<Int>()
    
    func check(_ index: Int) -> (area: Int, perimeter: Int) {
      var area = 0
      var perimeter = 0
      
      var nextChecks: Deque<Int> = [index]
      
      while !nextChecks.isEmpty {
        let checkIndex = nextChecks.popFirst()!
        
        // Add it, and solves if something might have been added from two directions
        guard checked.insert(checkIndex).inserted else { continue }
        
        
        area += 1
        perimeter += 4
        
        if checkIndex % width > 0,
            map[checkIndex - 1] == map[checkIndex]
        {
          if !checked.contains(checkIndex - 1) {
            nextChecks.append(checkIndex - 1)
          }
          perimeter -= 1
        }
        if checkIndex % width < width - 1,
            map[checkIndex + 1] == map[checkIndex]
        {
          if !checked.contains(checkIndex + 1) {
            nextChecks.append(checkIndex + 1)
          }
          perimeter -= 1
        }
        if checkIndex / width > 0,
            map[checkIndex - width] == map[checkIndex]
        {
          if !checked.contains(checkIndex - width) {
            nextChecks.append(checkIndex - width)
          }
          perimeter -= 1
        }
        if checkIndex / width < width - 1,
            map[checkIndex + width] == map[checkIndex]
        {
          if !checked.contains(checkIndex + width) {
            nextChecks.append(checkIndex + width)
          }
          perimeter -= 1
        }
      }
      
      return (area, perimeter)
    }
    
    var sum = 0
    
    for unchecked in map.indices where !checked.contains(unchecked) {
      let (area, perimeter) = check(unchecked)
      sum += (area * perimeter)
    }
    return sum
  }

  func part2() -> Any {
    var checked = Set<Int>()
    
    func check(from index: Int) -> (area: Int, sideCount: Int) {
      enum Sides: Hashable {
        case above(row: Int, column: Int), below(row: Int, column: Int)
        case left(row: Int, column: Int), right(row: Int, column: Int)
        
        func toString() -> String {
          switch self {
          case .above(row: let row, column: let column): return "above(\(row), \(column))"
          case .below(row: let row, column: let column): return "below(\(row), \(column))"
          case .left(row: let row, column: let column): return "left(\(row),\(column))"
          case .right(row: let row, column: let column): return "right(\(row),\(column))"
          }
        }
      }
      
      var area = 0
      var sides = Set<Sides>()
      
      var nextChecks: Deque<Int> = [index]
      
      while !nextChecks.isEmpty {
        let checkIndex = nextChecks.removeFirst()
        
        guard checked.insert(checkIndex).inserted else { continue }
        
        area += 1
        
        if checkIndex % width == 0 ||
          map[checkIndex - 1] != map[checkIndex]
        {
          sides.insert(.left(row: checkIndex / width, column: checkIndex % width))
        }
        if checkIndex % width == width - 1 ||
          map[checkIndex + 1] != map[checkIndex]
        {
          sides.insert(.right(row: checkIndex / width, column: checkIndex % width))
        }
        if checkIndex / width == 0 ||
          map[checkIndex - width] != map[checkIndex]
        {
          sides.insert(.above(row: checkIndex / width, column: checkIndex % width))
        }
        if checkIndex / width == width - 1 ||
          map[checkIndex + width] != map[checkIndex]
        {
          sides.insert(.below(row: checkIndex / width, column: checkIndex % width))
        }
        
        if checkIndex % width > 0,
          map[checkIndex - 1] == map[checkIndex],
          !checked.contains(checkIndex - 1)
        {
          nextChecks.append(checkIndex - 1)
        }
        if checkIndex % width < width - 1,
          map[checkIndex + 1] == map[checkIndex],
          !checked.contains(checkIndex + 1)
        {
          nextChecks.append(checkIndex + 1)
        }
        if checkIndex / width > 0,
          map[checkIndex - width] == map[checkIndex],
          !checked.contains(checkIndex - width)
        {
          nextChecks.append(checkIndex - width)
        }
        if checkIndex / width < width - 1,
          map[checkIndex + width] == map[checkIndex],
          !checked.contains(checkIndex + width)
        {
          nextChecks.append(checkIndex + width)
        }
      }
      
      var sideCount = 0
            
      for side in sides {
        switch side {
        case .above(
          row: let row,
          column: let col
        ): sideCount += (sides.contains(.above(row: row, column: col - 1))) ? 0 : 1
        case .below(
          row: let row,
          column: let col
        ): sideCount += (sides.contains(.below(row: row, column: col - 1))) ? 0 : 1
        case .left(
          row: let row,
          column: let col
        ): sideCount += (sides.contains(.left(row: row - 1, column: col))) ? 0 : 1
        case .right(
          row: let row,
          column: let col
        ): sideCount += (sides.contains(.right(row: row - 1, column: col))) ? 0 : 1
        }
      }
      
      return (area, sideCount)
    }
    
    var sum = 0
    
    for unchecked in map.indices where !checked.contains(unchecked) {
      let (area, perimeter) = check(from: unchecked)
      sum += (area * perimeter)
    }
    return sum
  }
}
