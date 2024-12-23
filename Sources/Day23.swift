import Algorithms

struct Day23: AdventDay {
  var data: String

  var connections: [Substring : Set<Substring>]
  
  init(data: String) {
    self.data = data
    self.connections = [:]
    
    for connection in data.split(separator: "\n") {
      let nodes = connection.split(separator: "-", maxSplits: 1)
      let node1 = nodes.first!
      let node2 = nodes.last!
      
      connections[node1, default: []].insert(node2)
      connections[node2, default: []].insert(node1)
    }
  }
  
  func part1() -> Any {
    
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
    var largestConnection: Set<Substring> = []
    
    func largestLANParty(with node: Substring) -> Set<Substring>? {
      let allOtherConnections = connections[node]!
        .filter { connections[$0]!.intersection(connections[node]!).count > 1 }
      
      // Couldn't possibly have a bigger alternative set of connections
      guard allOtherConnections.count + 1 > largestConnection.count
      else { return nil }
      
      var best = Set<Substring>()
      
      lanParties: for possibleLANParty in allOtherConnections.combinations(ofCount: 2...).reversed() {
        guard possibleLANParty.count > best.count
                && possibleLANParty.count + 1 > largestConnection.count
        else { continue }
        
        let lanSet = Set(possibleLANParty)
        
        for connection in possibleLANParty {
          guard connections[connection]!
            .intersection(lanSet).count == lanSet.count - 1 else { continue lanParties }
        }
        
        best = lanSet
      }
      
      guard !best.isEmpty else { return nil }
      
      best.insert(node)
      return best
    }
    
    for node in connections.sorted(by: { $0.value.count > $1.value.count }).map(\.key) {
      guard connections[node]!.count >= 2 else { continue }
      
      let largest = largestLANParty(with: node)
            
      if let largest, largest.count > largestConnection.count {
        largestConnection = largest
      }
    }
    
    return largestConnection.sorted().joined(separator: ",")
  }
}
