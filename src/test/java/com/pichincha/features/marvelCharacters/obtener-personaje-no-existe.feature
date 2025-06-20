@HU:1 @marvelCharacters @agente1
Feature: Marvel Characters API Testing - Get character by ID that doesn't exist

  Background:
    # Define base URL for all scenarios
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def basePath = '/fbecvort/api/characters'

  @id:6
  Scenario: Obtener personaje por ID (no existe)
    # Use a character ID that shouldn't exist in the system
    * def nonExistentId = 999

    # Call the endpoint to get a non-existent character by ID
    Given path basePath + '/' + nonExistentId
    When method get
    Then status 404

    # Validate the error response
    And match response ==
    """
    {
      "error": "Character not found"
    }
    """
