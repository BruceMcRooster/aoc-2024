import Algorithms
import RegexBuilder

struct Day17: AdventDay {
  var data: String

  func readProgram() -> (registerA: Int, registerB: Int, registerC: Int, program: Array<Int>) {
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
    
    return (match[registerAMatch], match[registerBMatch], match[registerCMatch], match[programMatch])
  }
  
  func runProgram(registerA: inout Int, registerB: inout Int, registerC: inout Int, program: Array<Int>) -> [Int] {
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
    return output
  }
  
  func part1() -> Any {
    let programRead = readProgram()
    
    var registerA = programRead.registerA
    var registerB = programRead.registerB
    var registerC = programRead.registerC
    let program = programRead.program
    
    let output = runProgram(registerA: &registerA, registerB: &registerB, registerC: &registerC, program: program)
    
    return output.map(String.init).joined(separator: ",")
  }

  func part2() -> Any {
    let programRead = readProgram()
    let program = programRead.program
    
    assert(program.count > 1, "Can't search that short of a program")
    var minA = 1 << ((program.count - 1) * 3) // 8^(program.count - 1)
    
    let maxA = 1 << (program.count * 3) // 8^(program.count)
    
    var searchIndex = program.count - 1
    
    /* Brief explanation of the logic here:
     
    Two key observations:
        The outputs are of length k when A ∈ [8^(k-1), 8^k)
     
        As we increase, there is a pattern in the output of the program
        If x is some number we are looking for
        
        ...
        ****y
        ****x ---
        ...     repeats 8^(k-1) times, where k is length of strings in this segment
        ****x ---
        ****z
        ...
        
     Based on this, we can skip by 8^(k-1) every time until we find the end we are looking for.
     Then we can search within that for outputs ending in the two digits we are looking for,
     skipping by 8^(k-2) when we don't find it, then look for 3 digits skipping 8^(k-3), and so on.
     */
    
    
    while minA < maxA {
      var registerA = minA
      var registerB = programRead.registerB
      var registerC = programRead.registerC
      
      let output = runProgram(
        registerA: &registerA,
        registerB: &registerB,
        registerC: &registerC,
        program: program
      )
      
      // This has to be a full range match because it messed up 1 digit in my full test
      // when just comparing at each search index (output[searchIndex] == program[searchIndex])
      if output[searchIndex...] == program[searchIndex...] {
        searchIndex -= 1
        if searchIndex == -1 { break }
      } else {
        minA += 1 << ((program.count - 1 - (program.count - 1 - searchIndex)) * 3)
      }
    }
    
    var registerA = minA
    var registerB = programRead.registerB
    var registerC = programRead.registerC
    
    let output = runProgram(
      registerA: &registerA,
      registerB: &registerB,
      registerC: &registerC,
      program: program
    )
    
    if output == program {
      return minA
    }
    fatalError("Could not find program in output")
  }
}
