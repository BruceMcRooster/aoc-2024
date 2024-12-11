import Algorithms

struct Day11: AdventDay {
  var data: String
  
  var input = [Int:Int]()
  
  init(data: String) {
    self.data = data
    for num in data
      .trimmingSuffix(while: \.isNewline)
      .split(separator: " ")
      .map({ Int(String($0))! }) {
      input[num] = input[num, default: 0] + 1
    }
  }
  
  func step(_ table: [Int:Int]) -> [Int:Int] {
    var copy = [Int:Int]()
    
    for (num, count) in table {
      switch num {
      case 0: copy[1, default: 0] += count
      case let x where x.countDigits() % 2 == 0: {
        let split = x.countDigits() / 2
        let (left, right) = x.split(at: split)
        copy[left, default: 0] += count
        copy[right, default: 0] += count
      }()
      default: copy[num * 2024, default: 0] += count
      }
    }
    return copy
  }
  
  func part1() -> Any {
    var inputCopy = input
    
    for _ in 0..<25 {
      inputCopy = step(inputCopy)
    }
    var totalCount = 0
    for count in inputCopy.values { totalCount += count }
    return totalCount
  }

  func part2() -> Any {
    var inputCopy = input
    
    for _ in 0..<75 {
      inputCopy = step(inputCopy)
    }
    var totalCount = 0
    for count in inputCopy.values { totalCount += count }
    return totalCount
  }
}

extension Int {
  func countDigits() -> Int {
    if self < 10 {
      return 1
    } else {
      return 1 + (self/10).countDigits()
    }
  }
  
  func split(at index: Int) -> (first: Int, second: Int) {
    var multiplier: Int = 1
    for _ in 0..<index { multiplier *= 10 }
    let first = self / multiplier
    let second = self % multiplier
    return (first, second)
  }
}
