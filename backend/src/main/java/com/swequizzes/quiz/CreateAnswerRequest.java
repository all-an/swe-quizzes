package com.swequizzes.quiz;

public record CreateAnswerRequest(
        String description,
        String codeSnippet,
        String codeLanguage,
        Boolean correct
) {}
