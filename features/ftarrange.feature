# language: en
Feature: Arrange files into the given folder
  In order to simplify the further processing of the media files coming
  from different sources (flash cards, smartphones etc.)
  As a photographer
  I want to get all the given files to be arranged in one 'working' folder

  #@announce:
  Scenario: 00 Default output with -h produces usage information
    When I successfully run `ftarrange -h`
    Then the stderr should contain each of:
    | Keep Your Photos In Order |
    | ANB                       |
    | Example:                  |
    | Usage:                    |
    | Options:                  |
    | -w FLD --working_folder   |
    | -D --debug                |
    | -h --help                 |
    | --version                 |
    | -v                        |

    #@announce
  Scenario: 01 Output with -v produces version information
    When I successfully run `ftevent -v`
    Then the output should match /[0-9]+\.[0-9]+\.[0-9]+ \(core [0-9]+\.[0-9]+\.[0-9]+\)/

  #@announce
  Scenario: 10 Fails if WORKING_FOLDER does not exist
    Given empty files named:
    | foto1.jpg |
    | foto2.arw |
    | video.mts |
    When I run `ftls_ftarrange -w FOLDER`
    Then the exit status should not be 0
    And the stderr from "ftls_ftarrange -w FOLDER" should contain "FOLDER does not exist"
    And the stdout from "ftls_ftarrange -w FOLDER" should not contain any of:
    | foto1.jpg |
    | foto2.arw |
    | video.mts |
    And a directory named "FOLDER" should not exist
    And a directory named "FOLDER/RAW" should not exist
    And a directory named "FOLDER/VIDEO" should not exist
    And the following files should not exist:
    | FOLDER/foto1.jpg |
    | FOLDER/RAW/foto2.arw |
    | FOLDER/VIDEO/video.mts |

  #@announce
  Scenario: 20 Fails if WORKING_FOLDER is not a folder
    Given empty files named:
    | foto1.jpg |
    | foto2.arw |
    | video.mts |
    | FOLDER |
    When I run `ftls_ftarrange -w FOLDER`
    Then the exit status should not be 0
    And the stderr from "ftls_ftarrange -w FOLDER" should contain "FOLDER is not a directory"
    And the stdout from "ftls_ftarrange -w FOLDER" should not contain any of:
    | foto1.jpg |
    | foto2.arw |
    | video.mts |
    And a directory named "FOLDER" should not exist
    And a directory named "FOLDER/RAW" should not exist
    And a directory named "FOLDER/VIDEO" should not exist
    And the following files should not exist:
    | FOLDER/foto1.jpg |
    | FOLDER/RAW/foto2.arw |
    | FOLDER/VIDEO/video.mts |

    #@announce:
  Scenario: 30 Collects and arranges files in WORKING_FOLDER
    Given a directory named "FOLDER"
    And empty files named:
    | foto1.jpg |
    | foto2.arw |
    | video.mts |
    When I successfully run `ftls_ftarrange -w FOLDER`
    Then the stdout from "ftls_ftarrange -w FOLDER" should contain each of:
    | foto1.jpg |
    | foto2.arw |
    | video.mts |
    And a directory named "FOLDER" should exist
    And a directory named "FOLDER/RAW" should exist
    And a directory named "FOLDER/VIDEO" should exist
    And the following files should exist:
    | FOLDER/foto1.jpg |
    | FOLDER/RAW/foto2.arw |
    | FOLDER/VIDEO/video.mts |

    #@announce:
  Scenario: 40 Keeps the RAW and VIDEO subfolders if they are already exist
    Given a directory named "FOLDER"
    And a directory named "FOLDER/RAW"
    And a directory named "FOLDER/VIDEO"
    And empty files named:
    | foto1.jpg |
    | foto2.arw |
    | video.mts |
    | FOLDER/RAW/foto2keep.arw |
    | FOLDER/VIDEO/video2keep.mts |
    When I successfully run `ftls_ftarrange -w FOLDER`
    Then the stdout from "ftls_ftarrange -w FOLDER" should contain each of:
    | foto1.jpg |
    | foto2.arw |
    | video.mts |
    And a directory named "FOLDER" should exist
    And a directory named "FOLDER/RAW" should exist
    And a directory named "FOLDER/VIDEO" should exist
    And the following files should exist:
    | FOLDER/foto1.jpg |
    | FOLDER/RAW/foto2.arw |
    | FOLDER/VIDEO/video.mts |
    | FOLDER/RAW/foto2keep.arw |
    | FOLDER/VIDEO/video2keep.mts |

