package com.swequizzes.quiz;

import java.util.List;

public record CreateQuizRequest(
        String title,
        String description,
        String categorySlug,
        Integer timeSeconds,
        List<CreateQuestionRequest> questions,
        List<Long> systemQuestionIds
) {}
