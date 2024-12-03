import Algorithms

struct Day03: AdventDay {
  var data: String

  func part1() -> Any {
    return sumOfMults(in: data)
  }
  
  func sumOfMults(in checkData: String) -> Int {
    let matches = checkData.matches(of: /mul\((?<num1>\d+),(?<num2>\d+)\)/)
    
    var sum = 0
    
    for match in matches {
      sum += Int(match.output.num1)! * Int(match.output.num2)!
    }
    return sum
  }

  func part2() -> Any {
    let controlStatements = data.matches(of: /do(n't)?\(\)/)
    
    if controlStatements.isEmpty {
      return 0
    }
    
    var sum = sumOfMults(
      in: String(data[data.startIndex..<controlStatements.first!.range.lowerBound])
    )
    
    var matchIndex = controlStatements.startIndex
    
    while matchIndex < controlStatements.endIndex {
      let match = controlStatements[matchIndex]
      
      if match.output.1 == nil { // Matched a "do" (without "n't")
        let nextDontIndex = controlStatements.firstIndex { otherMatch in
          otherMatch.range.lowerBound > match.range.upperBound
            && otherMatch.output.1 != nil // Matches a "don't"
        }
        
        let endSubstringIndex = if nextDontIndex != nil {
          controlStatements[nextDontIndex!].range.lowerBound
        } else { data.endIndex }
        
        let nextSubstring: Substring = data[match.range.upperBound..<endSubstringIndex]
        
        sum += sumOfMults(in: String(nextSubstring))
        
        if nextDontIndex != nil {
          matchIndex = nextDontIndex!
        } else {
          matchIndex = controlStatements.endIndex
        }
      }
      matchIndex += 1
    }
    
    return sum
  }
}
