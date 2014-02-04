# language: en
Feature: Clean filenames
  In order to roll-back the file name changes
  As a photographer
  I want to get the given files to be renamed to the original names 
  (the names they get in digital photo camera)

  #@announce
  Scenario: 00 Default output with -h produces usage information 
    When I successfully run `ftclname -h`
    Then the stderr should contain each of:
    | Keep Your Photos In Order |
    | ANB                       |
    | Example:                  |
    | Usage:                    |
    | Options:                  |
    | -D --debug                |
    | -h --help                 |
    | --version                 |
    | -v                        |

  #@announce
  Scenario: 01 Output with -v produces version information 
    When I successfully run `ftclname -v`
    Then the output should match /[0-9]+\.[0-9]+\.[0-9]+ \(core [0-9]+\.[0-9]+\.[0-9]+\)/

  #@announce
  Scenario: 1 Standard named files are renamed to origin
    Given empty files named:
    | 20130101-005311_ANB DSC00001.JPG    |
    | 20130102-005311_ANBA DSC00002.JPG   |
    | 20130103-005311_ANBAN DSC00003.JPG  |
    | 20130104-005311_ANBANB DSC00004.JPG |
    When I successfully run `ftls_ftclname`
    Then the stdout should contain each of:
    | DSC00001.JPG |
    | DSC00002.JPG |
    | DSC00003.JPG |
    | DSC00004.JPG |
    And the stdout should not contain any of:
    | 20130101-005311 |
    | ANB             |
    | ANBA            |
    | ANBAN           |
    | ANBANB          |
    And the following files should exist:
    | DSC00001.JPG |
    | DSC00002.JPG |
    | DSC00003.JPG |
    | DSC00004.JPG |

  #@announce
  Scenario: 2 Non-Standard named files are renamed to origin as well
    Given empty files named:
    | 20130101-105311_ANB[12345678-dfdfdfdf]{flags}DSC10001.JPG |
    | 20130102-105311_ANB[12345678-erererer]DSC10002.JPG        |
    | 20130103-105311_ANB_DSC10003.JPG                          |
    | 20130104-105311_ANB-DSC10004.JPG                          |
    | 20130105-1053_ANB_DSC10005.JPG                            |
    | 20130106-1053-ANB_DSC10006.JPG                            |
    | 20130107-1053_ANB DSC10007.JPG                            |
    | 20130108-1053_DSC10008.JPG                                |
    | 20130109-1053 DSC10009.JPG                                |
    | 20130110_DSC10010.JPG                                     |
    | 20130111 DSC10011.JPG                                     |
    | 2013_DSC10012.JPG                                         |
    | 2013-DSC10013.JPG                                         |
    | 2013 DSC10014.JPG                                         |
    | CLEAN NAME.JPG                                            |
    | CLEAN_NAME.JPG                                            |
    | CLEAN-NAME.JPG                                            |
    | CLEANNAME.JPG                                             |
    When I successfully run `ftls_ftclname`
    Then the stdout should contain each of:
    | DSC10001.JPG   |
    | DSC10002.JPG   |
    | DSC10003.JPG   |
    | DSC10004.JPG   |
    | DSC10005.JPG   |
    | DSC10006.JPG   |
    | DSC10007.JPG   |
    | DSC10008.JPG   |
    | DSC10009.JPG   |
    | DSC10010.JPG   |
    | DSC10011.JPG   |
    | DSC10012.JPG   |
    | DSC10013.JPG   |
    | DSC10014.JPG   |
    | CLEAN NAME.JPG |
    | CLEAN_NAME.JPG |
    | CLEAN-NAME.JPG |
    | CLEANNAME.JPG  |
    And the stdout should not contain any of:
    | 20130101-105311_ANB[12345678-dfdfdfdf]{flags} |
    | 20130102-105311_ANB[12345678-erererer]        |
    | 20130103-105311_ANB_                          |
    | 20130104-105311_ANB-                          |
    | 20130105-1053_ANB_                            |
    | 20130106-1053-ANB_                            |
    | 20130107-1053_ANB                             |
    | 20130108-1053_                                |
    | 20130109-1053                                 |
    | 20130110_                                     |
    | 20130111                                      |
    | 2013_                                         |
    | 2013-                                         |
    | 2013                                          |
    And the following files should exist:
    | DSC10001.JPG   |
    | DSC10002.JPG   |
    | DSC10003.JPG   |
    | DSC10004.JPG   |
    | DSC10005.JPG   |
    | DSC10006.JPG   |
    | DSC10007.JPG   |
    | DSC10008.JPG   |
    | DSC10009.JPG   |
    | DSC10010.JPG   |
    | DSC10011.JPG   |
    | DSC10012.JPG   |
    | DSC10013.JPG   |
    | DSC10014.JPG   |
    | CLEAN NAME.JPG |
    | CLEAN_NAME.JPG |
    | CLEAN-NAME.JPG |
    | CLEANNAME.JPG  |
