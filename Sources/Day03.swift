import Algorithms

struct Day03: AdventDay {
  var data: String

  func part1() -> Any {
    let matches = data.matches(of: /mul\((?<num1>\d+),(?<num2>\d+)\)/)
    
    var sum = 0
    
    for match in matches {
      sum += Int(match.output.num1)! * Int(match.output.num2)!
    }
    return sum
  }

  func part2() -> Any {
    return 0
  }
}
