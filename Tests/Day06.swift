import Testing

@testable import AdventOfCode

struct Day06Tests {

  let testData = """
  ....#.....
  .........#
  ..........
  ..#.......
  .......#..
  ..........
  .#..^.....
  ........#.
  #.........
  ......#...

  """

  @Test func testPart1() async throws {
    let day06 = Day06(data: testData)
    
    #expect(day06.width == 10)
    #expect(day06.height == 10)
    #expect(String(describing: day06.part1()) == "41")
  }

  @Test func testPart2() async throws {
    #expect(String(describing: Day06(data: testData).part2()) == "6")
  }
}
