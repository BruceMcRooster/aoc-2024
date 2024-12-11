import Testing

@testable import AdventOfCode

struct Day11Tests {

  let testData = "125 17\n"

  @Test func testPart1() async throws {
    #expect(String(describing: Day11(data: testData).part1()) == "55312")
  }

  @Test func testPart2() async throws {
    #expect(true)
  }
}
