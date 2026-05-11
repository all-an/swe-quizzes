package com.swequizzes.answer;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.swequizzes.question.Question;
import jakarta.persistence.*;

@Entity
@Table(name = "answer")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Answer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(columnDefinition = "TEXT")
    private String codeSnippet;

    @Column(length = 20)
    private String codeLanguage;

    @Column(nullable = false)
    private boolean correct;

    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "question_id", nullable = false)
    private Question question;

    public Long getId() { return id; }
    public String getDescription() { return description; }
    public String getCodeSnippet() { return codeSnippet; }
    public String getCodeLanguage() { return codeLanguage; }
    public boolean isCorrect() { return correct; }

    public void setId(Long id) { this.id = id; }
    public void setDescription(String description) { this.description = description; }
    public void setCodeSnippet(String codeSnippet) { this.codeSnippet = codeSnippet; }
    public void setCodeLanguage(String codeLanguage) { this.codeLanguage = codeLanguage; }
    public void setCorrect(boolean correct) { this.correct = correct; }
    public void setQuestion(Question question) { this.question = question; }
}
