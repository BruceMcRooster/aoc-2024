import Testing

@testable import AdventOfCode

struct Day09Tests {

  let testData = "2333133121414131402\n"

  @Test func testPart1() async throws {
    #expect(String(describing: Day09(data: testData).part1()) == "1928")
  }

  @Test func testPart2() async throws {
    #expect(true)
  }
}
