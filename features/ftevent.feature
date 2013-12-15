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

  #@announce
  Scenario: 10 The event folder is created based on event.yml data
    Given a directory named "2event"
    And example file "features/media/events/event.yml" copied to "2event"
    
    When I cd to "2event"
    And I successfully run `ftls_ftevent`

    Then a directory named "20130102-08_01 Круиз Балтика" should exist
    And a file named "20130102-08_01 Круиз Балтика/event.yml" should exist 
#    And example files from "features/media/sony_jpg" copied to "2event" named:
#  | DSC03403.JPG |
#  | DSC03313.JPG |
#  | DSC03499.JPG |
#  | DSC03802.JPG |
#  | DSC04032.JPG |
#    Then the stdout should contain each of:
#   | 20130103-103254_ANB DSC03313.JPG |
#   | 20130103-153908_ANB DSC03403.JPG |
#   | 20130104-120745_ANB DSC03499.JPG |
#   | 20130105-150446_ANB DSC03802.JPG |
#   | 20130107-115201_ANB DSC04032.JPG |
#    And the following files should exist:
#   | ./20130103-103254_ANB DSC03313.JPG |
#   | ./20130103-153908_ANB DSC03403.JPG |
#   | ./20130104-120745_ANB DSC03499.JPG |
#   | ./20130105-150446_ANB DSC03802.JPG |
#   | ./20130107-115201_ANB DSC04032.JPG |
#    And the following files should not exist:
#   | ./DSC03313.JPG |
#   | ./DSC03403.JPG |
#   | ./DSC03499.JPG |
#   | ./DSC03802.JPG |
#   | ./DSC04032.JPG |
