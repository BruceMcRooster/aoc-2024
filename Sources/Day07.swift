import Algorithms

struct Day07: AdventDay {
  var data: String
  
  var callibrations: [Calibration]
  
  init(data: String) {
    self.data = data
    self.callibrations = data
      .split(separator: "\n")
      .filter({!$0.isEmpty})
      .map({Calibration(fromLine: String($0))})
  }
  
  struct Calibration {
    let sum: Int
    let values: [Int]
    
    init(fromLine line: String) {
      let split = line.split(separator: ": ", maxSplits: 2)
      
      self.sum = Int(split.first!)!
      self.values = split.last!
        .split(separator: " ")
        .map({ Int($0)! })
    }
  }

  enum Operator {
    case add, multiply, combine
    
    func operate(_ a: Int, _ b: Int) -> Int {
      switch self {
      case .add: return a + b
      case .multiply: return a * b
      case .combine: return {
        let digitCount = String(b).count
        var aMultiplier = 1
        for _ in 0..<digitCount {
          aMultiplier *= 10
        }
        
        return a * aMultiplier + b
      }()
      }
    }
  }
  
  func part1() -> Any {
    func canWork(_ calibration: Calibration) -> Bool {
      var withoutFirst: [Int] = calibration.values
      withoutFirst.removeFirst()
      
      for numMultiplies in 0...withoutFirst.count {
        let operators: [Operator] = Array(
          repeating: .multiply,
          count: numMultiplies
        ) + Array(
          repeating: .add,
          count: withoutFirst.count - numMultiplies
        )
        
        assert(operators.count == withoutFirst.count)
        
        
        
        for opSet in operators.uniquePermutations() {
          var result = calibration.values.first!
          for (`operator`, num) in zip(opSet, withoutFirst) {
            result = `operator`.operate(result, num)
          }
          if result == calibration.sum {
            return true
          }
        }
        
        
      }
      return false
    }
    
    var sum = 0
    
    for callibration in callibrations {
      if canWork(callibration) {
        sum += callibration.sum
      }
    }
    
    return sum
  }

  func part2() -> Any {
    func canWork(_ calibration: Calibration) -> Bool {
      var withoutFirst: [Int] = calibration.values
      withoutFirst.removeFirst()
      
      for numCombines in 0...withoutFirst.count {
        for numMultiplies in 0...(withoutFirst.count-numCombines) {
          let operators: [Operator] = Array(
            repeating: .multiply,
            count: numMultiplies
          ) + Array(
            repeating: .add,
            count: withoutFirst.count - numMultiplies - numCombines
          ) + Array(
            repeating: .combine,
            count: numCombines
          )
          
          assert(operators.count == withoutFirst.count)
          
          
          
          for opSet in operators.uniquePermutations() {
            var result = calibration.values.first!
            for (`operator`, num) in zip(opSet, withoutFirst) {
              result = `operator`.operate(result, num)
            }
            if result == calibration.sum {
              return true
            }
          }
          
        }
      }
      return false
    }
    
    var sum = 0
    
    for callibration in callibrations {
      if canWork(callibration) {
        sum += callibration.sum
      }
    }
    
    return sum
  }
}
