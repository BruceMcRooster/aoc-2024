import Testing

@testable import AdventOfCode

struct Day12Tests {

  let smallTest1 = """
  AAAA
  BBCD
  BBCC
  EEEC
  
  """
  
  let smallTest2 = """
  OOOOO
  OXOXO
  OOOOO
  OXOXO
  OOOOO
  
  """
  
  let bigTest = """
  RRRRIICCFF
  RRRRIICCCF
  VVRRRCCFFF
  VVRCCCJFFF
  VVVVCJJCFE
  VVIVCCJJEE
  VVIIICJJEE
  MIIIIIJJEE
  MIIISIJEEE
  MMMISSJEEE
  
  """

  @Test func testPart1() async throws {
    #expect(String(describing: Day12(data: smallTest1).part1()) == "140")
    #expect(String(describing: Day12(data: smallTest2).part1()) == "772")
    #expect(String(describing: Day12(data: bigTest).part1()) == "1930")
  }

  @Test func testPart2() async throws {
    #expect(true)
  }
}
