import Testing

@testable import AdventOfCode

struct Day23Tests {

  let testData = """
  kh-tc
  qp-kh
  de-cg
  ka-co
  yn-aq
  qp-ub
  cg-tb
  vc-aq
  tb-ka
  wh-tc
  yn-cg
  kh-ub
  ta-co
  de-co
  tc-td
  tb-wq
  wh-td
  ta-ka
  td-qp
  aq-cg
  wq-ub
  ub-vc
  de-ta
  wq-aq
  wq-vc
  wh-yn
  ka-de
  kh-ta
  co-tc
  wh-qp
  tb-vc
  td-yn
  
  """

  @Test func testPart1() async throws {
    #expect(String(describing: Day23(data: testData).part1()) == "7")
  }

  @Test func testPart2() async throws {
    #expect(String(describing: Day23(data: testData).part2()) == "co,de,ka,ta")
  }
}
