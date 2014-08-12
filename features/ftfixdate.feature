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
    | -s --shift-seconds        |
    | -D --debug                |
    | -h --help                 |
    | --version                 |
    | -v                        |

  #@announce
  Scenario: 01 Output with -v produces version information
    When I successfully run `ftfixdate -v`
    Then the output should match /[0-9]+\.[0-9]+\.[0-9]+ \(core [0-9]+\.[0-9]+\.[0-9]+\)/


  #@announce
  Scenario: 10 The jpg file is saved with DTO and CreateDate shifted to 100 seconds PLUS
    Given a directory named "2settag"
    And example file "features/media/renamed/20130103-103254_ANB DSC03313_notagset.JPG" copied to file "2settag/20130103-103254_ANB DSC03313.JPG"

    When I cd to "2settag"
    And I successfully run `fttags '20130103-103254_ANB DSC03313.JPG'`

    Then the stdout from "fttags '20130103-103254_ANB DSC03313.JPG'" should match each of:
      |/^DateTimeOriginal( *):( *)2013-01-03 10:32:54/|
      |/^CreateDate( *):( *)2013-01-03 10:32:54/|

    When I successfully run `ftls_ftfixdate -s 100`

    Then the stderr from "ftls_ftfixdate -s 100" should contain "20130103-103254_ANB DSC03313.JPG"

    When I successfully run `fttags '20130103-103254_ANB DSC03313.JPG'`
    Then the stdout from "fttags '20130103-103254_ANB DSC03313.JPG'" should match each of:
      |/^DateTimeOriginal( *):( *)2013-01-03 10:34:34/|
      |/^CreateDate( *):( *)2013-01-03 10:34:34/|

  #@announce
  Scenario: 20 The jpg file is saved with DTO and CreateDate shifted to MINUS 10 seconds
    Given a directory named "2settag"
    And example file "features/media/renamed/20130103-103254_ANB DSC03313_notagset.JPG" copied to file "2settag/20130103-103254_ANB DSC03313.JPG"

    When I cd to "2settag"
    And I successfully run `fttags '20130103-103254_ANB DSC03313.JPG'`

    Then the stdout from "fttags '20130103-103254_ANB DSC03313.JPG'" should match each of:
      |/^DateTimeOriginal( *):( *)2013-01-03 10:32:54/|
      |/^CreateDate( *):( *)2013-01-03 10:32:54/|

    When I successfully run `ftls_ftfixdate -s -10`

    Then the stderr from "ftls_ftfixdate -s -10" should contain "20130103-103254_ANB DSC03313.JPG"

    When I successfully run `fttags '20130103-103254_ANB DSC03313.JPG'`
    Then the stdout from "fttags '20130103-103254_ANB DSC03313.JPG'" should match each of:
      |/^DateTimeOriginal( *):( *)2013-01-03 10:32:44/|
      |/^CreateDate( *):( *)2013-01-03 10:32:44/|

