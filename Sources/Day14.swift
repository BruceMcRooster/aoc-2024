import Algorithms
import Foundation

struct Day14: AdventDay {
  var data: String
  let width: Int
  let height: Int
  
  init(data: String) {
    self.data = data
    self.width = 101
    self.height = 103
  }
  
  init(data: String, width: Int, height: Int) {
    self.data = data
    self.width = width
    self.height = height
  }
  
  struct Robot {
    var position: (x: Int, y: Int)
    let velocity: (x: Int, y: Int)
    
    init(fromData line: Substring) {
      let regex = line.wholeMatch(of: /p=(?<px>\d+),(?<py>\d+) v=(?<vx>-?\d+),(?<vy>-?\d+)/)!
      
      self.position = (Int(String(regex.output.px))!, Int(String(regex.output.py))!)
      self.velocity = (Int(String(regex.output.vx))!, Int(String(regex.output.vy))!)
    }
    
    mutating func step(width: Int, height: Int) {
      self.position = (position.x + velocity.x, position.y + velocity.y)
      if position.x < 0 || position.x >= width {
        self.position.x = (position.x + width) % width
      }
      if position.y < 0 || position.y >= height {
        self.position.y = (position.y + height) % height
      }
    }
  }

  func printBoard(_ board: [Robot], splitMiddle: Bool = false) {
    for y in 0..<height {
      for x in 0..<width {
        if splitMiddle {
          if (x == width / 2 || y == height / 2) {
            print(" ", terminator: "")
            continue
          }
        }
        let count = board.count(where: { $0.position.x == x && $0.position.y == y })
        print(count > 0 ? "\(count)" : ".", terminator: "")
      }
      print()
    }
  }
  
  func part1() -> Any {
    var robots = data.split(separator: "\n").filter { !$0.isEmpty }.map { Robot(fromData: $0) }
    
    for index in robots.indices {
      for _ in 0..<100 {
        robots[index].step(width: width, height: height)
      }
    }
    
    let topLeftQuadrantCount = robots.count { $0.position.x < width / 2 && $0.position.y < height / 2 }
    let topRightQuadrantCount = robots.count { $0.position.x > width / 2 && $0.position.y < height / 2 }
    let bottomLeftQuadrantCount = robots.count { $0.position.x < width / 2 && $0.position.y > height / 2 }
    let bottomRightQuadrantCount = robots.count { $0.position.x > width / 2 && $0.position.y > height / 2 }
    
    return topLeftQuadrantCount * topRightQuadrantCount * bottomLeftQuadrantCount * bottomRightQuadrantCount
  }

  func part2() -> Any {
    var robots = data.split(separator: "\n").filter { !$0.isEmpty }.map { Robot(fromData: $0) }
    
    func calcWidthStd(grid: [Robot]) -> Double {
      let xPositions = grid.map { Double($0.position.x) }
      
      let average = xPositions.reduce(0, +) / Double(xPositions.count)
      
      let std = (xPositions
        .map { ($0 - average) * ($0 - average) }
        .reduce(0, +) / Double(xPositions.count))
        .squareRoot()
      
      return std
    }
    
    func calcHeightStd(grid: [Robot]) -> Double {
      let yPositions = grid.map { Double($0.position.y) }
      
      let average = yPositions.reduce(0, +) / Double(yPositions.count)
      
      let std = (yPositions
        .map { ($0 - average) * ($0 - average) }
        .reduce(0, +) / Double(yPositions.count))
        .squareRoot()
      
      return std
    }
    
    var bestWidthStat: (second: Int, std: Double) = (second: 0, std: calcWidthStd(grid: robots))
    var bestHeightStat: (second: Int, std: Double) = (second: 0, std: calcHeightStd(grid: robots))
    
    for second in 1...103 {
      for index in robots.indices {
        robots[index].step(width: width, height: height)
      }
      let widthStd = calcWidthStd(grid: robots)
      let heightStd = calcHeightStd(grid: robots)
      
      if widthStd < bestWidthStat.std {
        bestWidthStat = (second: second, std: widthStd)
      }
      if heightStd < bestHeightStat.std {
        bestHeightStat = (second: second, std: heightStd)
      }
    }
    
    // See Chinese Remainder Theorem
    let convergingTime = (51 * 103 * bestWidthStat.second + 51 * 101 * bestHeightStat.second) % (101 * 103)
    
    #if WRITE_TREE
    func writeGrid(grid: [Robot], time: Int) {
      let magicStart = "P1\n\(width) \(height)\n"
      
      let writePath: URL = FileManager.default
        .urls(for: .downloadsDirectory, in: .userDomainMask).first!
        .appending(path: "\(time).bmp")
      
      FileManager.default.createFile(atPath: writePath.path, contents: magicStart.data(using: .utf8)!)
      
      let fileHandle = try! FileHandle(forWritingTo: writePath)
      try! fileHandle.seekToEnd()

      for y in 0..<height {
        for x in 0..<width {
          if grid.contains(where: { $0.position == (x, y) }) {
            try! fileHandle.write(contentsOf: "1 ".data(using: .utf8)!)
          } else {
            try! fileHandle.write(contentsOf: "0 ".data(using: .utf8)!)
          }
        }
        try! fileHandle.write(contentsOf: "\n".data(using: .utf8)!)
      }
      print("Wrote board at time \(time) to \(writePath.path)")
    }
    
    for second in 104...convergingTime {
      for index in robots.indices {
        robots[index].step(width: width, height: height)
      }
      if second == convergingTime {
        writeGrid(grid: robots, time: second)
      }
    }
    #endif
    return convergingTime
  }
}
