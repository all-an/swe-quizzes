package com.swequizzes.quiz;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.swequizzes.account.AccountService;
import com.swequizzes.category.Category;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.NoSuchElementException;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(QuizController.class)
class QuizControllerTest {

    @Autowired MockMvc mockMvc;
    @Autowired ObjectMapper objectMapper;
    @MockitoBean QuizService quizService;
    @MockitoBean AccountService accountService;

    private Category buildCategory() {
        Category c = new Category();
        c.setId(1L);
        c.setName("AWS");
        c.setSlug("aws");
        return c;
    }

    private Quiz buildQuiz(Long id, String title) {
        Quiz q = new Quiz();
        q.setId(id);
        q.setTitle(title);
        q.setDescription("desc");
        q.setCategory(buildCategory());
        q.setTimeSeconds(300);
        q.setQuestions(List.of());
        return q;
    }

    @Test
    void GET_quizzes_returns200WithList() throws Exception {
        when(quizService.findAll()).thenReturn(List.of(
                buildQuiz(1L, "AWS Fundamentals"),
                buildQuiz(2L, "Java Core")
        ));

        mockMvc.perform(get("/api/quizzes"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(2))
                .andExpect(jsonPath("$[0].title").value("AWS Fundamentals"))
                .andExpect(jsonPath("$[1].title").value("Java Core"));
    }

    @Test
    void GET_quizzes_returnsEmptyListWhenNone() throws Exception {
        when(quizService.findAll()).thenReturn(List.of());

        mockMvc.perform(get("/api/quizzes"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(0));
    }

    @Test
    void GET_quizById_returns200WithQuizAndCategory() throws Exception {
        when(quizService.findById(1L)).thenReturn(buildQuiz(1L, "AWS Fundamentals"));

        mockMvc.perform(get("/api/quizzes/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.title").value("AWS Fundamentals"))
                .andExpect(jsonPath("$.category.slug").value("aws"))
                .andExpect(jsonPath("$.category.name").value("AWS"));
    }

    @Test
    void GET_quizById_returns404WhenNotFound() throws Exception {
        when(quizService.findById(99L)).thenThrow(new NoSuchElementException("Quiz not found: 99"));

        mockMvc.perform(get("/api/quizzes/99"))
                .andExpect(status().isNotFound());
    }
}
