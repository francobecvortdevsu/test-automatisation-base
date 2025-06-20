@HU:1 @marvelCharacters @agente1
Feature: Marvel Characters API Testing - Update character

  Background:
    # Define base URL for all scenarios
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def basePath = '/fbecvort/api/characters'
    # Define utility function to generate random string
    * def randomString =
      """
      function(length) {
        var chars = 'abcdefghijklmnopqrstuvwxyz';
        var result = '';
        for (var i = 0; i < length; i++) {
          result += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        return result;
      }
      """
    # Define utility function to get current timestamp
    * def getCurrentTimestamp =
      """
      function() {
        return java.lang.System.currentTimeMillis();
      }
      """

  @id:7
  Scenario: Actualizar personaje (exitoso)
    # Generate random values for character fields
    * def timestamp = getCurrentTimestamp()
    * def randomName = 'UpdateTest_' + randomString(5) + '_' + timestamp
    * def randomAlterEgo = 'Person_' + randomString(5) + '_' + timestamp
    * def randomDesc = 'Description_' + randomString(8) + '_' + timestamp

    # First create a character to ensure we have one to update
    * def initialCharacterData =
    """
    {
      "name": "#(randomName)",
      "alterego": "#(randomAlterEgo)",
      "description": "#(randomDesc)",
      "powers": ["Power_1", "Power_2", "Power_3"]
    }
    """

    # Send a POST request to create the character
    Given path basePath
    And request initialCharacterData
    And header Content-Type = 'application/json'
    When method post
    Then status 201

    # Store the ID of the created character
    * def characterId = response.id

    # Generate a new description for the update
    * def updatedDesc = 'Updated_' + randomString(8) + '_' + timestamp

    # Define the updated character data
    * def updatedCharacterData =
    """
    {
      "name": "#(randomName)",
      "alterego": "#(randomAlterEgo)",
      "description": "#(updatedDesc)",
      "powers": ["Power_1", "Power_2", "Power_3"]
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
      "id": #(characterId),
      "name": "#(randomName)",
      "alterego": "#(randomAlterEgo)",
      "description": "#(updatedDesc)",
      "powers": ["Power_1", "Power_2", "Power_3"]
    }
    """

    # Verify the update by getting the character details
    Given path basePath + '/' + characterId
    When method get
    Then status 200

    # Confirm that the description was updated
    And match response.description == "#(updatedDesc)"
