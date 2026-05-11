package com.swequizzes.quiz;

import com.swequizzes.account.Account;
import com.swequizzes.account.AccountRole;
import com.swequizzes.account.AccountService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.NoSuchElementException;

@RestController
@RequestMapping("/api/quizzes")
public class QuizController {

    private final QuizService quizService;
    private final AccountService accountService;

    public QuizController(QuizService quizService, AccountService accountService) {
        this.quizService = quizService;
        this.accountService = accountService;
    }

    @GetMapping
    public List<Quiz> findAll(
            @RequestParam(required = false) String category,
            @RequestHeader(value = "Authorization", required = false) String authorization
    ) {
        Account account = optionalAccount(authorization);
        if (category != null) return quizService.findByCategory(category, account);
        return quizService.findAll();
    }

    @GetMapping("/my")
    public ResponseEntity<List<Quiz>> findMine(
            @RequestHeader(value = "Authorization", required = false) String authorization
    ) {
        try {
            Account account = accountService.requireAccount(authorization);
            return ResponseEntity.ok(quizService.findByAccount(account));
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(401).build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<Quiz> findById(
            @PathVariable Long id,
            @RequestHeader(value = "Authorization", required = false) String authorization
    ) {
        Quiz quiz;
        try {
            quiz = quizService.findById(id);
        } catch (NoSuchElementException e) {
            return ResponseEntity.notFound().build();
        }

        if (quiz.getAccount() != null) {
            try {
                Account account = accountService.requireAccount(authorization);
                boolean owner = quiz.getAccount().getId().equals(account.getId());
                boolean admin = account.getRole() == AccountRole.ADMIN;
                if (!owner && !admin) {
                    return ResponseEntity.status(403).build();
                }
            } catch (NoSuchElementException e) {
                return ResponseEntity.status(401).build();
            }
        }
        return ResponseEntity.ok(quiz);
    }

    @PostMapping
    public ResponseEntity<Quiz> create(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @RequestBody CreateQuizRequest request
    ) {
        try {
            Account account = accountService.requireAccount(authorization);
            return ResponseEntity.ok(quizService.create(account, request));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(401).build();
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<Quiz> update(
            @PathVariable Long id,
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @RequestBody CreateQuizRequest request
    ) {
        Account account;
        Quiz quiz;
        try {
            account = accountService.requireAccount(authorization);
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(401).build();
        }
        try {
            quiz = quizService.findById(id);
        } catch (NoSuchElementException e) {
            return ResponseEntity.notFound().build();
        }
        if (quiz.getAccount() == null) {
            return ResponseEntity.status(403).build();
        }
        boolean owner = quiz.getAccount().getId().equals(account.getId());
        boolean admin = account.getRole() == AccountRole.ADMIN;
        if (!owner && !admin) {
            return ResponseEntity.status(403).build();
        }
        try {
            return ResponseEntity.ok(quizService.update(quiz, request));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        } catch (NoSuchElementException e) {
            return ResponseEntity.notFound().build();
        }
    }

    private Account optionalAccount(String authorization) {
        if (authorization == null || !authorization.startsWith("Bearer ")) {
            return null;
        }
        try {
            return accountService.requireAccount(authorization);
        } catch (NoSuchElementException e) {
            return null;
        }
    }
}
