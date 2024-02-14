package org.integrationgateways.microservicealpha.controllers;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.integrationgateways.microservicealpha.entity.ApiKeyData;
import org.integrationgateways.microservicealpha.repository.ApiKeyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/config")
public class GenerateApiKeyController {
    @Autowired
    public ApiKeyRepository apiKeyRepository;

    ApiKeyData apiKeyData = new ApiKeyData();

    @GetMapping("/generate-api-key")
    public String generateApiKey() {
        return "API Key";
    }

    @GetMapping("/getAccessToken")
    public ResponseEntity<ApiKeyData> getAccessToken() throws JsonProcessingException {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        // Construct the request body
        MultiValueMap<String, String> requestBody = new LinkedMultiValueMap<>();
        requestBody.add("realm", "service_alpha");
        requestBody.add("client_id", "client_service_alpha");
        requestBody.add("client_secret", "grOjsvIGKrC6np59m9B6tKDxnQR0sYBb");
        requestBody.add("grant_type", "password");
        requestBody.add("username", "alpha");
        requestBody.add("password", "alpha");

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(requestBody, headers);

        // Make the POST request
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> response = restTemplate.exchange(
                "http://localhost:8080/realms/service_alpha/protocol/openid-connect/token",
                HttpMethod.POST,
                request,
                String.class);

        // Return the response
        // get access token from response

        // Parse JSON response and extract access token
        ObjectMapper objectMapper = new ObjectMapper();
        Map<String, Object> responseMap = objectMapper.readValue(response.getBody(), Map.class);
        String accessToken = (String) responseMap.get("access_token");
        UUID apiKey = UUID.randomUUID();
        // Save the access token
//        apiKeyData.setKey(apiKey.toString());
//        apiKeyData.setSecret(accessToken);
        ApiKeyData data = apiKeyRepository.save(new ApiKeyData(apiKey.toString(),accessToken));
        System.out.println(data);
        // Return the access token
        return ResponseEntity.ok(data);
    }
}
