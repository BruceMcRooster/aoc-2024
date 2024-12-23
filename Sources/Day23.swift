import Algorithms

struct Day23: AdventDay {
  var data: String

  func part1() -> Any {
    var connections: [Substring : Set<Substring>] = [:]
    
    for connection in data.split(separator: "\n") {
      let nodes = connection.split(separator: "-", maxSplits: 1)
      let node1 = nodes.first!
      let node2 = nodes.last!
      
      connections[node1, default: []].insert(node2)
      connections[node2, default: []].insert(node1)
    }
    
    var connectedToTNodes: Set<Set<Substring>> = []
    
    for tNode in connections.keys.filter({ $0.starts(with: "t") }) {
      guard connections[tNode]!.count >= 2 else { continue }
      
      for connectedNode in connections[tNode]! {
        let intersect = connections[connectedNode]!.intersection(connections[tNode]!)
        
        if intersect.count >= 1 {
          for node in intersect {
            connectedToTNodes.insert([tNode, connectedNode, node])
          }
        }
      }
    }
    return connectedToTNodes.count
  }

  func part2() -> Any {
    return 0
  }
}
