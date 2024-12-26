# Advent of Code 2024 In Swift

[![Language](https://img.shields.io/badge/language-Swift-red.svg)](https://swift.org)

This year, for the first time, I participated in the 25 days of Eric Wastl's [Advent Of Code](https://adventofcode.com). I had a ton of fun, and will certainly be back next year.

All of the code I used is in this repo, however messy it is. If you get stuck, feel free to look at some of my code, but I highly recommend you try to understand what my code is doing and then implement it yourself, rather than copying. You learn a lot more that way.
If you want to reference your answer, I have published [a few executables](https://github.com/BruceMcRooster/aoc-2024/releases/tag/2024) that *should* work as a reference for test cases you might make. Just create your test input in a folder in `Data/Sources/DayXX.txt` relative to the executable and it should work. No promises, though. Feel free to reach out if my code doesn't correctly solve some input you give it. 

If you are doing these challenges in Swift, I highly recommend using the starter template [here](https://github.com/apple/swift-aoc-starter-example). 
I also recommend copying the [`GetDay`](/GetDay) executable I made to automatically download the input file for a specific day and set up all the other things you need using `./GetDay <day num>`. Just remember to add the `.advent-of-code` file it generates to store your cookie to your `.gitignore`.

## Usage

If you clone this repository, make sure you have Swift installed. Then, you can run `swift run AdventOfCode <day number>`, or `swift run -c release --benchmark <day number>` if you want to fully compile and benchmark the code on a certain day. You can also pass the `--all` flag instead of a day number to run every challenge.


Happy Coding!
