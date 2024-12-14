import Algorithms

struct Day13: AdventDay {
  var data: String

  struct Button {
    let aAdd: (x: Int, y: Int)
    let bAdd: (x: Int, y: Int)
    let prize: (x: Int, y: Int)
    
    init(from data: String) {
      let aMatch = data.firstMatch(of: /Button A: X\+(?<x>\d+), Y\+(?<y>\d+)/)!
      let bMatch = data.firstMatch(of: /Button B: X\+(?<x>\d+), Y\+(?<y>\d+)/)!
      let prizeLocationMatch = data.firstMatch(of: /Prize: X=(?<x>\d+), Y=(?<y>\d+)/)!
      self.aAdd = (Int(String(aMatch.output.x))!, Int(String(aMatch.output.y))!)
      self.bAdd = (Int(String(bMatch.output.x))!, Int(String(bMatch.output.y))!)
      self.prize = (Int(String(prizeLocationMatch.output.x))!, Int(String(prizeLocationMatch.output.y))!)
    }
    
    init(aAdd: (x: Int, y: Int), bAdd: (x: Int, y: Int), prize: (x: Int, y: Int)) {
      self.aAdd = aAdd
      self.bAdd = bAdd
      self.prize = prize
    }
    
    func withPart2PrizeLocation() -> Button {
      .init(aAdd: self.aAdd, bAdd: self.bAdd, prize: (self.prize.x + 10000000000000, self.prize.y + 10000000000000))
    }
  }
  
  let buttons: [Button]
  
  init(data: String) {
    self.data = data
    self.buttons = data.split(separator: "\n\n").map{ Button(from: String($0)) }
  }
  
  func gcd(_ a: Int, _ b: Int) -> Int {
    guard b != 0 else { return a }
    return gcd(b, a % b)
  }

  func part1() -> Any {
    
    func minimizePresses(of button: Button) -> (aPresses: Int, bPresses: Int)? {
      guard button.prize.x % gcd(button.aAdd.x, button.bAdd.x) == 0 else { return nil }
      guard button.prize.y % gcd(button.aAdd.y, button.bAdd.y) == 0 else { return nil }
      
      func costOf(aPresses: Int, bPresses: Int) -> Int? {
        guard aPresses * button.aAdd.x + bPresses * button.bAdd.x == button.prize.x else { return nil }
        guard aPresses * button.aAdd.y + bPresses * button.bAdd.y == button.prize.y else { return nil }
        return aPresses * 3 + bPresses
      }
      
      var minCost = Int.max
      var minAPresses: Int?
      var minBPresses: Int?
      
      for aPresses in 0...100 {
        if aPresses * 3 > minCost { break }
        
        for bPresses in 0...100 {
          if aPresses * 3 + bPresses > minCost { break }
          
          if let cost = costOf(aPresses: aPresses, bPresses: bPresses) {
            if cost < minCost {
              minCost = cost
              minAPresses = aPresses
              minBPresses = bPresses
            }
          }
        }
      }
      
      // No solution in the bounds
      if minAPresses == nil || minBPresses == nil { return nil }
      
      return (minAPresses!, minBPresses!)
    }
    
    var totalCost = 0
    for button in buttons {
      if let (aPresses, bPresses) = minimizePresses(of: button) {
        totalCost += aPresses * 3 + bPresses
      }
    }
    return totalCost
  }

  func part2() -> Any {
    func minimizeCost(ofPressing button: Button) -> (aPresses: Int, bPresses: Int)? {
      guard button.prize.x % gcd(button.aAdd.x, button.bAdd.x) == 0 else { return nil}
      guard button.prize.y % gcd(button.aAdd.y, button.bAdd.y) == 0 else { return nil}
      
      // Got lost on the math, so partial credit for motivating me to do the simple math instead goes to
      // https://forums.swift.org/t/advent-of-code-2024/76301/75
      let aPresses = (button.prize.y * button.bAdd.x - button.bAdd.y * button.prize.x) / (button.aAdd.y * button.bAdd.x - button.bAdd.y * button.aAdd.x)
      let bPresses = (button.prize.y - aPresses * button.aAdd.y) / button.bAdd.y
      
      if button.aAdd.x * aPresses + button.bAdd.x * bPresses == button.prize.x && button.aAdd.y * aPresses + button.bAdd.y * bPresses == button.prize.y {
        return (aPresses, bPresses)
      } else {
        return nil
      }
    }
    
    var totalCost = 0
    for button in buttons
      .map({ $0.withPart2PrizeLocation() })
    {
      if let (aPresses, bPresses) = minimizeCost(ofPressing: button) {
        totalCost += aPresses * 3 + bPresses
      }
    }
    return totalCost
  }
}
