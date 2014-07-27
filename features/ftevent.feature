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
    When I successfully run `ftevent -v`
    Then the output should match /[0-9]+\.[0-9]+\.[0-9]+ \(core [0-9]+\.[0-9]+\.[0-9]+\)/

  #@announce
  Scenario: 10 The event folder is created based on event.yml data
    Given a directory named "2event"
    And example file "features/media/events/event.yml" copied to "2event"

    When I cd to "2event"
    And I successfully run `ftls_ftevent`

    Then a directory named "20130102-08_01 Baltica Travel" should exist
    And a file named "20130102-08_01 Baltica Travel/event.yml" should exist

  #@announce
  Scenario: 15 The non-standard named files are ignored
    Given a directory named "2event"
    And example file "features/media/events/event.yml" copied to "2event"
    And example files from "features/media/sony_jpg" copied to "2event" named:
    | DSC03313.JPG |
    | DSC03403.JPG |

    When I cd to "2event"
    And I successfully run `ftls_ftevent`

    Then a directory named "20130102-08_01 Baltica Travel" should exist
    And a file named "20130102-08_01 Baltica Travel/event.yml" should exist
    And the stdout should not contain any of:
    | DSC03313.JPG |
    | DSC03403.JPG |
    And the stderr should contain each of:
    | DSC03313.JPG |
    | DSC03403.JPG |
    And the following files should exist:
    | DSC03313.JPG |
    | DSC03403.JPG |
    And the following files should not exist:
    | ./20130102-08_01 Baltica Travel/DSC03313.JPG |
    | ./20130102-08_01 Baltica Travel/DSC03403.JPG |

  #@announce
  Scenario: 20 The media files are moved to event folder
    Given a directory named "2event"
    And example file "features/media/events/event.yml" copied to "2event"
    And example files from "features/media/renamed" copied to "2event" named:
    | 20130103-103254_ANB DSC03313_notagset.JPG |
    | 20130103-153908_ANB DSC03403_alltagset.JPG |
    | 20130104-120745_ANB DSC03499.JPG |
    | 20130105-150446_ANB DSC03802.JPG |
    | 20130107-115201_ANB DSC04032.JPG |
    When I cd to "2event"
    And I successfully run `ftls_ftevent`

    Then a directory named "20130102-08_01 Baltica Travel" should exist
    And a file named "20130102-08_01 Baltica Travel/event.yml" should exist
    And the stdout should contain each of:
    | 20130103-103254_ANB DSC03313_notagset.JPG |
    | 20130103-153908_ANB DSC03403_alltagset.JPG |
    | 20130104-120745_ANB DSC03499.JPG |
    | 20130105-150446_ANB DSC03802.JPG |
    | 20130107-115201_ANB DSC04032.JPG |
    And the following files should not exist:
    | ./20130103-103254_ANB DSC03313_notagset.JPG |
    | ./20130103-153908_ANB DSC03403_alltagset.JPG |
    | ./20130104-120745_ANB DSC03499.JPG |
    | ./20130105-150446_ANB DSC03802.JPG |
    | ./20130107-115201_ANB DSC04032.JPG |
    And the following files should exist:
    | ./20130102-08_01 Baltica Travel/20130103-103254_ANB DSC03313_notagset.JPG |
    | ./20130102-08_01 Baltica Travel/20130103-153908_ANB DSC03403_alltagset.JPG |
    | ./20130102-08_01 Baltica Travel/20130104-120745_ANB DSC03499.JPG |
    | ./20130102-08_01 Baltica Travel/20130105-150446_ANB DSC03802.JPG |
    | ./20130102-08_01 Baltica Travel/20130107-115201_ANB DSC04032.JPG |

  #@announce
  Scenario: 30 Event folder is created in the given 'parent' folder
    Given a directory named "2event"
    And example file "features/media/events/event.yml" copied to "2event"
    And example files from "features/media/renamed" copied to "2event" named:
    | 20130103-103254_ANB DSC03313_notagset.JPG |
    | 20130103-153908_ANB DSC03403_alltagset.JPG |
    | 20130104-120745_ANB DSC03499.JPG |
    | 20130105-150446_ANB DSC03802.JPG |
    | 20130107-115201_ANB DSC04032.JPG |
    And a directory named "2event/parent"
    When I cd to "2event"
    And I successfully run `ftls_ftevent -p parent`

    Then a directory named "parent/20130102-08_01 Baltica Travel" should exist
    And a file named "parent/20130102-08_01 Baltica Travel/event.yml" should exist
    And the stdout should contain each of:
    | 20130103-103254_ANB DSC03313_notagset.JPG |
    | 20130103-153908_ANB DSC03403_alltagset.JPG |
    | 20130104-120745_ANB DSC03499.JPG |
    | 20130105-150446_ANB DSC03802.JPG |
    | 20130107-115201_ANB DSC04032.JPG |
    And the following files should not exist:
    | ./20130103-103254_ANB DSC03313_notagset.JPG |
    | ./20130103-153908_ANB DSC03403_alltagset.JPG |
    | ./20130104-120745_ANB DSC03499.JPG |
    | ./20130105-150446_ANB DSC03802.JPG |
    | ./20130107-115201_ANB DSC04032.JPG |
    And the following files should exist:
    | parent/20130102-08_01 Baltica Travel/20130103-103254_ANB DSC03313_notagset.JPG   |
    | parent/20130102-08_01 Baltica Travel/20130103-153908_ANB DSC03403_alltagset.JPG   |
    | parent/20130102-08_01 Baltica Travel/20130104-120745_ANB DSC03499.JPG   |
    | parent/20130102-08_01 Baltica Travel/20130105-150446_ANB DSC03802.JPG   |
    | parent/20130102-08_01 Baltica Travel/20130107-115201_ANB DSC04032.JPG   |

  #@announce
  Scenario: 40 Only date-correct media files are moved to event folder
    Given a directory named "2event"
    And example file "features/media/events/20130104-event.yml" copied to "2event"
    And example files from "features/media/renamed" copied to "2event" named:
    | 20130103-153908_ANB DSC03403_alltagset.JPG |
    | 20130104-120745_ANB DSC03499.JPG |
    | 20130105-150446_ANB DSC03802.JPG |
    | 20130107-115201_ANB DSC04032.JPG |
    When I cd to "2event"
    And I successfully run `ftls_ftevent -e 20130104-event.yml`

    Then a directory named "20130104 Baltica Travel" should exist
    And a file named "20130104 Baltica Travel/event.yml" should exist
    And the stdout should contain each of:
    | 20130104-120745_ANB DSC03499.JPG |
    And the stdout should not contain any of:
    | 20130103-153908_ANB DSC03403_alltagset.JPG |
    | 20130105-150446_ANB DSC03802.JPG |
    | 20130107-115201_ANB DSC04032.JPG |
    And the stderr should not contain any of:
    | 20130104-120745_ANB DSC03499.JPG |
    And the stderr should contain each of:
    | 20130103-153908_ANB DSC03403_alltagset.JPG |
    | 20130105-150446_ANB DSC03802.JPG |
    | 20130107-115201_ANB DSC04032.JPG |
    And the following files should not exist:
    | ./20130104-120745_ANB DSC03499.JPG |
    And the following files should exist:
    | ./20130103-153908_ANB DSC03403_alltagset.JPG |
    | ./20130105-150446_ANB DSC03802.JPG |
    | ./20130107-115201_ANB DSC04032.JPG |
    And the following files should exist:
    | ./20130104 Baltica Travel/20130104-120745_ANB DSC03499.JPG |
    And the following files should not exist:
    | ./20130104 Baltica Travel/20130103-153908_ANB DSC03403_alltagset.JPG |
    | ./20130104 Baltica Travel/20130105-150446_ANB DSC03802.JPG |
    | ./20130104 Baltica Travel/20130107-115201_ANB DSC04032.JPG |
