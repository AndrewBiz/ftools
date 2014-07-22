# language: en
# encoding: UTF-8

Feature: Set or modify EXIF DateTimeOriginal (CreateDate) in photo files
  In order to get all my photo files with the correct creation Date-Time-stamp
  As a photographer
  I want to get the given files to be saved with modified DateTimeOriginal tag

  #@announce
  Scenario: 00 Default output with -h produces usage information
    When I successfully run `ftfixdate -h`
    Then the stderr should contain each of:
    | Keep Your Photos In Order |
    | ANB                       |
    | Example:                  |
    | Usage:                    |
    | Options:                  |
    | -p --shift-plus           |
    | -m --shift-minus          |
    | -D --debug                |
    | -h --help                 |
    | --version                 |
    | -v                        |

  #@announce
  Scenario: 01 Output with -v produces version information
    When I successfully run `ftfixdate -v`
    Then the output should match /[0-9]+\.[0-9]+\.[0-9]+ \(core [0-9]+\.[0-9]+\.[0-9]+\)/
