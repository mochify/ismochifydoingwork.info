Feature: Github Score

    Scenario: Work is done on github 
        Given Team1 has worked recently on github
        When the foreman calculates productivity for Team1
        Then the score for Team1 should be positive

    Scenario: No work is done on github
        Given Team2 has done no work recently on github
        When the foreman calculates productivity for Team2
        Then the score for Team2 should be zero
