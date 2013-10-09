# language: en
Feature: Generate a list of ftools-friendly-files
  In order to simplify chosing the foto\video files for further process
  As a photographer
  I want to get the list of foto\video files in a form of a plain text
  (one file by line)

  Background:
    Given empty files named:
    | foto.jpeg       |
    | foto.jpg        |
    | foto.tif        |
    | foto.tiff       |
    | foto.orf        |
    | foto.arw        |
    | foto.png        |
    | foto.dng        |
    | foto_wrong.psd  |
    | video.avi       |
    | video.mp4       |
    | video.mpg       |
    | video.mts       |
    | video.dv        |
    | video.mov       |
    | video_wrong.3gp |

  
  #@announce
  Scenario: 0 Default output with -h produces usage information 
    When I successfully run `ftls -h`
    Then the stderr should contain each of:
    | Keep Your Photos Clean And Tidy |
    | © ANB                           |
    | Example:                        |
    | Usage:                          |
    | Options:                        |
    | -D --debug                      |
    | -h --help                       |
    | --version                       |

  #@announce
  Scenario: 1 Default output produces supported-by-ftools file list
    When I successfully run `ftls`
    Then the stdout should contain each of:
    | foto.jpeg |
    | foto.jpg  |
    | foto.tif  |
    | foto.tiff |
    | foto.orf  |
    | foto.arw  |
    | foto.png  |
    | foto.dng  |
    | video.avi |
    | video.mp4 |
    | video.mpg |
    | video.dv  |
    | video.mts |
    | video.mov |
  
  #@announce
  Scenario: 2 Default output DOES NOT show unsupported files
    When I successfully run `ftls`
    Then the stdout should not contain "foto_wrong.psd"
    And  the stdout should not contain "video_wrong.3gp"

  #@announce
  Scenario: 3 The output DOES NOT show unsupported files EVEN if I intentionally enter it as a parameter
    When I successfully run `ftls foto_wrong.psd video_wrong.3gp`
    Then the stdout should not contain "foto_wrong.psd"
    And  the stdout should not contain "video_wrong.3gp"

  #@announce
  Scenario: 4 The output shows files inside directories entered as paramenets
    Given a directory named "fotos"
    And empty files named:
    | ./fotos/f4.jpg       |
    | ./fotos/f4.tiff      |
    | ./fotos/f4.orf       |
    | ./fotos/f4.arw       |
    And a directory named "videos"
    And empty files named:
    | ./videos/v4.avi       |
    | ./videos/v4.mp4       |
    | ./videos/v4.mpg       |
    | ./videos/v4.dv        |
    When I successfully run `ftls fotos videos`
    Then the stdout should contain each of:
    | fotos/f4.jpg  |
    | fotos/f4.tiff |
    | fotos/f4.orf  |
    | fotos/f4.arw  |
    | videos/v4.avi |
    | videos/v4.mp4 |
    | videos/v4.mpg |
    | videos/v4.dv  |

  #@announce
  Scenario: 5 The output DOES NOT show usopported files inside directories entered as paramenets
    Given a directory named "fotos"
    And empty files named:
    | ./fotos/f5_wrong.ppp  |
    And a directory named "videos"
    And empty files named:
    | ./videos/v5_wrong.vvv  |
    When I successfully run `ftls fotos videos`
    Then the stdout should not contain "fotos/f5_wrong.ppp"
    And  the stdout should not contain "videos/v5_wrong.vvv"

  #@announce
  Scenario: 6 The output shows files inside directories and subdirectories
    Given a directory named "fotos"
    And empty files named:
    | ./fotos/f6.jpg         |
    And a directory named "fotos/fotos2"
    And empty files named:
    | ./fotos/fotos2/f6.tif  |
    And a directory named "fotos/fotos2/fotos3"
    And empty files named:
    | ./fotos/fotos2/fotos3/f6.png |
    When I successfully run `ftls --recursive fotos`
    Then the stdout should contain each of:
    | fotos/f6.jpg                 |
    | fotos/fotos2/f6.tif          |
    | fotos/fotos2/fotos3/f6.png   |
