import Algorithms

struct Day22: AdventDay {
  var data: String
  
  var initialSecretNumbers: [Int]
  
  init(data: String) {
    self.data = data
    self.initialSecretNumbers = data.split(separator: "\n").compactMap { Int(String($0)) }
  }
  
  func increment(secretNumber: Int) -> Int {
    let pruneMod = 16777216
    
    let step1 = ((secretNumber * 64) ^ secretNumber) % pruneMod
    let step2 = ((step1 / 32) ^ step1) % pruneMod
    let step3 = ((step2 * 2048) ^ step2) % pruneMod
    
    return step3
  }
  
  func part1() -> Any {
    
    var secretNumbers: [Int] = initialSecretNumbers
    
    for _ in 1...2000 {
      secretNumbers = secretNumbers.map(increment)
    }
    return secretNumbers.reduce(0, +)
  }

  func part2() -> Any {
    func getPrices(forSecretNumber secretNumber: Int) -> [Int8] {
      var currentNumber = secretNumber
      var prices: [Int8] = [Int8(currentNumber % 10)]
      
      for _ in 1...2000 {
        currentNumber = increment(secretNumber: currentNumber)
        
        prices.append(Int8(currentNumber % 10))
      }
      
      assert(prices.count == 2001, "Prices array should have been 2001 elements (initial price plus 2000 changes), was instead \(prices.count) elements.")
      
      return prices
    }
    
    func getPriceChanges(forPrices prices: [Int8]) -> [Int8?] {
      let result: [Int8?] = try! prices.reduce<[Int8?]>(into: [nil]) { partialResult, nextElement in
        if let previousElement = partialResult.last! {
          partialResult.removeLast()
          partialResult.append(nextElement - previousElement)
        }
        partialResult.append(nextElement)
      }
      
      // The last element will still be kicking around
      assert(result.count - 1 == prices.count)
      return result.dropLast()
    }
    
    func calcPricesAndChanges(forInitialSecretNumber startingSecret: Int) -> [(price: Int8, change: Int8)] {
      let prices = getPrices(forSecretNumber: startingSecret)
      let priceChanges = getPriceChanges(forPrices: prices)
      
      assert(prices.count == priceChanges.count)
      
      let priceChangesWithoutFirst = priceChanges.compactMap({ $0 })
      
      assert(priceChangesWithoutFirst.count == prices.count - 1)
      
      // We can ignore the first price and price change because the monkey could never stop there
      
      let result: [(price: Int8, change: Int8)] = zip(prices.dropFirst(), priceChangesWithoutFirst).map ({ $0 })
      
      return result
    }
    
    struct PriceChangePattern: Hashable {
      let change1: Int8
      let change2: Int8
      let change3: Int8
      let change4: Int8
      
      func getSalePrice(inChanges priceChanges: [(price: Int8, change: Int8)]) -> Int? {
        for index in priceChanges.startIndex..<(priceChanges.endIndex - 3) {
          if priceChanges[index].change == self.change1
              && priceChanges[index + 1].change == self.change2
              && priceChanges[index + 2].change == self.change3
              && priceChanges[index + 3].change == self.change4 {
            return Int(priceChanges[index + 3].price)
          }
        }
        return nil
      }
      
      init(fromChanges priceChanges: [(price: Int8, change: Int8)], afterIndex startIndex: Int) {
        assert(startIndex < priceChanges.endIndex - 3)
        
        self.change1 = priceChanges[startIndex].change
        self.change2 = priceChanges[startIndex + 1].change
        self.change3 = priceChanges[startIndex + 2].change
        self.change4 = priceChanges[startIndex + 3].change
      }
    }
    
    var changesMaxPrice = [PriceChangePattern : Int]()
    
    assert(Set(initialSecretNumbers).count == initialSecretNumbers.count)
    
    let priceChanges: [[(price: Int8, change: Int8)]] = initialSecretNumbers.map(calcPricesAndChanges)
    
    for priceChange in priceChanges {
      
      var alreadySeenPatterns: Set<PriceChangePattern> = []
      
      for startIndex in priceChange.startIndex..<(priceChange.endIndex - 3) {
        let pattern = PriceChangePattern(fromChanges: priceChange, afterIndex: startIndex)
        
        guard alreadySeenPatterns.insert(pattern).inserted else { continue }
        
        changesMaxPrice[pattern, default: 0] += Int(priceChange[startIndex + 3].price)
      }
    }
    
    let maxPair = changesMaxPrice.max { $0.value < $1.value }
    
    return maxPair!.value
  }
}
