package com.swequizzes.settings;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "settings")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Settings {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private boolean disableLogin;

    @Column(nullable = false)
    private boolean disableRegister;

    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    @PreUpdate
    void touch() {
        updatedAt = LocalDateTime.now();
    }

    public Long getId() { return id; }
    public boolean isDisableLogin() { return disableLogin; }
    public boolean isDisableRegister() { return disableRegister; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }

    public void setId(Long id) { this.id = id; }
    public void setDisableLogin(boolean disableLogin) { this.disableLogin = disableLogin; }
    public void setDisableRegister(boolean disableRegister) { this.disableRegister = disableRegister; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
