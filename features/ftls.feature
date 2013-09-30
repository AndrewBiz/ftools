# language: en
Feature: Generate a list of ftools-friendly-files
  In order to simplify chosing the foto\video files to process
  As a photographer
  I want to get the list of foto\video files in a form of a plain text

  Background:
    Given empty files named:
      |foto.jpeg     |
      |bbb.jpg       |

    Given an empty file named "foto.jpeg"
    And   an empty file named "foto.jpg"
    And   an empty file named "foto.tif" 
    And   an empty file named "foto.tiff"
    And   an empty file named "foto.orf" 
    And   an empty file named "foto.arw"
    And   an empty file named "foto.png" 
    And   an empty file named "foto.dng"
    And   an empty file named "foto_wrong.psd" 
    And   an empty file named "video.avi"
    And   an empty file named "video.mp4"
    And   an empty file named "video.mpg"
    And   an empty file named "video.mts"
    And   an empty file named "video.dv"
    And   an empty file named "video.mov"
    And   an empty file named "video_wrong.3gp"
  
  @announce-output
  Scenario: Default output produces file list
    When I successfully run `ftls`
    Then the stdout from "ftls" should contain "foto.jpeg"
    And  the stdout from "ftls" should contain "foto.jpg"
    And  the stdout from "ftls" should contain "foto.tif"
    And  the stdout from "ftls" should contain "foto.tiff"
    And  the stdout from "ftls" should contain "foto.orf"
    And  the stdout from "ftls" should contain "foto.arw"
    And  the stdout from "ftls" should contain "foto.png"
    And  the stdout from "ftls" should contain "foto.dng"
    And  the stdout from "ftls" should contain "video.avi"
    And  the stdout from "ftls" should contain "video.mp4"
    And  the stdout from "ftls" should contain "video.mpg"
    And  the stdout from "ftls" should contain "video.mts"
    And  the stdout from "ftls" should contain "video.dv"
    And  the stdout from "ftls" should contain "video.mov"

  Scenario: Default output produces ONLY ftools-friendly file list
    When I successfully run `ftls`
    Then the stdout from "ftls" should not contain "foto_wrong.psd"
    And  the stdout from "ftls" should not contain "video_wrong.3gp"
    And  the stdout from "ftls" should not contain "aaa.jpg"
