package com.swequizzes.quiz;

import java.util.List;

public record CreateQuizRequest(
        String title,
        String description,
        String categorySlug,
        Integer timeSeconds,
        Boolean randomized,
        List<CreateQuestionRequest> questions,
        List<Long> systemQuestionIds
) {}
