package com.swequizzes.account;

import com.swequizzes.logging.RequestInfoService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.NoSuchElementException;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final AccountService accountService;
    private final RequestInfoService requestInfoService;

    public AuthController(AccountService accountService, RequestInfoService requestInfoService) {
        this.accountService = accountService;
        this.requestInfoService = requestInfoService;
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest request, HttpServletRequest servletRequest) {
        try {
            return ResponseEntity.ok(accountService.login(request, requestInfoService.from(servletRequest)));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        } catch (IllegalStateException e) {
            return ResponseEntity.status(403).build();
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(401).build();
        }
    }

    @GetMapping("/me")
    public ResponseEntity<Account> me(@RequestHeader(value = "Authorization", required = false) String authorization) {
        try {
            return ResponseEntity.ok(accountService.requireAccount(authorization));
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(401).build();
        }
    }

    @PostMapping("/logout")
    public ResponseEntity<Void> logout(@RequestHeader(value = "Authorization", required = false) String authorization) {
        try {
            accountService.logout(authorization);
            return ResponseEntity.noContent().build();
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(401).build();
        }
    }
}
