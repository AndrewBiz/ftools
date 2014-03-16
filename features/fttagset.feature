# language: en
# encoding: UTF-8

Feature: Set EXIF tags in photo and video files
  In order to have all my photo and video files tagged with EXIF matadata
  As a photographer
  I want to get the given files to be saved with given event tags inside

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
    | -e EVT --event=EVT        |
    | -c CRT --creators=CRT     |
    | -p PLC --places=PLC       |

  #@announce
  Scenario: 01 Output with -v produces version information 
    When I successfully run `fttagset -v`
    Then the output should match /[0-9]+\.[0-9]+\.[0-9]+ \(core [0-9]+\.[0-9]+\.[0-9]+\)/

  #@announce
  Scenario: 10 Fails with incorrect creators.yml
    Given a directory named "2settag"
    And example file "features/media/events/event.yml" copied to "2settag"
    And example file "features/media/directories/creators_wrong.yml" copied to file "2settag/creators.yml"
    And example file "features/media/directories/places.yml" copied to "2settag"
    And example files from "features/media/renamed" copied to "2settag" named:
    | 20130103-103254_ANB DSC03313.JPG |

    When I cd to "2settag"
    And I run `ftls_fttagset`

    Then the exit status should not be 0
    And the stderr should contain each of:
    | uuu: :creator:   |
    | uuu: :copyright: |
    | cr1: :creator:   |
    | cr2: :creator:   |
    | cr3: :creator:   |
    | cr4: :creator:   |
    | co1: :copyright: |
    | co2: :copyright: |
    And the stderr should not contain any of:
    | anb: :creator:   |
    | anb: :copyright: |
    | cr1: :copyright: |
    | cr2: :copyright: |
    | cr3: :copyright: |
    | cr4: :copyright: |
    | co1: :creator:   |
    | co2: :creator:   |

  # @announce
  Scenario: 15 Fails if the PLACE is unknown
    Given a directory named "2settag"
    And example file "features/media/events/event.yml" copied to "2settag"
    And example file "features/media/directories/creators.yml" copied to file "2settag/creators.yml"
    And example file "features/media/directories/places_wrong.yml" copied to file "2settag/places.yml"
    And example file "features/media/renamed/20130103-103254_ANB DSC03313.JPG" copied to file "2settag/20130103-103254_ANB DSC03313.JPG"

    When I cd to "2settag"
    And I run `ftls_fttagset`

    Then the exit status should not be 0
    Then the stderr should contain each of:
    | Place 'peterburg' is not found   |

  #@announce
  Scenario: 20 Rejects update the file if the AUTHOR is unknown
    Given a directory named "2settag"
    And example file "features/media/events/event.yml" copied to "2settag"
    And example file "features/media/directories/creators.yml" copied to "2settag"
    And example file "features/media/directories/places.yml" copied to "2settag"
    And example file "features/media/renamed/20130103-103254_ANB DSC03313.JPG" copied to file "2settag/20130103-103254_XXX DSC03313.JPG"

    When I cd to "2settag"
    And I successfully run `ftls_fttagset`

    Then the stderr should contain each of:
    | 20130103-103254_XXX DSC03313.JPG |
    | Author 'XXX' is not found        |

   @announce
  Scenario: 30 The jpg file is saved with core tags set (ASCII charset)
    Given a directory named "2settag"
    And example file "features/media/events/event.yml" copied to "2settag"
    And example file "features/media/directories/creators.yml" copied to "2settag"
    And example file "features/media/directories/places.yml" copied to "2settag"
    And example files from "features/media/renamed" copied to "2settag" named:
    | 20130103-103254_ANB DSC03313.JPG |

    When I cd to "2settag"
    And I successfully run `fttags '20130103-103254_ANB DSC03313.JPG'`

    Then the stdout from "fttags '20130103-103254_ANB DSC03313.JPG'" should not contain any of:
    | Creator                  |
    | Copyright                |
    | Keywords                 |
    | CollectionName           |
    | CollectionURI            |
    | LocationShownWorldRegion |
    | Country                  |
    | CountryCode              |
    | State                    |
    | City                     |
    | Location                 |
    | GPSLatitude              |
    | GPSLatitudeRef           |
    | GPSLongitude             |
    | GPSLongitudeRef          |
    | GPSAltitude              |
    | GPSAltitudeRef           |
    | CodedCharacterSet        |
    | UTF8                     |

    When I successfully run `ftls_fttagset`

    Then the stdout from "ftls_fttagset" should contain "20130103-103254_ANB DSC03313.JPG"

    When I successfully run `fttags '20130103-103254_ANB DSC03313.JPG'`
    Then the stdout from "fttags '20130103-103254_ANB DSC03313.JPG'" should contain each of:
    | Creator                                      |
    | Andrey Bizyaev (photographer)                |
    | Andrey Bizyaev (camera owner)                |
    | Copyright                                    |
    | 2013 (c) Andrey Bizyaev. All Rights Reserved |
    | Keywords                                     |
    | what-travel                                  |
    | who-Andrew                                   |
    | where-Baltic                                 |
    | why-vacation                                 |
    | how-fine                                     |
    | method-digicam                               |
    | LocationShownWorldRegion                     |
    | Europe                                       |
    | Country                                      |
    | Russia                                       |
    | LocationShownCountryCode                     |
    | RU                                           |
    | State                                        |
    | Peterburg region                             |
    | City                                         |
    | Peterburg                                    |
    | Location                                     |
    | Palace square                                |
    | GPSLatitude                                  |
    | 59 56 21.069                                 |
    | GPSLatitudeRef                               |
    | North                                        |
    | GPSLongitude                                 |
    | 30 18 50.067                                 |
    | GPSLongitudeRef                              |
    | East                                         |
    | GPSAltitude                                  |
    | 0.5                                          |
    | GPSAltitudeRef                               |
    | Above Sea Level                              |
    | CollectionName                               |
    | Baltica Travel                               |
    | CollectionURI                                |
    | anblab.net                                   |
    | CodedCharacterSet                            |
    | UTF8                                         |

# -DateTimeOriginal                : 2013-01-03 10:32:20
# -CreateDate                      : 2013-01-03 10:32:20
# -ModifyDate                      : 2013-01-12 16:09:06
# +Creator                         : Andrey Bizyaev (photographer), Andrey Bizyaev (camera owner)
# +Copyright                       : 2013 (c) Andrey Bizyaev. All Rights Reserved.
# +Keywords                        : круиз, путешествие
# +LocationShownWorldRegion        : Europe
# +Country                         : Russia
# +LocationShownCountryCode        : RU
# +State                           : Санкт-Петербург
# +City                            : Санкт-Петербург
# +Location                        : Дворцовая площадь
# +GPSLatitude                     : 59 56 21.06900000 N
# +GPSLatitudeRef                  : North
# +GPSLongitude                    : 30 18 50.06700000 E
# +GPSLongitudeRef                 : East
# +GPSAltitude                     : 0.5 m Above Sea Level
# +GPSAltitudeRef                  : Above Sea Level
# +CollectionName                  : Круиз Балтика - Питер
# +CollectionURI                   : anblab.net/
# ImageUniqueID                   : 20130112-O7LS5
# +CodedCharacterSet               : UTF8
