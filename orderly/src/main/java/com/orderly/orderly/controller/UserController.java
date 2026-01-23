package com.orderly.orderly.controller;

import com.orderly.orderly.dto.CreateUserRequest;
import com.orderly.orderly.dto.UpdateUserRequest;
import com.orderly.orderly.dto.UserResponse;
import com.orderly.orderly.entity.User;
import com.orderly.orderly.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/user")
public class UserController {
    private final UserService service;

    public UserController(UserService service){
        this.service = service;
    }

    @PostMapping
    public ResponseEntity<UserResponse> createUser(@Valid @RequestBody CreateUserRequest request) {
        UserResponse userRes = service.createUser(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(userRes);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<User> updateUser(@Valid @RequestBody UpdateUserRequest request) {

        User user = service.updateUser(request);
        return ResponseEntity.status(HttpStatus.OK).body(user);
    }

    @GetMapping("/{id}")
    public User getUser(@PathVariable Long id) {
        return service.getUser(id);
    }

    @DeleteMapping("/{id}")
    public Boolean deleteUser(@PathVariable Long id){
        return service.deleteUser(id);
    }
}