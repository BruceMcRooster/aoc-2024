import Algorithms
import RegexBuilder

struct Day17: AdventDay {
  var data: String

  func part1() -> Any {
    let registerAMatch = Reference<Int>()
    let registerBMatch = Reference<Int>()
    let registerCMatch = Reference<Int>()
    
    let programMatch = Reference<Array<Int>>()
    
    let inputRegex = Regex {
      "Register A: "
      Capture(as: registerAMatch) {
        Optionally("-")
        OneOrMore(.digit)
      } transform: { Int(String($0))! }
      
      "\nRegister B: "
      Capture(as: registerBMatch) {
        Optionally("-")
        OneOrMore(.digit)
      } transform: { Int(String($0))! }
      
      "\nRegister C: "
      Capture(as: registerCMatch) {
        Optionally("-")
        OneOrMore(.digit)
      } transform: { Int(String($0))! }
      
      "\n\nProgram: "
      Capture(
        OneOrMore(.anyNonNewline),
        as: programMatch,
        transform: { $0.split(separator: ",").map({ Int($0)! }) }
      )
    }
    
    let match = data.firstMatch(of: inputRegex)!
    
    var registerA = match[registerAMatch]
    var registerB = match[registerBMatch]
    var registerC = match[registerCMatch]
    let program = match[programMatch]
    
    var programPointer = 0
    
    var output = [Int]()
    
    while programPointer < program.endIndex {
      let currOperation = program[programPointer]
      
      let literalOperand = program[programPointer + 1]
      
      // This is a getter so we only error for 7 if something actually tries to access
      var comboOperand: Int {
        switch literalOperand {
        case 0...3: literalOperand
        case 4: registerA
        case 5: registerB
        case 6: registerC
        default: fatalError("Invalid combo operand: \(literalOperand)")
        }
      }
      
      switch currOperation {
      case 0: {
        let numerator = registerA
        let denominator = (comboOperand >= 0) ? 1 << comboOperand : 0 // 2^(comboOperand)
        registerA = numerator / denominator
        programPointer += 2
      }()
      case 1: {
        registerB = registerB ^ literalOperand
        programPointer += 2
      }()
      case 2: {
        registerB = comboOperand % 8
        programPointer += 2
      }()
      case 3: {
        if registerA != 0 {
          programPointer = literalOperand
        } else {
          programPointer += 2
        }
      }()
      case 4: {
        registerB = registerB ^ registerC
        programPointer += 2
      }()
      case 5: {
        output.append(comboOperand % 8)
        programPointer += 2
      }()
      case 6: {
        let numerator = registerA
        let denominator = (comboOperand >= 0) ? 1 << comboOperand : 0 // 2^(comboOperand)
        registerB = numerator / denominator
        programPointer += 2
      }()
      case 7: {
        let numerator = registerA
        let denominator = (comboOperand >= 0) ? 1 << comboOperand : 0 // 2^(comboOperand)
        registerC = numerator / denominator
        programPointer += 2
      }()
      default: fatalError("Invalid operation: \(currOperation)")
      }
    }
    
    return output.map(String.init).joined(separator: ",")
  }

  func part2() -> Any {
    return 0
  }
}
