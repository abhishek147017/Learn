package com.orderly.orderly.service;

import com.orderly.orderly.dto.CreateUserRequest;
import com.orderly.orderly.dto.UpdateUserRequest;
import com.orderly.orderly.dto.UserResponse;
import com.orderly.orderly.entity.User;

public interface UserService {
    UserResponse createUser(CreateUserRequest request);
    User updateUser(UpdateUserRequest request);
    User getUser(Long id);
    Boolean deleteUser(Long id);
}