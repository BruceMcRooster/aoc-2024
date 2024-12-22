import Testing

@testable import AdventOfCode

struct Day22Tests {

  let testData = """
  1
  10
  100
  2024
  
  """

  @Test func testPart1() async throws {
    #expect(String(describing: Day22(data: testData).part1()) == "37327623")
  }

  @Test func testPart2() async throws {
    #expect(true)
  }
}
