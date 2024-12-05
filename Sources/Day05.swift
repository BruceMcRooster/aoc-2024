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
  
  func noneAreAfter(page: Int, at index: Int, in update: [Int]) -> Bool {
    let pertinentRules = rules.filter({$0.0 == page})
    for prevPage in update[..<index] {
      guard !pertinentRules.contains(
        where: { $0.before == prevPage }
      ) else { return false }
    }
    return true
  }
  
  func part1() -> Any {
    var middleSum = 0
    
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
    var middleSum = 0
    
    updatesLoop: for update in updates {
      var allFine = true
      for (index, page) in update.enumerated() {
        allFine = allFine ? noneAreAfter(page: page, at: index, in: update) : false
      }
      if allFine { continue updatesLoop }
      let middleIndex = update.count / 2
      let sorted = update.sorted(by: { first, second in
        let firstPertinent = rules.filter({$0.0 == first})
        if firstPertinent.contains(where: { $0.before == second }) { return true }
        let secondPertinent = rules.filter({$0.0 == second})
        if secondPertinent.contains(where: { $0.before == first }) { return false }
        
        // This means my assumption that every page would somehow be marked
        // as explicitly related to another via one of them having a rule
        // was false, so I have to completely change the logic here.
        // Hopefully I never see this error 🙏
        fatalError("Couldn't find how to order \(first) and \(second) 😭")
      })
      assert(sorted.count == update.count)
      middleSum += sorted[middleIndex]
    }
    return middleSum
  }
}
