@HU:1 @marvelCharacters @agente1
Feature: Marvel Characters API Testing - Create character with duplicate name

  Background:
    # Define base URL for all scenarios
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def basePath = '/fbecvort/api/characters'

  @id:4
  Scenario: Crear personaje (nombre duplicado)
    # First, create a character to ensure it exists in the system
    * def initialCharacterData =
    """
    {
      "name": "Iron Man",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": ["Armor", "Flight"]
    }
    """

    # Send a POST request to create the initial character
    Given path basePath
    And request initialCharacterData
    And header Content-Type = 'application/json'
    When method post
    # The character might already exist, so we accept both 201 (Created) and 400 (Duplicate) status codes
    Then status 201, 400

    # Now try to create another character with the same name but different details
    * def duplicateCharacterData =
    """
    {
      "name": "Iron Man",
      "alterego": "Otro",
      "description": "Otro",
      "powers": ["Armor"]
    }
    """

    # Send a POST request to create the duplicate character
    Given path basePath
    And request duplicateCharacterData
    And header Content-Type = 'application/json'
    When method post
    Then status 400

    # Validate the error response
    And match response ==
    """
    {
      "error": "Character name already exists"
    }
    """
