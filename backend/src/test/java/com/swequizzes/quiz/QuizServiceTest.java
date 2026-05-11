package com.swequizzes.quiz;

import com.swequizzes.category.Category;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class QuizServiceTest {

    @Mock
    QuizRepository quizRepository;

    @InjectMocks
    QuizService quizService;

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
    void findAll_returnsAllQuizzes() {
        when(quizRepository.findByAccountIsNull()).thenReturn(List.of(
                buildQuiz(1L, "AWS Fundamentals"),
                buildQuiz(2L, "Java Core")
        ));

        List<Quiz> result = quizService.findAll();

        assertThat(result).hasSize(2);
        assertThat(result).extracting(Quiz::getTitle)
                .containsExactly("AWS Fundamentals", "Java Core");
    }

    @Test
    void findAll_returnsEmptyListWhenNoQuizzes() {
        when(quizRepository.findByAccountIsNull()).thenReturn(List.of());
        assertThat(quizService.findAll()).isEmpty();
    }

    @Test
    void findById_returnsQuizWhenFound() {
        Quiz quiz = buildQuiz(1L, "AWS Fundamentals");
        when(quizRepository.findById(1L)).thenReturn(Optional.of(quiz));

        Quiz result = quizService.findById(1L);

        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getTitle()).isEqualTo("AWS Fundamentals");
        assertThat(result.getCategory().getSlug()).isEqualTo("aws");
    }

    @Test
    void findById_throwsWhenNotFound() {
        when(quizRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> quizService.findById(99L))
                .isInstanceOf(NoSuchElementException.class)
                .hasMessageContaining("99");
    }
}
