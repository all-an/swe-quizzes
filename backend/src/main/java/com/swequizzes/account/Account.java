package com.swequizzes.account;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "account")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Account {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 120)
    private String name;

    @Column(nullable = false, unique = true)
    private String email;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private AccountRole role = AccountRole.USER;

    @JsonIgnore
    @Column(nullable = false, columnDefinition = "TEXT")
    private String passwordHash;

    @JsonIgnore
    @Column(unique = true, length = 120)
    private String authToken;

    @Column(nullable = false)
    private LocalDateTime createdAt;

    @PrePersist
    void beforeCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }

    public Long getId() { return id; }
    public String getName() { return name; }
    public String getEmail() { return email; }
    public AccountRole getRole() { return role; }
    public String getPasswordHash() { return passwordHash; }
    public String getAuthToken() { return authToken; }
    public LocalDateTime getCreatedAt() { return createdAt; }

    public void setId(Long id) { this.id = id; }
    public void setName(String name) { this.name = name; }
    public void setEmail(String email) { this.email = email; }
    public void setRole(AccountRole role) { this.role = role; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    public void setAuthToken(String authToken) { this.authToken = authToken; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
