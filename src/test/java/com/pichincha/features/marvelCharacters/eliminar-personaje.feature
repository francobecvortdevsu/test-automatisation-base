@HU:1 @marvelCharacters @agente1
Feature: Marvel Characters API Testing - Delete character

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

  @id:8
  Scenario: Eliminar personaje (exitoso)
    # Generate random values for character fields
    * def timestamp = getCurrentTimestamp()
    * def randomName = 'DeleteTest_' + randomString(5) + '_' + timestamp
    * def randomAlterEgo = 'Person_' + randomString(5) + '_' + timestamp
    * def randomDesc = 'Description_' + randomString(8) + '_' + timestamp

    # First create a character to ensure we have one to delete
    * def characterData =
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
    And request characterData
    And header Content-Type = 'application/json'
    When method post
    Then status 201

    # Store the ID of the created character
    * def characterId = response.id

    # Verify the character exists by getting it
    Given path basePath + '/' + characterId
    When method get
    Then status 200

    # Delete the character
    Given path basePath + '/' + characterId
    When method delete
    Then status 204

    # Verify the character no longer exists
    Given path basePath + '/' + characterId
    When method get
    Then status 404

    # Validate the error response
    And match response ==
    """
    {
      "error": "Character not found"
    }
    """
