package com.swequizzes.logging;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.swequizzes.account.Account;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "session_log")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class SessionLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "account_id")
    private Account account;

    @Column(nullable = false, length = 40)
    private String eventType;

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
    public Account getAccount() { return account; }
    public String getEventType() { return eventType; }
    public String getIpAddress() { return ipAddress; }
    public String getCountry() { return country; }
    public String getUserAgent() { return userAgent; }
    public LocalDateTime getCreatedAt() { return createdAt; }

    public void setId(Long id) { this.id = id; }
    public void setAccount(Account account) { this.account = account; }
    public void setEventType(String eventType) { this.eventType = eventType; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }
    public void setCountry(String country) { this.country = country; }
    public void setUserAgent(String userAgent) { this.userAgent = userAgent; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
