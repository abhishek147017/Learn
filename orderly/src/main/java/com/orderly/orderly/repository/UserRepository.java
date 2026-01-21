package com.orderly.orderly.repository;

import com.orderly.orderly.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
}