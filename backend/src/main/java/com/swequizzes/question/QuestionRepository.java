package com.swequizzes.question;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface QuestionRepository extends JpaRepository<Question, Long> {
    List<Question> findByQuiz_AccountIsNullAndQuiz_Category_Slug(String slug);
}
