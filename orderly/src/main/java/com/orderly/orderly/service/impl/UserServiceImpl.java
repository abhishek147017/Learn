package com.orderly.orderly.service.impl;

import com.orderly.orderly.dto.CreateUserRequest;
import com.orderly.orderly.dto.UpdateUserRequest;
import com.orderly.orderly.dto.UserResponse;
import com.orderly.orderly.entity.User;
import com.orderly.orderly.repository.UserRepository;
import com.orderly.orderly.service.UserService;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class UserServiceImpl implements UserService {
    private final UserRepository repository;
    public UserServiceImpl(UserRepository repository){
        this.repository = repository;
    }

    @Override
    @Transactional
    public UserResponse createUser(CreateUserRequest request){
        User user = new User();

        user.setName(request.getName());
        user.setEmail(request.getEmail());
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());

        User saved = repository.save(user);
        return new UserResponse(saved.getId(), saved.getName(), saved.getEmail());
    }

    @Override
    @Transactional
    public User updateUser(UpdateUserRequest request){
        User user = repository.getById(request.getId());
        if (user.getId() == null) {
            return user;
        }
        user.setName(request.getName());
        user.setUpdatedAt(LocalDateTime.now());
        return repository.save(user);
    }

    @Transactional
    public User getUser(Long id){
        return repository.getById(id);
    }

    @Override
    @Transactional
    public Boolean deleteUser(Long id){
        User user = repository.getById(id);
        if (user.getId() == null) {
            return false;
        }
        repository.deleteById(id);
        return true;
    }
}