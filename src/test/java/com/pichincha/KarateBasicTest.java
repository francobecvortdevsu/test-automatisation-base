package com.pichincha;

import com.intuit.karate.junit5.Karate;

class KarateBasicTest {
    static {
        System.setProperty("karate.ssl", "true");
    }

    @Karate.Test
    Karate testMarvelCharacters() {
        return Karate.run("src/test/java/com/pichincha/features/marvelCharacters/marvel-characters.feature");
    }
}
