import Testing

@testable import AdventOfCode

struct Day19Tests {

  let testData = """
  r, wr, b, g, bwu, rb, gb, br

  brwrr
  bggr
  gbbr
  rrbgbr
  ubwu
  bwurrg
  brgr
  bbrgwb
  
  """

  @Test
  func testParse() async throws {
    let day19 = Day19(data: testData)
    #expect(day19.towels.keys.count == 5)
    #expect(day19.towels.values.reduce(0) { $0 + $1.count } == 8)
    
    #expect(day19.towels["r"]!.count == 2)
    #expect(day19.towels["w"]!.count == 1)
    #expect(day19.towels["b"]!.count == 3)
    #expect(day19.towels["g"]!.count == 2)
    #expect(day19.towels["u"]!.count == 0)
    
    #expect(day19.patterns.count == 8)
  }
  
  @Test func testPart1() async throws {
    #expect(String(describing: Day19(data: testData).part1()) == "6")
  }

  @Test func testPart2() async throws {
    #expect(true)
  }
}
