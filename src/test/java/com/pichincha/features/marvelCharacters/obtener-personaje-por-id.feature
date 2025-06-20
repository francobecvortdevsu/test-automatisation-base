@HU:1 @marvelCharacters @agente1
Feature: Marvel Characters API Testing - Get character by ID

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

  @id:2
  Scenario: Obtener personaje por ID (exitoso)
    # Generate random values for character fields
    * def timestamp = getCurrentTimestamp()
    * def randomName = 'Hero_' + randomString(5) + '_' + timestamp
    * def randomAlterEgo = 'Person_' + randomString(5) + '_' + timestamp
    * def randomDesc = 'Description_' + randomString(8) + '_' + timestamp

    # First create a character to ensure we have one to retrieve
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

    # Call the endpoint to get the character by ID
    Given path basePath + '/' + characterId
    When method get
    Then status 200

    # Validate the response structure and data
    And match response ==
    """
    {
      "id": #(characterId),
      "name": "#(randomName)",
      "alterego": "#(randomAlterEgo)",
      "description": "#(randomDesc)",
      "powers": ["Power_1", "Power_2", "Power_3"]
    }
    """
