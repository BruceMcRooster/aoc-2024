import Testing

@testable import AdventOfCode

struct Day02Tests {

  let testData: String = """
  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
  
  """

  @Test func testPart1() async throws {
    #expect(String(describing: Day02(data: testData).part1()) == "2")
  }

  @Test func testPart2() async throws {
    #expect(String(describing: Day02(data: testData).part2()) == "4")
  }
}
