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
    | -n --name-only            |
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

  #@announce
  Scenario: 30 The jpg file produces ERROR in no DateTimeOriginal is set
    Given a directory named "2settag"
    And example file "features/media/iphone/IMG_0887_no_dto_cd.jpg" copied to file "2settag/IMG_0887.JPG"

    When I cd to "2settag"
    And I successfully run `fttags 'IMG_0887.JPG'`

    Then the stdout from "fttags 'IMG_0887.JPG'" should not contain any of:
      |DateTimeOriginal|
      |CreateDate|

    When I successfully run `ftls_ftfixdate -s -10`

    Then the stderr from "ftls_ftfixdate -s -10" should contain "IMG_0887.JPG"
    And the stderr from "ftls_ftfixdate -s -10" should contain "ERROR: './IMG_0887.JPG' - DateTimeOriginal is not set"

    When I successfully run `fttags 'IMG_0887.JPG'`
    Then the stdout from "fttags 'IMG_0887.JPG'" should not contain any of:
      |DateTimeOriginal|
      |CreateDate|

      #@announce
  Scenario: 40 The jpg file does not touch CreateDate if it is not set
    Given a directory named "2settag"
    And example file "features/media/iphone/IMG_0887_no_cd.jpg" copied to file "2settag/IMG_0887.JPG"

    When I cd to "2settag"
    And I successfully run `fttags 'IMG_0887.JPG'`

    Then the stdout from "fttags 'IMG_0887.JPG'" should match each of:
      |/^DateTimeOriginal( *):( *)2014-07-18 10:00:00/|
    And the stdout from "fttags 'IMG_0887.JPG'" should not contain any of:
      |CreateDate|

    When I successfully run `ftls_ftfixdate -s 10`

    Then the stderr from "ftls_ftfixdate -s 10" should contain "IMG_0887.JPG"
    And the stderr from "ftls_ftfixdate -s 10" should not contain "ERROR"

    When I successfully run `fttags 'IMG_0887.JPG'`
    Then the stdout from "fttags 'IMG_0887.JPG'" should not contain any of:
      |CreateDate|
    Then the stdout from "fttags 'IMG_0887.JPG'" should match each of:
      |/^DateTimeOriginal( *):( *)2014-07-18 10:00:10/|

      #@announce
  Scenario: 50 In NAME-ONLY mode the jpg file is renamed while DTO and CreateDate are kept unchanged
    Given a directory named "2settag"
    And example file "features/media/renamed/20130103-103254_ANB DSC03313_notagset.JPG" copied to file "2settag/20130103-103254_ANB DSC03313.JPG"

    When I cd to "2settag"
    And I successfully run `fttags '20130103-103254_ANB DSC03313.JPG'`

    Then the stdout from "fttags '20130103-103254_ANB DSC03313.JPG'" should match each of:
      |/^DateTimeOriginal( *):( *)2013-01-03 10:32:54/|
      |/^CreateDate( *):( *)2013-01-03 10:32:54/|

    When I successfully run `ftls_ftfixdate -s 100 -n`

    Then the stdout from "ftls_ftfixdate -s 100 -n" should contain "20130103-103434_ANB DSC03313.JPG"
    And the following files should exist:
      | 20130103-103434_ANB DSC03313.JPG |

    When I successfully run `fttags '20130103-103434_ANB DSC03313.JPG'`
    Then the stdout from "fttags '20130103-103434_ANB DSC03313.JPG'" should match each of:
      |/^DateTimeOriginal( *):( *)2013-01-03 10:32:54/|
      |/^CreateDate( *):( *)2013-01-03 10:32:54/|


      #@announce
  Scenario: 60 In NAME-ONLY mode the jpg file produces error if the name is not standard 
    Given a directory named "2settag"
    And example file "features/media/renamed/20130103-103254_ANB DSC03313_notagset.JPG" copied to file "2settag/DSC03313.JPG"

    When I cd to "2settag"
    And I successfully run `fttags 'DSC03313.JPG'`

    Then the stdout from "fttags 'DSC03313.JPG'" should match each of:
      |/^DateTimeOriginal( *):( *)2013-01-03 10:32:54/|
      |/^CreateDate( *):( *)2013-01-03 10:32:54/|

    When I successfully run `ftls_ftfixdate -s 100 -n`
    
    Then the stderr from "ftls_ftfixdate -s 100 -n" should contain "ERROR: './DSC03313.JPG' - incorrect file name"

    When I successfully run `fttags 'DSC03313.JPG'`
    Then the stdout from "fttags 'DSC03313.JPG'" should match each of:
      |/^DateTimeOriginal( *):( *)2013-01-03 10:32:54/|
      |/^CreateDate( *):( *)2013-01-03 10:32:54/|
