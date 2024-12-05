import Algorithms

struct Day05: AdventDay {
  var data: String
  
  init(data: String) {
    self.data = data
    
    rules = {
      return data.split(separator: "\n\n").first!
        .split(separator: "\n").map { line in
          let split = line.split(separator: "|")
          return (Int(split[0])!, before: Int(split[1])!)
        }
    }()
    
    updates = {
      let rawUpdates: String = String(data.split(separator: "\n\n")[1])
      
      let lines: [Substring] = rawUpdates.split(separator: "\n")
      
      return lines.map { line in
        line.split(separator: ",").map({ Int($0)! })
      }
    }()
  }
  
  var rules: [(Int, before: Int)]
  
  var updates: [[Int]]

  func part1() -> Any {
    var middleSum = 0
    
    func noneAreAfter(page: Int, at index: Int, in update: [Int]) -> Bool {
      let pertinentRules = rules.filter({$0.0 == page})
      for prevPage in update[..<index] {
        guard !pertinentRules.contains(
          where: { $0.before == prevPage }
        ) else { return false }
      }
      return true
    }
    
    updatesLoop: for update in updates {
      for (index, page) in update.enumerated() {
        guard noneAreAfter(page: page, at: index, in: update)
        else { continue updatesLoop }
      }
      let middleIndex = update.count / 2
      middleSum += update[middleIndex]
    }
    return middleSum
  }

  func part2() -> Any {
    return 0
  }
}
