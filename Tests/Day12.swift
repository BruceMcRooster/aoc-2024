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
  
  let ETest = """
  EEEEE
  EXXXX
  EEEEE
  EXXXX
  EEEEE
  
  """
  
  let ABBATest = """
  AAAAAA
  AAABBA
  AAABBA
  ABBAAA
  ABBAAA
  AAAAAA
  
  """

  @Test func testPart1() async throws {
    #expect(String(describing: Day12(data: smallTest1).part1()) == "140")
    #expect(String(describing: Day12(data: smallTest2).part1()) == "772")
    #expect(String(describing: Day12(data: bigTest).part1()) == "1930")
  }

  @Test func testPart2() async throws {
    #expect(String(describing: Day12(data: smallTest1).part2()) == "80")
    #expect(String(describing: Day12(data: smallTest2).part2()) == "436")
    #expect(String(describing: Day12(data: ETest).part2()) == "236")
    #expect(String(describing: Day12(data: ABBATest).part2()) == "368")
    #expect(String(describing: Day12(data: bigTest).part2()) == "1206")
  }
}
