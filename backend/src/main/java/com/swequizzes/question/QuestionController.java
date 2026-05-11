package com.swequizzes.question;

import com.swequizzes.quiz.QuizService;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/questions")
public class QuestionController {
    private final QuizService quizService;

    public QuestionController(QuizService quizService) {
        this.quizService = quizService;
    }

    @GetMapping("/system")
    public List<Question> findSystemQuestions(@RequestParam String category) {
        return quizService.findSystemQuestions(category);
    }
}
