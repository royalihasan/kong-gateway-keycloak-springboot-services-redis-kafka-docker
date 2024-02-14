package org.integrationgateways.microservicealpha.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/access-features")
public class AccessFeaturesController {
    @GetMapping("/user")
    public String simpleFeature() {
        return "Simple Feature";
    }

    @GetMapping("/admin")
    public String adminFeature() {
        return "Admin Feature";
    }

    @GetMapping("/premium")
    public String premiumFeature() {
        return "Premium Feature";
    }
}
