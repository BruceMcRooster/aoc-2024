import Algorithms

struct Day24: AdventDay {
  var data: String
  
  enum Gate: Hashable {
    case AND(Substring, Substring)
    case OR(Substring, Substring)
    case XOR(Substring, Substring)
    
    func evaluate(_ leftValue: Bool, _ rightValue: Bool) -> Bool {
      switch self {
      case .AND(_, _):
        leftValue && rightValue
      case .OR(_, _):
        leftValue || rightValue
      case .XOR(_, _):
        (!leftValue && rightValue) || (leftValue && !rightValue)
      }
    }
    
    func getLeftAndRightWires() -> (left: Substring, right: Substring) {
      switch self {
      case .AND(let left, let right):
        (left, right)
      case .OR(let left, let right):
        (left, right)
      case .XOR(let left, let right):
        (left, right)
      }
    }
  }
  
  var gates: [Substring : Gate]
  var initialValues: [Substring : Bool]
  
  init(data: String) {
    self.data = data
    
    let chunks = data.split(separator: "\n\n", maxSplits: 1)
    
    let (initialValuesData, gatesData) = (chunks.first!, chunks.last!)
    
    self.initialValues = [Substring : Bool]()
    
    for wireLine in initialValuesData.split(separator: "\n") where !wireLine.isEmpty {
      let wire = wireLine.prefix(while: { $0 != ":" })
      let value = wireLine.last!
      
      assert(value == "0" || value == "1", "Parsed in an invalid wire value from line \(wireLine)")
      
      let parsedValue = value == "0" ? false : true
      
      self.initialValues[wire] = parsedValue
    }
    
    self.gates = [Substring : Gate]()
    
    let lineRegex = /(?<leftinput>\w+) (?<gate>(AND|OR|XOR)) (?<rightinput>\w+) -> (?<output>\w+)/
    
    for gateLine in gatesData.split(separator: "\n") where !gateLine.isEmpty {
      let (_, leftinput, gate, _, rightinput, output) = try! lineRegex.wholeMatch(in: gateLine)!.output
      
      self.gates[output] = switch gate {
      case "AND": .AND(leftinput, rightinput)
      case "OR": .OR(leftinput, rightinput)
      case "XOR": .XOR(leftinput, rightinput)
      default: fatalError("Somehow matched to invalid gate \(gate)")
      }
    }
  }
  
  func calcOutput(of gateChanges: [Substring : Gate] = [:]) -> Int {
    var wireValues = self.initialValues
    
    func getValueForWire(_ wire: Substring) -> Bool {
      guard wireValues[wire] == nil else { return wireValues[wire]! }
      
      let gate = gateChanges[wire] ?? gates[wire]!
      
      let (leftWire, rightWire) = gate.getLeftAndRightWires()
      
      let output = gate.evaluate(getValueForWire(leftWire), getValueForWire(rightWire))
      
      wireValues[wire] = output
      return output
    }
    
    var zIndices = [UInt8 : Bool]()
    
    for zWire in gates.keys.filter({ $0.first! == "z" }) {
      let wireIndex = UInt8(zWire.dropFirst())!
      zIndices[wireIndex] = getValueForWire(zWire)
    }
    
    var result = 0
    
    zIndices.forEach { (wireIndex, wireValue) in
      result |= (wireValue == true) ? (1 << wireIndex) : 0
    }
    return result
  }
  
  func part1() -> Any {
    return calcOutput()
  }

  func part2() -> Any {
    let correctOutput: Int = {
      let x = {
        var result = 0
        for xWire in initialValues.filter({ $0.key.first! == "x" }) {
          result |= xWire.value ? (1 << Int(xWire.key.dropFirst())!) : 0
        }
        return result
      }()
      let y = {
        var result = 0
        for yWire in initialValues.filter({ $0.key.first! == "y" }) {
          result |= yWire.value ? (1 << Int(yWire.key.dropFirst())!) : 0
        }
        return result
      }()
      
      return x + y
    }()
    
    // Based on https://www.reddit.com/r/adventofcode/comments/1hla5ql/2024_day_24_part_2_a_guide_on_the_idea_behind_the/
    
    let largestBit = String(UInt8(initialValues.keys.sorted().last!.dropFirst())! + 1)
        
    var suspiciousGates = Set<Substring>()
    
    func isGateFine(gate: Gate, outputWire: Substring) -> Bool {
      let isConnectedToZ: Bool = outputWire.first! == "z"
      let isXOR: Bool = if case .XOR(_, _) = gate { true } else { false }
      let isXY: Bool = (gate.getLeftAndRightWires().left.first! == "x" && gate.getLeftAndRightWires().right.first! == "y")
      || (gate.getLeftAndRightWires().left.first! == "y" && gate.getLeftAndRightWires().right.first! == "x")
      
      if gate.getLeftAndRightWires().left.dropFirst() == "00"
          && gate.getLeftAndRightWires().right.dropFirst() == "00" {
        return true
      }

      if isConnectedToZ && !isXOR && !(outputWire.dropFirst() == largestBit) {
        return false
      }
      
      guard !isConnectedToZ else { return true }
      
      if !isXY && isXOR {
        return false
      }
      
      let outputUsed = gates.filter({
        $0.value.getLeftAndRightWires().left == outputWire || $0.value.getLeftAndRightWires().right == outputWire
      })
      
      guard outputUsed.count > 0 else {
        return false
      }
      
      if isXOR && isXY && !outputUsed.contains(
        where: { if case .XOR(_, _) = $0.value { true } else { false } }
      ) {
        return false
      }
      
      if case .AND(_, _) = gate, !outputUsed.contains(
        where: { if case .OR(_, _) = $0.value { true } else { false } }
      ) {
        return false
      }
      
      return true
    }
    
    for gate in gates {
      if !isGateFine(gate: gate.value, outputWire: gate.key) {
        suspiciousGates.insert(gate.key)
      }
    }
    
    assert(suspiciousGates.count == 8)
    
    // TODO: Add back when it won't overflow the call stack
    
//    func checkSuccess() -> Bool {
//      for possibleSwaps in suspiciousGates.permutations() {
//        let swaps = possibleSwaps.chunks(ofCount: 2)
//        
//        var tryGates = [Substring : Gate]()
//        for swap in swaps {
//          tryGates[swap.first!] = gates[swap.last!]!
//          tryGates[swap.last!] = gates[swap.first!]!
//        }
//        if calcOutput(of: tryGates) == correctOutput {
//          print("Correct Pairs were \(swaps.map { ($0.first!, $0.last!) })")
//          return true
//        }
//      }
//      return false
//    }
//    
//    guard checkSuccess() else {
//      fatalError("Something went terribly wrong")
//    }
    
    return suspiciousGates.sorted().joined(separator: ",")
  }
}
