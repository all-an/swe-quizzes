package com.swequizzes.category;

import com.swequizzes.account.Account;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Objects;

@Service
public class CategoryService {

    private final CategoryRepository categoryRepository;

    public CategoryService(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    public List<Category> findAll() {
        return categoryRepository.findAll();
    }

    public List<Category> findVisible(Account account) {
        if (account == null) {
            return categoryRepository.findSystemCategories();
        }
        return categoryRepository.findSystemAndAccountCategories(account.getId());
    }

    public Category findById(Long id) {
        return categoryRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Category not found: " + id));
    }

    public Category save(Category category) {
        return categoryRepository.save(category);
    }

    public Category saveForAccount(Category category, Account account) {
        Category existing = categoryRepository.findBySlug(category.getSlug()).orElse(null);
        if (existing != null) {
            if (existing.getAccount() == null && !categoryRepository.hasSystemQuiz(existing.getId())) {
                existing.setAccount(account);
                existing.setName(category.getName());
                return categoryRepository.save(existing);
            }
            if (existing.getAccount() != null && Objects.equals(existing.getAccount().getId(), account.getId())) {
                return existing;
            }
            throw new IllegalArgumentException("Category already exists");
        }
        category.setAccount(account);
        return categoryRepository.save(category);
    }
}
