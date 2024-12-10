import Testing

@testable import AdventOfCode

struct Day10Tests {

  let smallTestInput = """
  0123
  1234
  8765
  9876
  
  """
  
  let largeTestInput = """
  89010123
  78121874
  87430965
  96549874
  45678903
  32019012
  01329801
  10456732
  
  """

  @Test func testPart1() async throws {
    #expect(String(describing: Day10(data: smallTestInput).part1()) == "1")
    #expect(String(describing: Day10(data: largeTestInput).part1()) == "36")
  }

  @Test func testPart2() async throws {
    #expect(true)
  }
}
