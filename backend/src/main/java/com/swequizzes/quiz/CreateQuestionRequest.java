package com.swequizzes.quiz;

import java.util.List;

public record CreateQuestionRequest(
        String text,
        String codeSnippet,
        String codeLanguage,
        Integer timeSeconds,
        List<CreateAnswerRequest> answers
) {}
