import Testing

@testable import AdventOfCode

struct Day13Tests {

  let testData = """
  Button A: X+94, Y+34
  Button B: X+22, Y+67
  Prize: X=8400, Y=5400

  Button A: X+26, Y+66
  Button B: X+67, Y+21
  Prize: X=12748, Y=12176

  Button A: X+17, Y+86
  Button B: X+84, Y+37
  Prize: X=7870, Y=6450

  Button A: X+69, Y+23
  Button B: X+27, Y+71
  Prize: X=18641, Y=10279
  
  """
  
  @Test func testParse() async throws {
    let day13 = Day13(data: testData)
    #expect(day13.buttons.count == 4)
    let button1 = day13.buttons[0]
    #expect(button1.aAdd == (94, 34))
    #expect(button1.bAdd == (22, 67))
  }
  
  @Test func testPart1() async throws {
    #expect(String(describing: Day13(data: testData).part1()) == "480")
  }

  @Test func testPart2() async throws {
    #expect(String(describing: Day13(data: testData).part2()) == "875318608908")
  }
}
