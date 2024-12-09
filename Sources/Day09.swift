import Algorithms

struct Day09: AdventDay {
  var data: String
  
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
  
  func computeChecksum(of input: [Int?]) -> Int {
    var sum = 0
    for (index, num) in input.enumerated() {
      guard let num else { continue } // Ran out of numbers
      sum += num * index
    }
    return sum
  }

  func part1() -> Any {
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
    
    let expanded = expand(data.trimmingCharacters(in: .whitespacesAndNewlines))
    let shifted = shiftEndToBeginning(expanded)
    return computeChecksum(of: shifted)
  }

  func part2() -> Any {
    func shiftFilesToOpenSpace(_ input: [Int?]) -> [Int?] {
      var copy = input
      
      func fileRanges(_ input: [Int?]) -> (files: [Range<Int>], spaces: [Range<Int>]) {
        var files = [Range<Int>]()
        var spaces = [Range<Int>]()
        
        var currIndex = input.startIndex
        while currIndex < input.endIndex {
          let fileId = input[currIndex]
          
          var continuedIndex = currIndex
          while continuedIndex < input.endIndex && input[continuedIndex] == fileId {
            continuedIndex += 1
          }
          if fileId != nil {
            files.append(currIndex..<continuedIndex)
          } else {
            spaces.append(currIndex..<continuedIndex)
          }
          currIndex = continuedIndex
        }
        return (files, spaces)
      }
      
      var (fileRanges, spaceRanges) = fileRanges(copy)
      
      for fileRange in fileRanges.reversed() {
        if let firstOpenSpaceIndex = spaceRanges.firstIndex(
          where: { $0.upperBound <= fileRange.lowerBound && $0.count >= fileRange.count }
        ) {
          let boundedToMax = spaceRanges[firstOpenSpaceIndex].lowerBound..<min(
            spaceRanges[firstOpenSpaceIndex].upperBound,
            spaceRanges[firstOpenSpaceIndex].lowerBound + fileRange.count
          )
          copy.replaceSubrange(boundedToMax, with: copy[fileRange])
          
          if boundedToMax.upperBound < spaceRanges[firstOpenSpaceIndex].upperBound {
            let newSpaceRange = boundedToMax.upperBound..<spaceRanges[firstOpenSpaceIndex].upperBound
            spaceRanges[firstOpenSpaceIndex] = newSpaceRange
          } else {
            spaceRanges.remove(at: firstOpenSpaceIndex)
          }
          copy.replaceSubrange(fileRange, with: Array(repeating: nil, count: fileRange.count))
          spaceRanges.append(fileRange)
        }
      }
      
      return copy
    }
    
    let expanded = expand(data.trimmingCharacters(in: .whitespacesAndNewlines))
    let shifted = shiftFilesToOpenSpace(expanded)
    return computeChecksum(of: shifted)
  }
}
