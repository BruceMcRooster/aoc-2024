import Algorithms

struct Day04: AdventDay {
  var data: String
  
  init(data: String) {
    self.data = data
    self.lineLength = data.components(separatedBy: .newlines).first!.count + 1
  }
  
  var lineLength = 0
  
  enum Angle: CaseIterable {
    case N, NE, E, SE, S, SW, W, NW
    
    func getSkip(lineLength: Int) -> Int {
      return switch self {
      case .N: -lineLength
      case .NE: -lineLength + 1
      case .E: 1
      case .SE: lineLength + 1
      case .S: lineLength
      case .SW: lineLength - 1
      case .W: -1
      case .NW: -lineLength - 1
      }
    }
    
    func isVertical() -> Bool {
      return switch self {
      case .N, .S: true
      default: false
      }
    }
  }
  
  func traceString(start: String.Index, angle: Angle) -> String {
    let currChar: String = String(data[start])
        
    if !angle.isVertical() {
      if (angle == .NW || angle == .W || angle == .SW) {
        guard start != data.startIndex && data[data.index(before: start)] != "\n" else { return currChar }
      }
      else {
        guard start != data.endIndex && data[data.index(after: start)] != "\n" else { return currChar }
      }
    }
    
    let skip = angle.getSkip(lineLength: lineLength)
    let skipIndex = data.index(
      start,
      offsetBy: skip,
      limitedBy: skip >= 0 ? data.endIndex : data.startIndex
    )
    
    if let skipIndex {
      guard skipIndex != data.endIndex else { return currChar }
      return currChar + traceString(start: skipIndex, angle: angle)
    } else {
      return currChar
    }
  }
  
  func part1() -> Any {
    var count = 0
    
    for (index, char) in data.indexed() {
      guard char == "X" else { continue }
            
      for angle in Angle.allCases {
        if traceString(start: index, angle: angle).hasPrefix("XMAS") { count += 1 }
      }
    }
    
    return count
  }

  func part2() -> Any {
    return 0
  }
}
