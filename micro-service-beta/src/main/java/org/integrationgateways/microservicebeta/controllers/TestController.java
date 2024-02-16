package org.integrationgateways.microservicebeta.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("/service-beta")
@RestController
public class TestController {
    @GetMapping("/serve")
    public String test() {
        return "Hello";
    }
}
