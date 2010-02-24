Feature: file system commands

  In order to specify commands that load files
  As a developer using Cucumber
  I want to create temporary files

  Scenario: create a dir
    Given a directory named "foo/bar"
    When I run "ruby -e \"puts test ?d, 'foo'\""
    Then the stdout should contain "true"

  Scenario: create a file
    Given a file named "foo/bar/example.rb" with:
      """
      puts "hello world"
      """
    When I run "ruby foo/bar/example.rb"
    Then I should see "hello world"

  Scenario: append to a file
    Given a file named "foo/bar/example.rb" with:
      """
      puts "hello world"
      """
    When I append to "foo/bar/example.rb" with:
      """
      puts "this was appended"
      """
    When I run "ruby foo/bar/example.rb"
    Then I should see "hello world"
    And I should see "this was appended"

  Scenario: append to a file (no newline)
    Given an empty file named "foo/bar/text_file"
    When I append to "foo/bar/text_file" with "hello foo"
    When I append to "foo/bar/text_file" with "hello bar"
    When I run "cat foo/bar/text_file"
    Then I should see "hello foohello bar"

  Scenario: append line to a file
    Given an empty file named "foo/bar/text_file"
    When I append to "foo/bar/text_file" with "start"
    When I append to "foo/bar/text_file" with the line "hello foo"
    When I append to "foo/bar/text_file" with the line "hello bar"
    When I run "cat foo/bar/text_file"
    Then I should see the line "start"
    Then I should see the line "hello foo"
    Then I should see the line "hello bar"

  Scenario: clean up files generated in previous scenario
    When I run "ruby foo/bar/example.rb"
    Then the exit status should be 1
    And I should see "No such file or directory -- foo/bar/example.rb"

  Scenario: change to a subdir
    Given a file named "foo/bar/example.rb" with:
      """
      puts "hello world"
      """
    When I cd to "foo/bar"
    And I run "ruby example.rb"
    Then I should see "hello world"

  Scenario: Reset current directory from previous scenario
    When I run "ruby example.rb"
    Then the exit status should be 1

  @fail
  Scenario: Holler if cd to bad dir
    Given a file named "foo/bar/example.rb" with:
      """
      puts "hello world"
      """
    When I cd to "foo/nonexistant"

  Scenario: Check for presence of a subset of files
    Given an empty file named "lorem/ipsum/dolor"
    Given an empty file named "lorem/ipsum/sit"
    Given an empty file named "lorem/ipsum/amet"
    Then the following files should exist:
      | lorem/ipsum/dolor |
      | lorem/ipsum/amet  |

  @fail
  Scenario: Check for presence of a subset of files
    Then the following files should exist:
      | lorem/ipsum/dolor |
