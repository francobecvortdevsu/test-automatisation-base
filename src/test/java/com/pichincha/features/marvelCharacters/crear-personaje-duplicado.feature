@HU:1 @marvelCharacters @agente1
Feature: Marvel Characters API Testing - Create character with duplicate name

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

  @id:4
  Scenario: Crear personaje (nombre duplicado)
    # Generate random values for character fields
    * def timestamp = getCurrentTimestamp()
    * def randomName = 'DupeTest_' + randomString(5) + '_' + timestamp
    * def randomAlterEgo = 'Person_' + randomString(5) + '_' + timestamp
    * def randomDesc = 'Description_' + randomString(8) + '_' + timestamp

    # First, create a character with random values to ensure it exists in the system
    * def initialCharacterData =
    """
    {
      "name": "#(randomName)",
      "alterego": "#(randomAlterEgo)",
      "description": "#(randomDesc)",
      "powers": ["Power_1", "Power_2", "Power_3"]
    }
    """

    # Send a POST request to create the initial character
    Given path basePath
    And request initialCharacterData
    And header Content-Type = 'application/json'
    When method post
    Then status 201

    # Store the ID of the created character
    * def createdCharacterId = response.id

    # Now try to create another character with the same name but different details
    * def duplicateCharacterData =
    """
    {
      "name": "#(randomName)",
      "alterego": "Duplicate_Alter_Ego",
      "description": "Duplicate_Description",
      "powers": ["Duplicate_Power"]
    }
    """

    # Send a POST request to create the duplicate character
    Given path basePath
    And request duplicateCharacterData
    And header Content-Type = 'application/json'
    When method post
    Then status 400

    # Validate the error response
    And match response ==
    """
    {
      "error": "Character name already exists"
    }
    """
