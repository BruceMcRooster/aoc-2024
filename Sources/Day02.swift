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
      if levelOkay(level).0 {
        count += 1
      }
    }
    return count
  }

  // Returns if level is fine, throws the first problematic index if not
  func levelOkay(_ level: [Int]) -> (Bool, Int) {
    var decreasing: Bool? = nil
    
    for i in 1..<level.count {
      if decreasing == nil {
        guard abs(level[i] - level[i-1]) <= 3 && level[i] != level[i-1] else {
          return (false, i)
        }
        decreasing = level[i] < level[i-1]
      } else {
        guard decreasing == (level[i] < level[i-1]) else {
          return (false, i)
        }
        guard abs(level[i] - level[i-1]) <= 3  && level[i] != level[i-1] else {
          return (false, i)
        }
      }
    }
    
    assert(level.count > 1 || (level.count == 1 && decreasing == nil))
    return (true, -1)
  }
  
  func part2() -> Any {
    var count = 0
    levels: for level in levels {
      guard !levelOkay(level).0 else {
        count += 1
        continue levels
      }
      
      for i in level.indices {
        var copy = level
        copy.remove(at: i)
        guard !levelOkay(copy).0 else {
          count += 1
          continue levels
        }
      }
    }
    return count
  }
}
