# language: en
Feature: Fix File Modify Date
  In order to get well sorted files for the systems which use
  File Modify Date property to sort files (like Wii, Picasa etc)
  As a photographer
  I want to get the given files to be backed up

  #@announce
  Scenario: 00 Default output with -h produces usage information 
    When I successfully run `ftfixfmd -h`
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
    When I successfully run `ftfixfmd -v`
    Then the output should match /[0-9]+\.[0-9]+\.[0-9]+ \(core [0-9]+\.[0-9]+\.[0-9]+\)/
