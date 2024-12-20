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

  @Test func testPart1() async throws {
    #expect(String(describing: Day20(data: testData, picosecondCutoff: 10).part1()) == "10")
    #expect(String(describing: Day20(data: testData, picosecondCutoff: 2).part1()) == "44")
  }

  @Test func testPart2() async throws {
    #expect(true)
  }
}
