import Testing

@testable import AdventOfCode

struct Day17Tests {

  let testData = """
  Register A: 729
  Register B: 0
  Register C: 0

  Program: 0,1,5,4,3,0
  
  """
  
  let testData2 = """
  Register A: 10
  Register B: 0
  Register C: 0

  Program: 5,0,5,1,5,4

  """
  
  let testData3 = """
  Register A: 2024
  Register B: 0
  Register C: 0

  Program: 0,1,5,4,3,0

  """
  
  let testData4 = """
  Register A: 0
  Register B: 29
  Register C: 0

  Program: 1,7,5,5

  """
  
  let testData5 = """
  Register A: 0
  Register B: 2024
  Register C: 43690

  Program: 4,0,5,5

  """
  
  let testData6 = """
  Register A: 0
  Register B: 0
  Register C: 9

  Program: 2,6,5,5

  """

  @Test func testPart1() async throws {
    #expect(String(describing: Day17(data: testData).part1()) == "4,6,3,5,6,3,5,2,1,0")
    #expect(String(describing: Day17(data: testData2).part1()) == "0,1,2")
    #expect(String(describing: Day17(data: testData3).part1()) == "4,2,5,6,7,7,7,7,3,1,0")
    #expect(String(describing: Day17(data: testData4).part1()) == "2")
    #expect(String(describing: Day17(data: testData5).part1()) == "2")
    #expect(String(describing: Day17(data: testData6).part1()) == "1")
  }

  @Test func testPart2() async throws {
    #expect(true)
  }
}
