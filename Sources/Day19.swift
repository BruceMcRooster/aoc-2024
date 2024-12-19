import Algorithms

struct Day19: AdventDay {
  var data: String
  
  let towels: [Character : Set<[Character]>]
  let patterns: Set<[Character]>
  
  init(data: String) {
    self.data = data
    
    let split = data.split(separator: "\n\n", maxSplits: 1)
    
    var towels: [Character : Set<[Character]>] = [
      "w": [],
      "u": [],
      "b": [],
      "r": [],
      "g": []
    ]
    for towel in split[0].split(separator: ", ") {
      towels[towel.first!]!.insert(Array(towel))
    }
    
    self.towels = towels
    
    self.patterns = Set(
      split[1]
        .split(separator: "\n")
        .filter({ !$0.isEmpty })
        .map({ Array($0) })
    )
  }

  func part1() -> Any {
    var solvablePatterns: Set<ArraySlice<Character>> = []
    var unsolvablePatterns: Set<ArraySlice<Character>> = []
    
    func checkForPattern(_ pattern: ArraySlice<Character>) -> Bool {
      assert(pattern.count > 0)
      
      if solvablePatterns.contains(pattern) {
        return true
      }
      if unsolvablePatterns.contains(pattern) {
        return false
      }
      
      let possibleTowels = towels[pattern.first!]!.filter({ pattern.starts(with: $0) })
      
      if possibleTowels.count == 0 {
        unsolvablePatterns.insert(pattern)
        return false
      }
      
      for towel in possibleTowels {
        let nextPattern = pattern.suffix(from: pattern.index(pattern.startIndex, offsetBy: towel.count))
        
        if nextPattern.isEmpty {
          solvablePatterns.insert(pattern)
          return true
        }

        if checkForPattern(nextPattern) {
          solvablePatterns.insert(pattern)
          return true
        }
      }
      unsolvablePatterns.insert(pattern)
      return false
    }
    
    var count = 0
    for pattern in patterns {
      if checkForPattern(ArraySlice(pattern)) {
        count += 1
      }
    }
    return count
  }

  func part2() -> Any {
    return 0
  }
}
