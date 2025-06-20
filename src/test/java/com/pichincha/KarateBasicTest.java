package com.pichincha;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import net.minidev.json.JSONArray;
import net.minidev.json.parser.JSONParser;
import net.minidev.json.parser.ParseException;
import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import static org.junit.jupiter.api.Assertions.assertTrue;

class KarateBasicTest {
    private static final Logger logger = Logger.getLogger(KarateBasicTest.class.getName());
    private static final String ERROR_MSG = "ERROR: ";

    static {
        System.setProperty("karate.ssl", "true");
    }

    @Test
    void testMarvelCharacters() throws IOException {
        Results results = Runner
                .path("src/test/java/com/pichincha")
                .tags("@marvelCharacters")
                .outputCucumberJson(true)
                .parallel(5);

        String karateOutputPath = "build/karate-reports";
        generateReport(karateOutputPath);
        assertTrue(results.getFailCount() == 0, results.getErrorMessages());
    }

    public static void generateReport(String karateOutputPath) throws IOException {
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[]{"json"}, true);
        List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
        JSONArray karateJson = new JSONArray();
        jsonFiles.forEach(file -> {
            karateJson.add(getReportJsonByFile(file.getAbsolutePath()));
            jsonPaths.add(file.getAbsolutePath());
        });
        String karateResumePath = "./build/karate-reports/json";
        File pathFile = new File(karateResumePath);
        if (!Files.exists(Paths.get(karateResumePath))) {
            pathFile.mkdir();
        }
        Files.write(Paths.get(karateResumePath + "/karate.json"), karateJson.toJSONString().getBytes());
        Configuration config = new Configuration(new File("build"), "Test Automatisation Base");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }

    public static Object getReportJsonByFile(String filePath) {
        Object jsonReport = null;
        try (FileReader reader = new FileReader(filePath)) {
            JSONArray jsonArray = (JSONArray) new JSONParser().parse(reader);
            if (!jsonArray.isEmpty()) jsonReport = jsonArray.get(0);
        } catch (IOException | ParseException e) {
            logger.log(Level.WARNING, ERROR_MSG, e);
        }
        return jsonReport;
    }
}
