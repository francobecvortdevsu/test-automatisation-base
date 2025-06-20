@HU:1 @marvelCharacters @agente1
Feature: Marvel Characters API Testing - Update character

  Background:
    # Define base URL for all scenarios
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def basePath = '/fbecvort/api/characters'

  @id:7
  Scenario: Actualizar personaje (exitoso)
    # Use the existing character with ID 1
    * def characterId = 1

    # Define the updated character data
    * def updatedCharacterData =
    """
    {
      "name": "Iron Man",
      "alterego": "Tony Stark",
      "description": "Updated description",
      "powers": ["Armor", "Flight"]
    }
    """

    # Send a PUT request to update the character
    Given path basePath + '/' + characterId
    And request updatedCharacterData
    And header Content-Type = 'application/json'
    When method put
    Then status 200

    # Validate the updated response
    And match response ==
    """
    {
      "id": "#(characterId)",
      "name": "Iron Man",
      "alterego": "Tony Stark",
      "description": "Updated description",
      "powers": ["Armor", "Flight"]
    }
    """

    # Verify the update by getting the character details
    Given path basePath + '/' + characterId
    When method get
    Then status 200

    # Confirm that the description was updated
    And match response.description == "Updated description"
