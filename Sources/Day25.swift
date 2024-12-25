import Algorithms

struct Day25: AdventDay {
  var data: String

  struct Combination: Hashable {
    let isLock: Bool
    
    let col1: UInt8
    let col2: UInt8
    let col3: UInt8
    let col4: UInt8
    let col5: UInt8
    
    init(fromData input: some StringProtocol) {
      self.isLock = input.first! == "#"
      
      var col1: UInt8?
      var col2: UInt8?
      var col3: UInt8?
      var col4: UInt8?
      var col5: UInt8?
      
      for (lineNum, line) in input.split(separator: "\n").enumerated() {
        assert(line.count == 5, "Got malformed line \(line)")
        
        if self.isLock {
          if col1 == nil, line[line.index(line.startIndex, offsetBy: 0)] == "." { col1 = UInt8(lineNum - 1) }
          if col2 == nil, line[line.index(line.startIndex, offsetBy: 1)] == "." { col2 = UInt8(lineNum - 1) }
          if col3 == nil, line[line.index(line.startIndex, offsetBy: 2)] == "." { col3 = UInt8(lineNum - 1) }
          if col4 == nil, line[line.index(line.startIndex, offsetBy: 3)] == "." { col4 = UInt8(lineNum - 1) }
          if col5 == nil, line[line.index(line.startIndex, offsetBy: 4)] == "." { col5 = UInt8(lineNum - 1) }
        } else {
          if col1 == nil, line[line.index(line.startIndex, offsetBy: 0)] == "#" { col1 = UInt8(6 - lineNum) }
          if col2 == nil, line[line.index(line.startIndex, offsetBy: 1)] == "#" { col2 = UInt8(6 - lineNum) }
          if col3 == nil, line[line.index(line.startIndex, offsetBy: 2)] == "#" { col3 = UInt8(6 - lineNum) }
          if col4 == nil, line[line.index(line.startIndex, offsetBy: 3)] == "#" { col4 = UInt8(6 - lineNum) }
          if col5 == nil, line[line.index(line.startIndex, offsetBy: 4)] == "#" { col5 = UInt8(6 - lineNum) }
        }
      }
      
      self.col1 = col1!
      self.col2 = col2!
      self.col3 = col3!
      self.col4 = col4!
      self.col5 = col5!
    }
    
    func fits(_ other: Combination) -> Bool {
      assert(self.isLock != other.isLock)
      
      return self.col1 + other.col1 <= 5
          && self.col2 + other.col2 <= 5
          && self.col3 + other.col3 <= 5
          && self.col4 + other.col4 <= 5
          && self.col5 + other.col5 <= 5
    }
  }
  
  func part1() -> Any {
    let combinations = Set(data.split(separator: "\n\n").map(Combination.init))
    
    let locks = combinations.filter(\.isLock)
    let keys = combinations.subtracting(locks)
    
    var count = 0
    
    for key in keys {
      for lock in locks {
        if key.fits(lock) { count += 1 }
      }
    }
    
    return count
  }

  func part2() -> Any {
    return 0
  }
}
