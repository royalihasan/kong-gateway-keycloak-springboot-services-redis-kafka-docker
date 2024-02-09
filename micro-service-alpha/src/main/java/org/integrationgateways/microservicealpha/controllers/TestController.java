package org.integrationgateways.microservicealpha.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/serve")
public class TestController {
    @GetMapping("")
    public String test() {
        return "Hello";
    }
}
