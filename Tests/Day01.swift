import Testing

@testable import AdventOfCode

struct Day01Tests {

  let testData = """
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
  
  """

  @Test func testParse() async throws {
    let day1 = Day01(data: testData)
    #expect(day1.lists.0 == [3, 4, 2, 1, 3, 3])
    #expect(day1.lists.1 == [4, 3, 5, 3, 9, 3])
  }
  
  @Test func testPart1() async throws {
    #expect(String(describing: Day01(data: testData).part1()) == "11")
  }

  @Test func testPart2() async throws {
    #expect(String(describing: Day01(data: testData).part2()) == "31")
  }
}
