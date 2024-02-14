package org.integrationgateways.microservicealpha.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity

@NoArgsConstructor
@Getter
@Setter

public class ApiKeyData {
    @Id()
    private String apikey;
    @Column(columnDefinition = "TEXT")

    private String secret;

    public ApiKeyData(String key, String secret) {
        this.apikey = key;
        this.secret = secret;
    }
}
