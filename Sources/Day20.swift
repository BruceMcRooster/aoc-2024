import Algorithms

struct Day20: AdventDay {
  var data: String

  var picosecondsSaved: Int

  var width: Int
  var height: Int

  var validPositions: Set<Position>

  var startPosition: Position = Position(x: -1, y: -1)
  var endPosition: Position = Position(x: -1, y: -1)

  var picosecondsToEnd: [Position : Int]

  init(data: String) {
    self.init(data: data, picosecondsSaved: 100)
  }

  init(data: String, picosecondsSaved: Int) {
    self.data = data.trimmingCharacters(in: .whitespacesAndNewlines)
    self.picosecondsSaved = picosecondsSaved

    var height = 0
    var width: Int?

    self.validPositions = Set()

    for (index, char) in self.data.enumerated() {
      guard char != "\n" else {
        if width == nil {
          width = index
        }

        height += 1
        continue
      }

      guard char != "#" else { continue }

      let position = Position(x: width.map { index % ($0 + 1) } ?? index, y: height)

      if char == "S" {
        startPosition = position
      } else if char == "E" {
        endPosition = position
      }

      validPositions.insert(position)
    }
    assert(startPosition != Position(x: -1, y: -1))
    assert(endPosition != Position(x: -1, y: -1))

    self.width = width!
    self.height = height + 1

    self.picosecondsToEnd = [Position : Int]()

    var queue = [(position: endPosition, cost: 0)]

    while !queue.isEmpty {
      let (position, cost) = queue.removeFirst()

      guard picosecondsToEnd[position] == nil else { continue }

      picosecondsToEnd[position] = cost

      if validPositions.contains(Position(x: position.x - 1, y: position.y)) {
        queue.append((Position(x: position.x - 1, y: position.y), cost + 1))
      }
      if validPositions.contains(Position(x: position.x + 1, y: position.y)) {
        queue.append((Position(x: position.x + 1, y: position.y), cost + 1))
      }
      if validPositions.contains(Position(x: position.x, y: position.y - 1)) {
        queue.append((Position(x: position.x, y: position.y - 1), cost + 1))
      }
      if validPositions.contains(Position(x: position.x, y: position.y + 1)) {
        queue.append((Position(x: position.x, y: position.y + 1), cost + 1))
      }
    }
  }

  struct Position: Hashable {
    let x: Int
    let y: Int
  }

  struct Cheat {
    let start: Position
    let end: Position

    var length: Int {
      abs(end.x - start.x) + abs(end.y - start.y)
    }
  }

  /// Returns a dictionary of possible cheats and their
  func countCheats(maxCheatLength: Int) -> Int {
    let lengthFromStart = picosecondsToEnd[startPosition]!

    func getCheats(from position: Position) -> [Cheat] {
      var cheats = [Cheat]()

      for x in max(position.x - maxCheatLength, 0)...min(position.x + maxCheatLength, width - 1) {
        for y in max(position.y - (maxCheatLength - abs(position.x - x)), 0)...min(position.y + (maxCheatLength - abs(position.x - x)), height - 1) {
          if validPositions.contains(Position(x: x, y: y)) {
            cheats.append(Cheat(start: position, end: Position(x: x, y: y)))
            continue
          }
        }
      }

      return cheats
    }

    var validCheats = 0

    for pathPosition in validPositions where pathPosition != endPosition {
      for cheat in getCheats(from: pathPosition) {
        let lengthToStart = lengthFromStart - picosecondsToEnd[cheat.start]!

        let lengthFromEnd = picosecondsToEnd[cheat.end]!

        let totalLength = lengthToStart + cheat.length + lengthFromEnd

        if totalLength <= lengthFromStart - picosecondsSaved {
          validCheats += 1
        }
      }
    }
    return validCheats
  }

  func part1() -> Any {
    return countCheats(maxCheatLength: 2)
  }

  func part2() -> Any {
    return countCheats(maxCheatLength: 20)
  }
}
