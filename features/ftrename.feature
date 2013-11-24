# language: en
Feature: Rename photo and video files
  In order to have all my photo and video files (taken with my digital camera)
  get well readable and informative filenames
  As a photographer
  I want to get the given files to be renamed to the standard ftools name template

  #@announce
  Scenario: 00 Default output with -h produces usage information 
    When I successfully run `ftrename -h`
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
    When I successfully run `ftrename -v`
    Then the output should match /[0-9]+\.[0-9]+\.[0-9]+ \(core [0-9]+\.[0-9]+\.[0-9]+\)/

  #@announce
  Scenario: 1 Original named files are renamed to ftools standard
    Given a directory named "2rename"
    And example files from "features/media/sony_jpg" copied to "2rename" named:
   | DSC03403.JPG |
   | DSC03313.JPG |
   | DSC03499.JPG |
   | DSC03802.JPG |
   | DSC04032.JPG |

    When I cd to "2rename"
    And I successfully run `ftls_ftrename -a anb`

    Then the stdout should contain each of:
    | 20130103-103254_ANB DSC03313.JPG |
    | 20130103-153908_ANB DSC03403.JPG |
    | 20130104-120745_ANB DSC03499.JPG |
    | 20130105-150446_ANB DSC03802.JPG |
    | 20130107-115201_ANB DSC04032.JPG |
