package com.swequizzes.account;

import com.swequizzes.logging.RequestInfoService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/accounts")
public class AccountController {
    private final AccountService accountService;
    private final RequestInfoService requestInfoService;

    public AccountController(AccountService accountService, RequestInfoService requestInfoService) {
        this.accountService = accountService;
        this.requestInfoService = requestInfoService;
    }

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@RequestBody RegisterRequest request, HttpServletRequest servletRequest) {
        try {
            return ResponseEntity.ok(accountService.register(request, requestInfoService.from(servletRequest)));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        } catch (IllegalStateException e) {
            return ResponseEntity.status(403).build();
        }
    }
}
