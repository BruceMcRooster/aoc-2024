import Testing

@testable import AdventOfCode

struct Day03Tests {

  let testData = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

  @Test func testPart1() async throws {
    #expect(String(describing: Day03(data: testData).part1()) == "161")
  }

  let otherTestData = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
  
  @Test func testPart2() async throws {
    #expect(String(describing: Day03(data: otherTestData).part2()) == "48")
  }
}
