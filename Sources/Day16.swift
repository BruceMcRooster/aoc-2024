import Algorithms
import DequeModule

struct Day16: AdventDay {
  var data: String
  
  struct Graph {
    
    internal struct Node: Hashable, Equatable {
      let x: Int
      let y: Int
      
      init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
      }
      
      init(fromPair pair: (x: Int, y: Int)) {
        self.x = pair.x
        self.y = pair.y
      }
      
      func toPair() -> (x: Int, y: Int) {
        (x, y)
      }
    }
    
    private var neighborList = [Node: Set<Node>]()
    
    mutating func connect(_ first: (x: Int, y: Int), to second: (x: Int, y: Int)) {
      neighborList[Node(fromPair: first), default: Set()].insert(Node(fromPair: second))
      neighborList[Node(fromPair: second), default: Set()].insert(Node(fromPair: first))
    }
    
    func neighbors(of pair: (x: Int, y: Int)) -> [(x: Int, y: Int)] {
      neighborList[Node(fromPair: pair)]?.map { $0.toPair() } ?? []
    }
    
    func printGraph() {
      for node in neighborList.keys {
        print("(\(node.x),\(node.y))->", terminator: "")
        for neighbor in neighborList[node] ?? Set() {
          print("(\(neighbor.x),\(neighbor.y))->", terminator: "")
        }
        print()
      }
    }
  }
  
  enum Facing: Hashable, Equatable, CaseIterable {
    case north, east, south, west
    
    func turn(from point1: (x: Int, y: Int), to point2: (x: Int, y: Int)) -> (newDirection: Facing, cost: Int) {
      assert(point1 != point2)
      assert(abs(point1.x - point2.x) <= 1 && abs(point1.y - point2.y) <= 1)
      
      let requiredDirection: Facing = {
        if point1.x == point2.x {
          if point1.y - 1 == point2.y { return .north }
          else { return .south }
        } else {
          assert(point1.y == point2.y)
          if point1.x - 1 == point2.x { return .west }
          else { return .east }
        }
      }()
      
      if requiredDirection == self {
        return (requiredDirection, 0)
      }
      
      if (requiredDirection == .north && self == .south)
          || (requiredDirection == .east && self == .west)
          || (requiredDirection == .south && self == .north)
          || (requiredDirection == .west && self == .east) {
        return (requiredDirection, 2000)
      }
      return (requiredDirection, 1000)
    }
  }
  
  struct Node: Hashable {
    private let x: Int
    private let y: Int
    let facing: Facing
    
    var position: (x: Int, y: Int) {
      return (x, y)
    }
    
    init(_ position: (x: Int, y: Int), facing: Facing) {
      self.x = position.x
      self.y = position.y
      self.facing = facing
    }
  }
  
  var graph = Graph()
  let end: (x: Int, y: Int)
  let start: (x: Int, y: Int)
  
  init(data: String) {
    self.data = data
    
    var end: (x: Int, y: Int)?
    var start: (x: Int, y: Int)?
    
    let width = data.distance(from: data.startIndex, to: data.firstIndex(of: "\n")!)
    let height = data.split(separator: "\n").filter({!$0.isEmpty}).count
    
    let dataLength = data.count
    for (index, char) in data.enumerated() {
      
      guard char == "." || char == "S" || char == "E" else { continue }
      
      let x = index % (width + 1)
      let y = index / (width + 1) // Accounts for trailing \n's
        
      if index > 0 {
        if data[data.index(data.startIndex, offsetBy: index - 1)] == "." { graph.connect((x,y), to: (x-1,y))}
      }
      if index < dataLength - 1 {
        if data[data.index(data.startIndex, offsetBy: index + 1)] == "." { graph.connect((x,y), to: (x+1,y))}
      }
      
      if index / (width + 1) > 0 {
        if data[data.index(data.startIndex, offsetBy: index - (width + 1))] == "." { graph.connect((x,y), to: (x,y-1))}
      }
      if index / (width + 1) < height {
        if data[data.index(data.startIndex, offsetBy: index + (width + 1))] == "." { graph.connect((x,y), to: (x,y+1))}
      }
      
      if char == "S" {
        assert(start == nil)
        start = (x, y)
      }
      if char == "E" {
        assert(end == nil)
        end = (x, y)
      }
    }
    self.start = start!
    self.end = end!
  }
  
  func part1() -> Any {
    var priorityQueue = Deque<(cost: Int, node: Node)>()
    func enqueue(_ node: Node, cost: Int) {
      for (i, existing) in priorityQueue.enumerated() {
        if existing.cost > cost {
          priorityQueue.insert((cost: cost, node: node), at: i)
          break
        }
      }
      priorityQueue.append((cost: cost, node: node)) // For if it is the largest (or the list is empty)
    }
    
    var costs: [Node: Int] = [:]
    let startNode = Node(start, facing: .east)
    costs[startNode] = 0
    enqueue(startNode, cost: 0)
    
    while !priorityQueue.isEmpty {
      let (currCost, currNode) = priorityQueue.removeFirst()
    
      
      if currNode.position == end {
        return currCost
      }
      
      if let recordedCost = costs[currNode], recordedCost < currCost {
        continue // We found a cheaper way to get here already
      }
      
      for neighbor in graph.neighbors(of: currNode.position) {
        let (newDirection, newCost) = currNode.facing.turn(from: currNode.position, to: neighbor)
        
        let totalCost = 1 + newCost + currCost
        let neighborNode = Node(neighbor, facing: newDirection)
        if totalCost < (costs[neighborNode] ?? Int.max) {
          costs[neighborNode] = totalCost
          enqueue(neighborNode, cost: totalCost)
        }
      }
    }
    fatalError("Could not find any path from start to end")
  }

  func printPath(_ path: [(x: Int, y: Int)]) {
    let width = data.distance(from: data.startIndex, to: data.firstIndex(of: "\n")!)
    
    let withPoints: [Character] = data.enumerated().map { (index, char) in
      let point = (index % (width + 1), index / (width + 1))
      if path.contains(where: { $0 == point }) {
        assert(char == "." || char == "S" || char == "E", "We got a wack point at \(point), with character \(char)")
        return "O"
      } else {
        return char
      }
    }
    
    print(String(withPoints))
  }
  
  func part2() -> Any {
    var priorityQueue = Deque<(cost: Int, node: Node, path: [(x: Int, y: Int)])>()
    func enqueue(_ node: Node, cost: Int, path: [(x: Int, y: Int)]) {
      for (i, existing) in priorityQueue.enumerated() {
        if existing.cost > cost {
          priorityQueue.insert((cost, node, path), at: i)
          return
        }
      }
      priorityQueue.append((cost, node, path)) // For if it is the largest (or the list is empty)
    }
    
    struct CostWithPossiblePaths: Hashable, Equatable {
      let cost: Int
      struct Position: Hashable, Equatable {
        private let x: Int
        private let y: Int
        
        var position: (x: Int, y: Int) {
          (x, y)
        }
        
        init(pair: (x: Int, y: Int)) {
          self.x = pair.x
          self.y = pair.y
        }
      }
      var paths: [[Position]]
      
      init(cost: Int, paths: [[(x: Int, y: Int)]]) {
        self.cost = cost
        self.paths = paths.map({ path in
          path.map(Position.init)
        })
      }
      
      mutating func add(path: [(x: Int, y: Int)]) {
        paths.append(path.map(Position.init))
      }
    }
    
    var costs: [Node: CostWithPossiblePaths] = [:]
    let startNode = Node(start, facing: .east)
    let startCost = CostWithPossiblePaths(cost: 0, paths: [[start]])
    costs[startNode] = startCost
    enqueue(startNode, cost: 0, path: [start])
    
    while !priorityQueue.isEmpty {
      let (currCost, currNode, currPath) = priorityQueue.removeFirst()
      
      if let recordedCost = costs[currNode], recordedCost.cost < currCost {
        continue // We found a cheaper way to get here already
      }
      
      for neighbor in graph.neighbors(of: currNode.position) {
        let (newDirection, newCost) = currNode.facing.turn(from: currNode.position, to: neighbor)
        
        let totalCost = 1 + newCost + currCost
        let neighborNode = Node(neighbor, facing: newDirection)
        if totalCost < (costs[neighborNode]?.cost ?? Int.max) {
          let totalCostWithPath = CostWithPossiblePaths(cost: totalCost, paths: [currPath + [neighbor]])
          costs[neighborNode] = totalCostWithPath
          enqueue(neighborNode, cost: totalCost, path: currPath + [neighbor])
        } else if totalCost == costs[neighborNode]!.cost {
          costs[neighborNode]!.add(path: currPath + [neighbor])
          enqueue(neighborNode, cost: totalCost, path: currPath + [neighbor])
        }
      }
    }
    var allNodesInEndPath: [CostWithPossiblePaths.Position] = []
    var bestCost = Int.max
    for possibleEndDirections in Facing.allCases {
      guard let endCostWithPaths = costs[Node(end, facing: possibleEndDirections)] else {
        continue
      }
      if endCostWithPaths.cost < bestCost {
        bestCost = endCostWithPaths.cost
        allNodesInEndPath = endCostWithPaths.paths.reduce([], +)
      } else if endCostWithPaths.cost == bestCost {
        allNodesInEndPath += endCostWithPaths.paths.reduce([], +)
      }
    }
    
    return allNodesInEndPath.uniqued().count(where: {_ in true})
  }
}
