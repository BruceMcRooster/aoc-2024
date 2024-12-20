import Testing

@testable import AdventOfCode

struct Day20Tests {

  let testData = """
  ###############
  #...#...#.....#
  #.#.#.#.#.###.#
  #S#...#.#.#...#
  #######.#.#.###
  #######.#.#...#
  #######.#.###.#
  ###..E#...#...#
  ###.#######.###
  #...###...#...#
  #.#####.#.###.#
  #.#...#.#.#...#
  #.#.#.#.#.#.###
  #...#...#...###
  ###############
  
  """

  @Test func testParse() async throws {
    let day20 = Day20(data: testData, picosecondsSaved: 10)
    
    #expect(day20.width == 15)
    #expect(day20.height == 15)
    #expect(day20.startPosition == Day20.Position(x: 1, y: 3))
    #expect(day20.endPosition == Day20.Position(x: 5, y: 7))
    #expect(day20.validPositions.count == 85)
  }
  
  @Test func testPart1() async throws {
    #expect(String(describing: Day20(data: testData, picosecondsSaved: 10).part1()) == "10")
    #expect(String(describing: Day20(data: testData, picosecondsSaved: 2).part1()) == "44")
  }

  @Test func testPart2() async throws {
    #expect(String(describing: Day20(data: testData, picosecondsSaved: 70).part2()) == "41")
    #expect(String(describing: Day20(data: testData, picosecondsSaved: 50).part2()) == "285")
  }
}
