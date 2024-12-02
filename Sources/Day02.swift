import Algorithms

struct Day02: AdventDay {
  var data: String

  var levels: [[Int]] {
    data.split(separator: "\n").map { line in
      line.split(separator: " ").map { Int($0)! }
    }
  }
  
  func part1() -> Any {
    var count = 0
    levels: for level in levels {
      var decreasing: Bool? = nil
      
      for i in 1..<level.count {
        if decreasing == nil {
          guard abs(level[i] - level[i-1]) <= 3 && level[i] != level[i-1] else {
            continue levels
          }
          decreasing = level[i] < level[i-1]
        } else {
          guard decreasing == (level[i] < level[i-1]) else {
            continue levels
          }
          guard abs(level[i] - level[i-1]) <= 3  && level[i] != level[i-1] else {
            continue levels
          }
        }
      }
      
      assert(level.count > 1 || (level.count == 1 && decreasing == nil))
      
      count += 1
    }
    return count
  }

  func part2() -> Any {
    return 0
  }
}
