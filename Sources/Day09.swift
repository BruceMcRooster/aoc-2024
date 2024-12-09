import Algorithms

struct Day09: AdventDay {
  var data: String

  func part1() -> Any {
    func expand(_ input: String) -> [Int?] {
      var result = [Int?]()
      let toNums = input.map { Int(String($0))! }
      for (index, num) in toNums.enumerated() {
        if index % 2 == 0 { // data chunk
          result += Array(repeating: index / 2, count: num)
        } else { // space chunk
          result += Array(repeating: nil, count: num)
        }
      }
      return result
    }
    
    func shiftEndToBeginning(_ input: [Int?]) -> [Int?] {
      func swap(_ input: inout [Int?], index first: Int, with second: Int) {
        let tmp = input[first]
        input[first] = input[second]
        input[second] = tmp
      }
      
      var copy = input
      
      var end = copy.index(before: input.endIndex)
      var start = copy.startIndex
      
      while start < end {
        guard copy[end] != nil  else {
          end = copy.index(before: end)
          continue
        }
        guard copy[start] == nil else {
          start = copy.index(after: start)
          continue
        }
        swap(&copy, index: start, with: end)
      }
      return copy
    }
    
    func computeChecksum(of input: [Int?]) -> Int {
      assert(input.firstIndex(of: nil)! > input.lastIndex { $0 != nil }!)
      
      var sum = 0
      for (index, num) in input.enumerated() {
        guard let num else { break } // Ran out of numbers
        sum += num * index
      }
      return sum
    }
    
    let expanded = expand(data.trimmingCharacters(in: .whitespacesAndNewlines))
    let shifted = shiftEndToBeginning(expanded)
    return computeChecksum(of: shifted)
  }

  func part2() -> Any {
    return 0
  }
}
