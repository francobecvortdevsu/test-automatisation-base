@HU:1 @marvelCharacters @agente1
Feature: Marvel Characters API Testing - Delete non-existent character

  Background:
    # Define base URL for all scenarios
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def basePath = '/fbecvort/api/characters'

  @id:9
  Scenario: Eliminar personaje (no existe)
    # Use a negative ID that shouldn't exist in the system
    * def nonExistentId = -1

    # Attempt to delete the non-existent character
    Given path basePath + '/' + nonExistentId
    When method delete
    Then status 404

    # Validate the error response
    And match response ==
    """
    {
      "error": "Character not found"
    }
    """

  @id:10
  Scenario Outline: Eliminar personajes con IDs negativos (no existen)
    # Use negative IDs from examples that shouldn't exist
    * def nonExistentId = <id>

    # Attempt to delete the non-existent character
    Given path basePath + '/' + nonExistentId
    When method delete
    Then status 404

    # Validate the error response
    And match response ==
    """
    {
      "error": "Character not found"
    }
    """

    Examples:
      | id    |
      | -1    |
      | -100  |
      | -999  |
