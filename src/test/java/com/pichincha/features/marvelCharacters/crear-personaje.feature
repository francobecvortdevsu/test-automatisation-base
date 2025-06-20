@HU:1 @marvelCharacters @agente1
Feature: Marvel Characters API Testing - Create character

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

  @id:3
  Scenario: Crear personaje (exitoso)
    # Generate random values for character fields
    * def timestamp = getCurrentTimestamp()
    * def randomName = 'Hero_' + randomString(5) + '_' + timestamp
    * def randomAlterEgo = 'Person_' + randomString(5) + '_' + timestamp
    * def randomDesc = 'Description_' + randomString(8) + '_' + timestamp

    # Define the character data with random values
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

    # Validate the response structure
    And match response contains
    """
    {
      "id": "#number",
      "name": "#(randomName)",
      "alterego": "#(randomAlterEgo)",
      "description": "#(randomDesc)",
      "powers": ["Power_1", "Power_2", "Power_3"]
    }
    """

    # Validate that the ID is present and is a number
    And match response.id == '#present'
    And match response.id == '#number'
