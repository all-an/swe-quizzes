package com.swequizzes.category;

import com.swequizzes.account.Account;
import com.swequizzes.account.AccountService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.NoSuchElementException;

@RestController
@RequestMapping("/api/categories")
public class CategoryController {

    private final CategoryService categoryService;
    private final AccountService accountService;

    public CategoryController(CategoryService categoryService, AccountService accountService) {
        this.categoryService = categoryService;
        this.accountService = accountService;
    }

    @GetMapping
    public List<Category> findAll(@RequestHeader(value = "Authorization", required = false) String authorization) {
        Account account = null;
        if (authorization != null && authorization.startsWith("Bearer ")) {
            try {
                account = accountService.requireAccount(authorization);
            } catch (NoSuchElementException ignored) {
                account = null;
            }
        }
        return categoryService.findVisible(account);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Category> findById(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(categoryService.findById(id));
        } catch (NoSuchElementException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping
    public ResponseEntity<Category> create(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @RequestBody Category category
    ) {
        Account account;
        try {
            account = accountService.requireAccount(authorization);
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(401).build();
        }
        try {
            return ResponseEntity.ok(categoryService.saveForAccount(category, account));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }
}
