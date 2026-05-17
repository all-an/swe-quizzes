package com.swequizzes.admin;

import com.swequizzes.account.AccountService;
import com.swequizzes.logging.AccessLog;
import com.swequizzes.logging.LogPage;
import com.swequizzes.logging.LogService;
import com.swequizzes.logging.SessionLog;
import com.swequizzes.settings.Settings;
import com.swequizzes.settings.SettingsRequest;
import com.swequizzes.settings.SettingsService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.NoSuchElementException;

@RestController
@RequestMapping("/api/admin")
public class AdminController {
    private final AccountService accountService;
    private final SettingsService settingsService;
    private final LogService logService;

    public AdminController(AccountService accountService, SettingsService settingsService, LogService logService) {
        this.accountService = accountService;
        this.settingsService = settingsService;
        this.logService = logService;
    }

    @GetMapping("/settings")
    public ResponseEntity<Settings> settings(@RequestHeader(value = "Authorization", required = false) String authorization) {
        try {
            accountService.requireAdmin(authorization);
            return ResponseEntity.ok(settingsService.current());
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(401).build();
        } catch (SecurityException e) {
            return ResponseEntity.status(403).build();
        }
    }

    @PutMapping("/settings")
    public ResponseEntity<Settings> updateSettings(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @RequestBody SettingsRequest request
    ) {
        try {
            accountService.requireAdmin(authorization);
            return ResponseEntity.ok(settingsService.update(request));
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(401).build();
        } catch (SecurityException e) {
            return ResponseEntity.status(403).build();
        }
    }

    @GetMapping("/access-logs")
    public ResponseEntity<LogPage<AccessLog>> accessLogs(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @RequestParam(defaultValue = "0") int page
    ) {
        try {
            accountService.requireAdmin(authorization);
            return ResponseEntity.ok(logService.recentAccessLogs(page));
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(401).build();
        } catch (SecurityException e) {
            return ResponseEntity.status(403).build();
        }
    }

    @GetMapping("/session-logs")
    public ResponseEntity<LogPage<SessionLog>> sessionLogs(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @RequestParam(defaultValue = "0") int page
    ) {
        try {
            accountService.requireAdmin(authorization);
            return ResponseEntity.ok(logService.recentSessionLogs(page));
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(401).build();
        } catch (SecurityException e) {
            return ResponseEntity.status(403).build();
        }
    }
}
