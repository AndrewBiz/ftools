# language: en
Feature: Pack files to events
  In order to work with semantically grouped media files rather than 
  with long unnamed file lists
  As a photographer
  I want to get the given files to be collected into 'event' folder

  #@announce
  Scenario: 00 Default output with -h produces usage information 
    When I successfully run `ftevent -h`
    Then the stderr should contain each of:
    | Keep Your Photos Clean And Tidy |
    | © ANB                           |
    | Example:                        |
    | Usage:                          |
    | Options:                        |
    | -D --debug                      |
    | -h --help                       |
    | --version                       |
    | -v                              |

  #@announce
  Scenario: 01 Output with -v produces version information 
    When I successfully run `ftevent -v`
    Then the output should match /[0-9]+\.[0-9]+\.[0-9]+ \(core [0-9]+\.[0-9]+\.[0-9]+\)/
