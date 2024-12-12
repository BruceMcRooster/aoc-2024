import Algorithms
import DequeModule

struct Day12: AdventDay {
  
  var data: String

  func part1() -> Any {
    let map: [Character] = data.filter { $0 != "\n" }
    let width = data.distance(from: data.startIndex, to: data.firstIndex(of: "\n")!)
    
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
    return 0
  }
}
