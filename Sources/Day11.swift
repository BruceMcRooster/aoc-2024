import Algorithms

struct Day11: AdventDay {
  var data: String
  
  let input: [Int]
  
  init(data: String) {
    self.data = data
    self.input = data
      .trimmingSuffix(while: \.isNewline)
      .split(separator: " ")
      .map { Int(String($0))! }
  }

  func part1() -> Any {
    var inputCopy = input
    
    func step(_ array: inout [Int]) {
      for index in array.indices.reversed() {
        switch array[index] {
        case 0: array[index] = 1
        case let x where String(x).count % 2 == 0: {
          let string = String(x)
          let count = string.count
          let midpoint = string.index(string.startIndex, offsetBy: count / 2)
          let first = string[string.startIndex..<midpoint]
          let second = string[midpoint..<string.endIndex]
          array.replaceSubrange(index...index, with: [Int(String(first))!, Int(String(second))!])
        }()
        default: array[index] *= 2024
        }
      }
    }
    
    for _ in 0..<25 { step(&inputCopy) }
    return inputCopy.count
  }

  func part2() -> Any {
    return 0
  }
}
