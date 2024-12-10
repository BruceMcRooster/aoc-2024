import Testing

@testable import AdventOfCode

struct Day04Tests {

  let simplePuzzle = """
  ..X...
  .SAMX.
  .A..A.
  XMAS.S
  .X....
  
  """
  
  let biggerPuzzle = """
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
  
  """

  @Test func testParse() async throws {
    #expect(Day04(data: simplePuzzle).lineLength == 7)
  }
  
  @Test func testPart1() async throws {
    #expect(String(describing: Day04(data: simplePuzzle).part1()) == "4")
    #expect(String(describing: Day04(data: biggerPuzzle).part1()) == "18")
  }

  let simpleSecondPuzzle = """
  M.S
  .A.
  M.S

  """
  
  @Test func testPart2() async throws {
    #expect(String(describing: Day04(data: simpleSecondPuzzle).part2()) == "1")
    #expect(String(describing: Day04(data: biggerPuzzle).part2()) == "9")
  }
}
