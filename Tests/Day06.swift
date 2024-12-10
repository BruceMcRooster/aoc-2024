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

  @Test func testParse() async throws {
    let day06 = Day06(data: testData)
    
    #expect(day06.width == 10)
    #expect(day06.height == 10)
  }
  
  @Test func testPart1() async throws {
    #expect(String(describing: Day06(data: testData).part1()) == "41")
  }

  @Test func testPart2() async throws {
    #expect(String(describing: Day06(data: testData).part2()) == "6")
  }
}
