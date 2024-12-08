import Algorithms

struct Day08: AdventDay {
  var data: String
  
  let board: [Character]
  let width: Int
  let height: Int
  
  init(data: String) {
    self.data = data
    self.width = data.split(separator: "\n").first!.count
    self.height = data.split(separator: "\n").filter { !$0.isEmpty }.count
    self.board = {
      let lines = data.split(separator: "\n").filter { !$0.isEmpty }
      return lines.reduce([]) { arr, line in
        arr + Array(line).filter { $0 != "\n" }
      }
    }()
    assert(board.count == width * height)
  }
  
  struct BoardPosition: Hashable, Equatable {
    let x: Int
    let y: Int
    
    private let width: Int
    
    var index: Int {
      return x + y * width
    }
    
    init(x: Int, y: Int, width: Int) {
      self.x = x
      self.y = y
      self.width = width
    }
    
    init(index: Int, width: Int) {
      self.x = index % width
      self.y = index / width
      self.width = width
    }
    
    static func == (lhs: BoardPosition, rhs: BoardPosition) -> Bool {
      guard lhs.width == rhs.width else {
        fatalError("Compared board positions with differing width")
      }
      return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(x)
      hasher.combine(y)
    }
  }
  
  func allPossibleAntinodePositions(_ positions: [BoardPosition], _ possibleAntinodePositions: (BoardPosition, BoardPosition) -> [BoardPosition]) -> [BoardPosition] {
    var resultantPositions = [BoardPosition]()
    for i in 0..<(positions.endIndex - 1) {
      for j in i+1..<positions.endIndex {
        resultantPositions += possibleAntinodePositions(positions[i], positions[j])
      }
    }
    return resultantPositions.filter(isOnBoard)
  }
  
  func printBoardWithAntinodes(_ positions: [BoardPosition]) {
    var stringBoardCopy = data
    for position in positions {
      let stringIndex: String.Index = stringBoardCopy.index(
        stringBoardCopy.startIndex,
        offsetBy: position.x + (position.y * (width + 1))
      )
      
      if stringBoardCopy[stringIndex] == "." {
        stringBoardCopy.replaceSubrange(stringIndex...stringIndex, with: "#")
      }
    }
    print(stringBoardCopy)
  }
  
  func isOnBoard(_ position: BoardPosition) -> Bool {
    position.x >= 0 && position.x < width && position.y >= 0 && position.y < height
  }
  
  func allPositionsOf(_ character: Character) -> [BoardPosition] {
    var result = [BoardPosition]()
    for (index, char) in board.enumerated() {
      if char == character {
        result.append(BoardPosition(index: index, width: width))
      }
    }
    return result
  }
  
  func part1() -> Any {
    func possibleAntinodePositions(_ first: BoardPosition, _ second: BoardPosition) -> [BoardPosition] {
      let xOffset = second.x - first.x
      let yOffset = second.y - first.y
      
      return [
        BoardPosition(x: first.x - xOffset, y: first.y - yOffset, width: width),
        BoardPosition(x: second.x + xOffset, y: second.y + yOffset, width: width)
      ]
    }
    
    var foundSet = Set<Character>()
    var antinodePositions = [BoardPosition]()
    
    
    for char in board {
      if char != "." && !foundSet.insert(char).inserted {
        antinodePositions += allPossibleAntinodePositions(
          allPositionsOf(char),
          possibleAntinodePositions
        )
      }
    }
    
    let antinodePositionsSet = Set(antinodePositions)
    
    return antinodePositionsSet.count
  }

  func part2() -> Any {
    func possibleAntinodePositions(_ first: BoardPosition, _ second: BoardPosition) -> [BoardPosition] {
      let xOffset = second.x - first.x
      let yOffset = second.y - first.y
      
      var boardPositions = [BoardPosition]()
      
      // Starts at 0 because a tower that creates possible antinodes
      // counts as a possible antinode position
      for multiplier in 0...width {
        let backPosition = BoardPosition(
          x: first.x - (xOffset * multiplier),
          y: first.y - (yOffset * multiplier),
          width: width
        )
        let forwardPosition = BoardPosition(
          x: second.x + (xOffset * multiplier),
          y: second.y + (yOffset * multiplier),
          width: width
        )
        if isOnBoard(backPosition) {
          boardPositions.append(backPosition)
        }
        if isOnBoard(forwardPosition) {
          boardPositions.append(forwardPosition)
        }
        if !isOnBoard(backPosition) && !isOnBoard(forwardPosition) {
          break
        }
      }
      
      return boardPositions
    }
    
    var foundSet = Set<Character>()
    var antinodePositions = Set<BoardPosition>()
    
    
    for char in board {
      if char != "." && !foundSet.insert(char).inserted {
        antinodePositions.formUnion(allPossibleAntinodePositions(
          allPositionsOf(char),
          possibleAntinodePositions
        ))
      }
    }
    
    return antinodePositions.count
  }
}
