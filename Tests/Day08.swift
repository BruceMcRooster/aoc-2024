import Testing

@testable import AdventOfCode

struct Day08Tests {

  let testData = """
  ............
  ........0...
  .....0......
  .......0....
  ....0.......
  ......A.....
  ............
  ............
  ........A...
  .........A..
  ............
  ............
  
  """

  @Test func testParse() async throws {
    let day8 = Day08(data: testData)
    
    #expect(day8.width == 12)
    #expect(day8.height == 12)
  }
  
  @Test func testPart1() async throws {
    #expect(String(describing: Day08(data: testData).part1()) == "14")
  }

  @Test func testPart2() async throws {
    #expect(String(describing: Day08(data: testData).part2()) == "34")
  }
}
