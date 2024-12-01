import Algorithms

struct Day01: AdventDay {
  var data: String
  
  var lists: ([Int], [Int]) {
    var list1 = [Int]()
    var list2 = [Int]()
    
    for line in data.components(separatedBy: .newlines) {
      if line.isEmpty { continue }
      let numbers = line.components(separatedBy: "   ").map { Int($0)! }
      assert(numbers.count == 2)
      list1.append(numbers[0])
      list2.append(numbers[1])
    }
    
    return (list1, list2)
  }

  func part1() -> Any {
    var sum = 0
    let list1 = lists.0.sorted()
    let list2 = lists.1.sorted()
        
    for i in 0..<list1.count {
      sum += abs(list1[i] - list2[i])
    }
    
    return sum
  }

  func part2() -> Any {
    var score = 0
    for item in lists.0 {
      let count = lists.1.count { $0 == item }
      score += item * count
    }
    return score
  }
}
