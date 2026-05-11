package com.swequizzes.account;

import com.swequizzes.logging.LogService;
import com.swequizzes.logging.RequestInfo;
import com.swequizzes.settings.SettingsService;
import org.springframework.stereotype.Service;
import java.util.Locale;
import java.util.NoSuchElementException;
import java.util.UUID;

@Service
public class AccountService {
    private final AccountRepository accountRepository;
    private final PasswordHasher passwordHasher;
    private final SettingsService settingsService;
    private final LogService logService;

    public AccountService(
            AccountRepository accountRepository,
            PasswordHasher passwordHasher,
            SettingsService settingsService,
            LogService logService
    ) {
        this.accountRepository = accountRepository;
        this.passwordHasher = passwordHasher;
        this.settingsService = settingsService;
        this.logService = logService;
    }

    public AuthResponse register(RegisterRequest request, RequestInfo requestInfo) {
        if (settingsService.current().isDisableRegister()) {
            logService.session(null, "REGISTER_BLOCKED", requestInfo);
            throw new IllegalStateException("Registration is disabled");
        }
        try {
            String name = requireText(request.name(), "Name is required");
            String email = normalizeEmail(request.email());
            String password = requireText(request.password(), "Password is required");
            if (password.length() < 6) {
                throw new IllegalArgumentException("Password must have at least 6 characters");
            }
            if (accountRepository.existsByEmailIgnoreCase(email)) {
                throw new IllegalArgumentException("Email already registered");
            }

            Account account = new Account();
            account.setName(name);
            account.setEmail(email);
            account.setRole(accountRepository.count() == 0 ? AccountRole.ADMIN : AccountRole.USER);
            account.setPasswordHash(passwordHasher.hash(password));
            account.setAuthToken(newToken());
            Account saved = accountRepository.save(account);
            logService.session(saved, "REGISTER", requestInfo);
            return new AuthResponse(saved.getAuthToken(), saved);
        } catch (IllegalArgumentException e) {
            logService.session(null, "REGISTER_FAILED", requestInfo);
            throw e;
        }
    }

    public AuthResponse login(LoginRequest request, RequestInfo requestInfo) {
        String email = normalizeEmail(request.email());
        String password = requireText(request.password(), "Password is required");
        Account account = accountRepository.findByEmailIgnoreCase(email)
                .orElseThrow(() -> {
                    logService.session(null, "LOGIN_FAILED", requestInfo);
                    return new NoSuchElementException("Invalid email or password");
                });
        if (!passwordHasher.matches(password, account.getPasswordHash())) {
            logService.session(account, "LOGIN_FAILED", requestInfo);
            throw new NoSuchElementException("Invalid email or password");
        }
        if (settingsService.current().isDisableLogin() && account.getRole() != AccountRole.ADMIN) {
            logService.session(account, "LOGIN_BLOCKED", requestInfo);
            throw new IllegalStateException("Only admin login is available");
        }
        account.setAuthToken(newToken());
        Account saved = accountRepository.save(account);
        logService.session(saved, "LOGIN", requestInfo);
        return new AuthResponse(saved.getAuthToken(), saved);
    }

    public Account requireAccount(String authorizationHeader) {
        String token = bearerToken(authorizationHeader);
        return accountRepository.findByAuthToken(token)
                .orElseThrow(() -> new NoSuchElementException("Invalid token"));
    }

    public Account requireAdmin(String authorizationHeader) {
        Account account = requireAccount(authorizationHeader);
        if (account.getRole() != AccountRole.ADMIN) {
            throw new SecurityException("Admin role required");
        }
        return account;
    }

    public void logout(String authorizationHeader) {
        Account account = requireAccount(authorizationHeader);
        account.setAuthToken(null);
        accountRepository.save(account);
    }

    private String bearerToken(String authorizationHeader) {
        if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
            throw new NoSuchElementException("Missing token");
        }
        String token = authorizationHeader.substring("Bearer ".length()).trim();
        if (token.isEmpty()) {
            throw new NoSuchElementException("Missing token");
        }
        return token;
    }

    private String normalizeEmail(String email) {
        String normalized = requireText(email, "Email is required").toLowerCase(Locale.ROOT);
        if (!normalized.contains("@")) {
            throw new IllegalArgumentException("Email is invalid");
        }
        return normalized;
    }

    private String requireText(String value, String message) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(message);
        }
        return value.trim();
    }

    private String newToken() {
        return UUID.randomUUID().toString();
    }
}
