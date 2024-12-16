import Testing

@testable import AdventOfCode

struct Day16Tests {

  let smallTestData = """
  ###############
  #.......#....E#
  #.#.###.#.###.#
  #.....#.#...#.#
  #.###.#####.#.#
  #.#.#.......#.#
  #.#.#####.###.#
  #...........#.#
  ###.#.#####.#.#
  #...#.....#.#.#
  #.#.#.###.#.#.#
  #.....#...#.#.#
  #.###.#.#.#.#.#
  #S..#.....#...#
  ###############
  
  """
  
  let largeTestData = """
  #################
  #...#...#...#..E#
  #.#.#.#.#.#.#.#.#
  #.#.#.#...#...#.#
  #.#.#.#.###.#.#.#
  #...#.#.#.....#.#
  #.#.#.#.#.#####.#
  #.#...#.#.#.....#
  #.#.#####.#.###.#
  #.#.#.......#...#
  #.#.###.#####.###
  #.#.#...#.....#.#
  #.#.#.#####.###.#
  #.#.#.........#.#
  #.#.#.#########.#
  #S#.............#
  #################
  
  """

  @Test func testPart1() async throws {
    #expect(String(describing: Day16(data: smallTestData).part1()) == "7036")
    #expect(String(describing: Day16(data: largeTestData).part1()) == "11048")
  }

  @Test func testPart2() async throws {
    #expect(String(describing: Day16(data: smallTestData).part2()) == "45")
    #expect(String(describing: Day16(data: largeTestData).part2()) == "64")
  }
}
