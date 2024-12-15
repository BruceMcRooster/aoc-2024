import Testing

@testable import AdventOfCode

struct Day15Tests {

  let smallTestData = """
  ########
  #..O.O.#
  ##@.O..#
  #...O..#
  #.#.O..#
  #...O..#
  #......#
  ########

  <^^>>>vv<v>>v<<
  
  """
  
  let largeTestData = """
  ##########
  #..O..O.O#
  #......O.#
  #.OO..O.O#
  #..O@..O.#
  #O#..O...#
  #O..O..O.#
  #.OO.O.OO#
  #....O...#
  ##########

  <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
  vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
  ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
  <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
  ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
  ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
  >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
  <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
  ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
  v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
  
  """

  @Test func testParse() async throws {
    let smallTestMap = Day15.Map(fromData: String(smallTestData.split(separator: "\n\n").first!))
    #expect(smallTestMap.width == 8)
    #expect(smallTestMap.height == 8)
    #expect(smallTestMap.robotPosition == (2,2))
    #expect(smallTestMap.map.count == 64)
    
    let smallTestMapWide = Day15.Map(
      fromData: String(smallTestData.split(separator: "\n\n").first!),
      isWide: true
    )
    #expect(smallTestMapWide.width == 16)
    #expect(smallTestMapWide.height == 8)
    #expect(smallTestMapWide.robotPosition == (4, 2))
    #expect(smallTestMapWide.map.count == 128)
  }
  
  @Test func testPart1() async throws {
    #expect(String(describing: Day15(data: smallTestData).part1()) == "2028")
    #expect(String(describing: Day15(data: largeTestData).part1()) == "10092")
  }

  @Test func testPart2() async throws {
    #expect(String(describing: Day15(data: largeTestData).part2()) == "9021")
  }
}
