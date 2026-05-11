package com.swequizzes.category;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.swequizzes.account.Account;
import com.swequizzes.account.AccountService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.NoSuchElementException;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(CategoryController.class)
class CategoryControllerTest {

    @Autowired MockMvc mockMvc;
    @Autowired ObjectMapper objectMapper;
    @MockitoBean CategoryService categoryService;
    @MockitoBean AccountService accountService;

    private Category build(Long id, String name, String slug) {
        Category c = new Category();
        c.setId(id);
        c.setName(name);
        c.setSlug(slug);
        return c;
    }

    private Account account() {
        Account account = new Account();
        account.setId(1L);
        account.setName("User");
        account.setEmail("user@example.com");
        return account;
    }

    @Test
    void GET_categories_returns200WithList() throws Exception {
        when(categoryService.findVisible(null)).thenReturn(List.of(
                build(1L, "AWS", "aws"),
                build(2L, "Java", "java")
        ));

        mockMvc.perform(get("/api/categories"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(2))
                .andExpect(jsonPath("$[0].slug").value("aws"))
                .andExpect(jsonPath("$[1].slug").value("java"));
    }

    @Test
    void GET_categoryById_returns200() throws Exception {
        when(categoryService.findById(1L)).thenReturn(build(1L, "AWS", "aws"));

        mockMvc.perform(get("/api/categories/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("AWS"))
                .andExpect(jsonPath("$.slug").value("aws"));
    }

    @Test
    void GET_categoryById_returns404WhenNotFound() throws Exception {
        when(categoryService.findById(99L)).thenThrow(new NoSuchElementException("Category not found: 99"));

        mockMvc.perform(get("/api/categories/99"))
                .andExpect(status().isNotFound());
    }

    @Test
    void POST_category_returns200WithSavedCategory() throws Exception {
        Category input = build(null, "Angular", "angular");
        Category saved = build(3L, "Angular", "angular");
        when(accountService.requireAccount("Bearer token")).thenReturn(account());
        when(categoryService.saveForAccount(any(), any())).thenReturn(saved);

        mockMvc.perform(post("/api/categories")
                        .header("Authorization", "Bearer token")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(input)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(3))
                .andExpect(jsonPath("$.slug").value("angular"));
    }
}
