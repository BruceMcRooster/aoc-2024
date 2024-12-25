import Testing

@testable import AdventOfCode

struct Day25Tests {

  let testData = """
  #####
  .####
  .####
  .####
  .#.#.
  .#...
  .....

  #####
  ##.##
  .#.##
  ...##
  ...#.
  ...#.
  .....

  .....
  #....
  #....
  #...#
  #.#.#
  #.###
  #####

  .....
  .....
  #.#..
  ###..
  ###.#
  ###.#
  #####

  .....
  .....
  .....
  #....
  #.#..
  #.#.#
  #####
  
  """

  @Test func testPart1() async throws {
    #expect(String(describing: Day25(data: testData).part1()) == "3")
  }

  @Test func testPart2() async throws {
    #expect(true)
  }
}
