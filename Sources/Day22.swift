import Algorithms

struct Day22: AdventDay {
  var data: String
  
  var initialSecretNumbers: [Int]
  
  init(data: String) {
    self.data = data
    self.initialSecretNumbers = data.split(separator: "\n").compactMap { Int(String($0)) }
  }

  func part1() -> Any {
    func increment(secretNumber: Int) -> Int {
      let pruneMod = 16777216
      
      let step1 = ((secretNumber * 64) ^ secretNumber) % pruneMod
      let step2 = ((step1 / 32) ^ step1) % pruneMod
      let step3 = ((step2 * 2048) ^ step2) % pruneMod
      
      return step3
    }
    
    var secretNumbers: [Int] = initialSecretNumbers
    
    for _ in 1...2000 {
      secretNumbers = secretNumbers.map(increment)
    }
    return secretNumbers.reduce(0, +)
  }

  func part2() -> Any {
    return 0
  }
}
