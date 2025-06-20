@HU:1 @marvelCharacters @agente1
Feature: Marvel Characters API Testing - Get character by ID

  Background:
    # Define base URL for all scenarios
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def basePath = '/fbecvort/api/characters'

  @id:2
  Scenario: Obtener personaje por ID (exitoso)
    # Use a known character ID
    * def characterId = 1

    # Call the endpoint to get the character by ID
    Given path basePath + '/' + characterId
    When method get
    Then status 200

    # Validate the response structure and data
    And match response ==
    """
    {
      "id": 1,
      "name": "Iron Man",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": ["Armor", "Flight"]
    }
    """
