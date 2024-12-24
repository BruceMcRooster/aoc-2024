import Algorithms

struct Day24: AdventDay {
  var data: String
  
  func part1() -> Any {
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
    }
    
    let chunks = data.split(separator: "\n\n", maxSplits: 1)
    
    let (initialValuesData, gatesData) = (chunks.first!, chunks.last!)
    
    var wireValues = [Substring : Bool]()
    
    for wireLine in initialValuesData.split(separator: "\n") where !wireLine.isEmpty {
      let wire = wireLine.prefix(while: { $0 != ":" })
      let value = wireLine.last!
      
      assert(value == "0" || value == "1", "Parsed in an invalid wire value from line \(wireLine)")
      
      let parsedValue = value == "0" ? false : true
      
      wireValues[wire] = parsedValue
    }
    
    var gates = [Substring : Gate]()
    
    let lineRegex = /(?<leftinput>\w+) (?<gate>(AND|OR|XOR)) (?<rightinput>\w+) -> (?<output>\w+)/
    
    for gateLine in gatesData.split(separator: "\n") where !gateLine.isEmpty {
      let (_, leftinput, gate, _, rightinput, output) = try! lineRegex.wholeMatch(in: gateLine)!.output
      
      gates[output] = switch gate {
      case "AND": .AND(leftinput, rightinput)
      case "OR": .OR(leftinput, rightinput)
      case "XOR": .XOR(leftinput, rightinput)
      default: fatalError("Somehow matched to invalid gate \(gate)")
      }
    }
    
    func getValueForWire(_ wire: Substring) -> Bool {
      guard wireValues[wire] == nil else { return wireValues[wire]! }
      
      guard let gate = gates[wire] else { fatalError("No gate found for \(wire)") }
      
      let (leftWire, rightWire) = switch gate {
      case .AND(let leftWire, let rightWire): (leftWire, rightWire)
      case .OR(let leftWire, let rightWire): (leftWire, rightWire)
      case .XOR(let leftWire, let rightWire): (leftWire, rightWire)
      }
      
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

  func part2() -> Any {
    return 0
  }
}
