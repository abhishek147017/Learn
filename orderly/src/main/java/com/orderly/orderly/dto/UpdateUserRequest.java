package com.orderly.orderly.dto;

import jakarta.validation.constraints.NotBlank;

public class UpdateUserRequest {
    @NotBlank
    private String name;

    @NotBlank
    private  Long id;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public  void  setId(Long id){
        this.id=id;
    }

    public Long getId(){ return id;}
}
