import Algorithms

struct Day01: AdventDay {
  var data: String
  
  var lists: ([Int], [Int]) {
    return data.components(separatedBy: .newlines)
      .filter { !$0.isEmpty }
      .reduce(([Int](), [Int]())) { partialResult, line in
        let numbers = line.components(separatedBy: "   ").map { Int($0)! }
        return (partialResult.0 + [numbers[0]], partialResult.1 + [numbers[1]])
      }
  }

  func part1() -> Any {
    return zip(lists.0.sorted(), lists.1.sorted()).reduce(0) { partialResult, input in
      partialResult + abs(input.0 - input.1)
    }
  }

  func part2() -> Any {
    var countLookup = [Int: Int]()
    for item in lists.1 {
      countLookup[item, default: 0] += 1
    }
    return lists.0.reduce(0) { partialResult, item in
      partialResult + (countLookup[item] ?? 0) * item
    }
  }
}
