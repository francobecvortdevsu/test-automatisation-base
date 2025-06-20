@HU:1 @marvelCharacters @agente1
Feature: Marvel Characters API Testing - Create character

  Background:
    # Define base URL for all scenarios
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def basePath = '/fbecvort/api/characters'

  @id:3
  Scenario: Crear personaje (exitoso)
    # Define the character data
    * def characterData =
    """
    {
      "name": "Spider-Man",
      "alterego": "Peter Parker",
      "description": "Superhéroe arácnido de Marvel",
      "powers": ["Agilidad", "Sentido arácnido", "Trepar muros"]
    }
    """

    # Send a POST request to create the character
    Given path basePath
    And request characterData
    And header Content-Type = 'application/json'
    When method post
    Then status 201

    # Validate the response structure
    And match response contains
    """
    {
      "id": "#number",
      "name": "Spider-Man",
      "alterego": "Peter Parker",
      "description": "Superhéroe arácnido de Marvel",
      "powers": ["Agilidad", "Sentido arácnido", "Trepar muros"]
    }
    """

    # Validate that the ID is present and is a number
    And match response.id == '#present'
    And match response.id == '#number'
