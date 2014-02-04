# language: en
# encoding: UTF-8

Feature: Set EXIF tags in photo and video files
  In order to have all my photo and video files tagged with EXIF matadata
  As a photographer
  I want to get the given files to be saved with given event tags inside

  # TODO: only supported for tag write files!

  #@announce
  Scenario: 00 Default output with -h produces usage information 
    When I successfully run `fttagset -h`
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
    When I successfully run `fttagset -v`
    Then the output should match /[0-9]+\.[0-9]+\.[0-9]+ \(core [0-9]+\.[0-9]+\.[0-9]+\)/


# DateTimeOriginal                : 2013-01-03 10:32:20
# CreateDate                      : 2013-01-03 10:32:20
# ModifyDate                      : 2013-01-12 16:09:06
# Creator                         : Andrey Bizyaev (photographer), Andrey Bizyaev (camera owner)
# Copyright                       : 2013 (c) Andrey Bizyaev. All Rights Reserved.
# +Keywords                        : круиз, путешествие
# LocationCreatedWorldRegion      : Europe
# Country                         : Russia
# CountryCode                     : RU
# State                           : Санкт-Петербург
# City                            : Санкт-Петербург
# Location                        : Дворцовая площадь
# GPSLatitude                     : 59 56 21.06900000 N
# GPSLatitudeRef                  : North
# GPSLongitude                    : 30 18 50.06700000 E
# GPSLongitudeRef                 : East
# GPSAltitude                     : 0.5 m Above Sea Level
# GPSAltitudeRef                  : Above Sea Level
# +CollectionName                  : Круиз Балтика - Питер
# -CollectionURI                   : anblab.net/
# ImageUniqueID                   : 20130112-O7LS5
# CodedCharacterSet               : UTF8

  @announce
  Scenario: 10 The jpg file is saved with core tags set (ASCII charset)
    Given a directory named "2settag"
    And example file "features/media/events/event.yml" copied to "2settag"
    And example files from "features/media/renamed" copied to "2settag" named:
    | 20130103-103254_ANB DSC03313.JPG |

    When I cd to "2settag"
    And I successfully run `fttags '20130103-103254_ANB DSC03313.JPG'`
    
    Then the stdout from "fttags '20130103-103254_ANB DSC03313.JPG'" should not contain any of:
    | Keywords       |
    | CollectionName |
    | CollectionURI  |

    When I successfully run `ftls_fttagset`

    Then the stdout from "ftls_fttagset" should contain "20130103-103254_ANB DSC03313.JPG"

    When I successfully run `fttags '20130103-103254_ANB DSC03313.JPG'`
    Then the stdout from "fttags '20130103-103254_ANB DSC03313.JPG'" should contain each of:
    | CollectionName |
    | Baltica Travel |
    | CollectionURI  |
    | anblab.net     |
    | Keywords       |
    | what-travel    |
    | who-Andrew     |
    | where-Baltic   |
    | why-vacation   |
    | how-fine       |
    | method-digicam |

