@HU:1 @marvelCharacters @agente1
Feature: Marvel Characters API Testing - Create character with missing required fields

  Background:
    # Define base URL for all scenarios
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def basePath = '/fbecvort/api/characters'

  @id:5
  Scenario: Crear personaje (faltan campos requeridos)
    # Define the character data with empty fields
    * def invalidCharacterData =
    """
    {
      "name": "",
      "alterego": "",
      "description": "",
      "powers": []
    }
    """

    # Send a POST request with empty fields
    Given path basePath
    And request invalidCharacterData
    And header Content-Type = 'application/json'
    When method post
    Then status 400

    # Validate the error response structure and messages
    And match response ==
    """
    {
      "name": "Name is required",
      "alterego": "Alterego is required",
      "description": "Description is required",
      "powers": "Powers are required"
    }
    """
