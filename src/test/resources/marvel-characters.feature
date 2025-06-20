Feature: Marvel Characters API Testing

  Background:
    # Define base URL for all scenarios
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def basePath = '/fbecvort/api/characters'

  Scenario: Obtener todos los personajes
    # Call the endpoint to get all characters
    Given path basePath
    When method get
    Then status 200

    # Validate that the response is a JSON array
    And match response == '#array'

    # Additional validations for when the response contains data
    * def hasData = responseBytes.length > 2
    * if (hasData) karate.call('validateCharacterSchema.feature')
