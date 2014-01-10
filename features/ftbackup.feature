# language: en
Feature: Backup files
  In order to be at the safe side
  As a photographer
  I want to get the given files to be backed up

  #@announce
  Scenario: 00 Default output with -h produces usage information 
    When I successfully run `ftbackup -h`
    Then the stderr should contain each of:
    | Keep Your Photos Clean And Tidy |
    | ANB                             |
    | Example:                        |
    | Usage:                          |
    | Options:                        |
    | -D --debug                      |
    | -h --help                       |
    | --version                       |
    | -v                              |

  #@announce
  Scenario: 01 Output with -v produces version information 
    When I successfully run `ftbackup -v`
    Then the output should match /[0-9]+\.[0-9]+\.[0-9]+ \(core [0-9]+\.[0-9]+\.[0-9]+\)/

  #@announce
  Scenario: 1 Default backup is made into ./backup dir
    Given empty files named:
    | foto2backup.jpg |
    | foto2backup.wav |
    When I successfully run `ftls_ftbackup`
    Then the stdout should contain each of:
    | foto2backup.jpg |
    | foto2backup.wav |
    And a directory named "backup" should exist
    And the following files should exist:
    | backup/foto2backup.jpg |
    | backup/foto2backup.wav |

  #@announce
  Scenario: 2 backup is made into given dir
    Given empty files named:
    | foto2newbackup.jpg |
    | foto2newbackup.wav |
    When I successfully run `ftls_ftbackup -b newbackup`
    Then the stdout should contain each of:
    | foto2newbackup.jpg |
    | foto2newbackup.wav |
    And a directory named "newbackup" should exist
    And the following files should exist:
    | newbackup/foto2newbackup.jpg |
    | newbackup/foto2newbackup.wav |

