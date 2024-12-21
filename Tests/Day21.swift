import Testing

@testable import AdventOfCode

struct Day21Tests {

  let testCodes = """
  029A
  980A
  179A
  456A
  379A
  
  """

  @Test func testPart1() async throws {
    #expect(String(describing: Day21(data: testCodes).part1()) == "126384")
  }

  @Test func testPart2() async throws {
    #expect(String(describing: Day21(data: testCodes).part2()) == "154115708116294")
  }
}
