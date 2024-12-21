import Algorithms

struct Day21: AdventDay {
  var data: String

  func part1() -> Any {
    
    enum RobotInstruction: Character, CaseIterable {
      case up = "^"
      case down = "v"
      case left = "<"
      case right = ">"
      case press = "A"
    }
    
    struct Position: Hashable, AdditiveArithmetic {
      static var zero: Position { .init(0, 0) }
      
      let x: Int
      let y: Int
      
      init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
      }
      
      /*
       +---+---+
       | ^ | A |
       +---+---+---+
       | < | v | > |
       +---+---+---+
       */
      init(ofInstruction instruction: RobotInstruction) {
        let pos: (x: Int, y: Int) = switch instruction {
        case .up: (1, 0)
        case .left: (0, 1)
        case .down: (1, 1)
        case .right: (2, 1)
        case .press: (2, 0)
        }
        self.x = pos.x
        self.y = pos.y
      }
      
      /*
       +---+---+---+
       | 7 | 8 | 9 |
       +---+---+---+
       | 4 | 5 | 6 |
       +---+---+---+
       | 1 | 2 | 3 |
       +---+---+---+
       | 0 | A |
       +---+---+
       */
      init(ofKey keyCode: Character) {
        let pos: (x: Int, y: Int) = switch keyCode {
        case "7": (0, 0)
        case "8": (1, 0)
        case "9": (2, 0)
        case "4": (0, 1)
        case "5": (1, 1)
        case "6": (2, 1)
        case "1": (0, 2)
        case "2": (1, 2)
        case "3": (2, 2)
        case "0": (1, 3)
        case "A": (2, 3)
        default: fatalError("Invalid key \(keyCode)")
        }
        self.x = pos.x
        self.y = pos.y
      }
      
      func moved(by instruction: RobotInstruction) -> Position {
        let offset: (x: Int, y: Int) = switch instruction {
        case .left: (-1, 0)
        case .up: (0, -1)
        case .right: (1, 0)
        case .down: (0, 1)
        case .press: fatalError("Tried to offset by press")
        }
        return Position(self.x + offset.x, self.y + offset.y)
      }
      
      static func + (lhs: Self, rhs: Self) -> Self {
        .init(lhs.x + rhs.x, lhs.y + rhs.y)
      }
      
      static func - (lhs: Self, rhs: Self) -> Self {
        .init(lhs.x - rhs.x, lhs.y - rhs.y)
      }
    }
    
    let controllerGrid: Set<Position> = [
      Position(ofInstruction: .up),
      Position(ofInstruction: .left),
      Position(ofInstruction: .press),
      Position(ofInstruction: .down),
      Position(ofInstruction: .right)
    ]
    
    let keypadGrid: Set<Position> = [
      Position(ofKey: "0"),
      Position(ofKey: "1"),
      Position(ofKey: "2"),
      Position(ofKey: "3"),
      Position(ofKey: "4"),
      Position(ofKey: "5"),
      Position(ofKey: "6"),
      Position(ofKey: "7"),
      Position(ofKey: "8"),
      Position(ofKey: "9"),
      Position(ofKey: "A")
    ]
    
    // Credit to https://gist.github.com/HexTree/b2028a2effb6834aab2445533c7e9fea for a solid nudge on this one
    // after banging my head against the wall for a while
    func getMinSteps(currRobot: Int, from startPosition: Position, to endPosition: Position) -> Int {
      let isKeypad = currRobot == 2
      
      let delta = endPosition - startPosition
      
      guard currRobot > 0 else {
        return abs(delta.x) + abs(delta.y) + 1
      }
      
      var steps = [RobotInstruction]()
      
      for _ in 0..<abs(delta.y) {
        steps.append((delta.y < 0) ? .up : .down)
      }
      for _ in 0..<abs(delta.x) {
        steps.append((delta.x < 0) ? .left : .right)
      }
      
      guard !steps.isEmpty else { return 1 }
      
      var bestStepCount = Int.max
      
      stepOrders: for potentialOrdering in steps.uniquePermutations() {
        var currPosition = startPosition
        var steps = 0
        
        var prevInstruction: RobotInstruction = .press
        
        for instruction in potentialOrdering {
          currPosition = currPosition.moved(by: instruction)
          
          guard (isKeypad ? keypadGrid : controllerGrid)
            .contains(currPosition) else {
            continue stepOrders
          }
          
          steps += getMinSteps(
            currRobot: currRobot - 1,
            from: Position(ofInstruction: prevInstruction),
            to: Position(ofInstruction: instruction)
          )
          
          prevInstruction = instruction
        }
        steps += getMinSteps(currRobot: currRobot - 1, from: Position(ofInstruction: prevInstruction), to: Position(ofInstruction: .press))
        
        if steps < bestStepCount {
          bestStepCount = steps
        }
      }
      return bestStepCount
    }
    
    func getShortestCodeInstructions(for code: some StringProtocol) -> Int {
      var currKey: Character = "A"
      
      var sum = 0
      
      for char in code {
        sum += getMinSteps(currRobot: 2, from: Position(ofKey: currKey), to: Position(ofKey: char))
        currKey = char
      }
      return sum
    }
    
    var sum = 0
    
    for code in data.split(separator: "\n").filter({ !$0.isEmpty }) {
      let shortest = getShortestCodeInstructions(for: code)
            
      sum += Int(code.filter(\.isNumber))! * shortest
    }
    return sum
  }

  func part2() -> Any {
    return 0
  }
}
