package com.swequizzes.logging;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "access_log")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class AccessLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 120)
    private String sessionKey;

    @Column(nullable = false, length = 80)
    private String ipAddress;

    @Column(nullable = false, length = 120)
    private String country;

    @Column(columnDefinition = "TEXT")
    private String userAgent;

    @Column(nullable = false)
    private LocalDateTime createdAt;

    @PrePersist
    void beforeCreate() {
        if (createdAt == null) createdAt = LocalDateTime.now();
    }

    public Long getId() { return id; }
    public String getSessionKey() { return sessionKey; }
    public String getIpAddress() { return ipAddress; }
    public String getCountry() { return country; }
    public String getUserAgent() { return userAgent; }
    public LocalDateTime getCreatedAt() { return createdAt; }

    public void setId(Long id) { this.id = id; }
    public void setSessionKey(String sessionKey) { this.sessionKey = sessionKey; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }
    public void setCountry(String country) { this.country = country; }
    public void setUserAgent(String userAgent) { this.userAgent = userAgent; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
