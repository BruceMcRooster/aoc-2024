import Algorithms

struct Day10: AdventDay {
  var data: String
  
  let map: [Int]
  let width: Int
  let height: Int
  
  init(data: String) {
    self.data = data
    self.map = data.filter { $0 != "\n" }.map { Int(String($0))! }
    self.width = data.distance(from: data.startIndex, to: data.firstIndex(of: "\n")!)
    self.height = data.split(separator: "\n").filter { !$0.isEmpty }.count
  }

  func part1() -> Any {
    func findNines(from index: Int, addingTo set: inout Set<Int>) {
      let curr = map[index]
      
      if curr == 9 {
        set.insert(index)
        return
      }
      
      if let left = (index % width == 0) ? nil : index - 1 {
        if map[left] == curr + 1 {
          findNines(from: left, addingTo: &set)
        }
      }
      if let right = (index % width == width - 1) ? nil : index + 1 {
        if map[right] == curr + 1 {
          findNines(from: right, addingTo: &set)
        }
      }
      if let up = (index / width == 0) ? nil : index - width {
        if map[up] == curr + 1 {
          findNines(from: up, addingTo: &set)
        }
      }
      if let down = (index / width == height - 1) ? nil : index + width {
        if map[down] == curr + 1 {
          findNines(from: down, addingTo: &set)
        }
      }
    }
    
    var count = 0
    for index in map.indices {
      if map[index] == 0 {
        var set = Set<Int>()
        findNines(from: index, addingTo: &set)
        count += set.count
      }
    }
    return count
  }

  func part2() -> Any {
    func countNines(from index: Int) -> Int {
      let curr = map[index]
      
      if curr == 9 {
        return 1
      }
      
      var count = 0
      
      if let left = (index % width == 0) ? nil : index - 1 {
        if map[left] == curr + 1 {
          count += countNines(from: left)
        }
      }
      if let right = (index % width == width - 1) ? nil : index + 1 {
        if map[right] == curr + 1 {
          count += countNines(from: right)
        }
      }
      if let up = (index / width == 0) ? nil : index - width {
        if map[up] == curr + 1 {
          count += countNines(from: up)
        }
      }
      if let down = (index / width == height - 1) ? nil : index + width {
        if map[down] == curr + 1 {
          count += countNines(from: down)
        }
      }
      return count
    }
    
    var count = 0
    for index in map.indices {
      if map[index] == 0 {
        count += countNines(from: index)
      }
    }
    return count
  }
}
