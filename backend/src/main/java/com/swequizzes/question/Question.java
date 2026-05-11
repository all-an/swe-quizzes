package com.swequizzes.question;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.swequizzes.answer.Answer;
import com.swequizzes.quiz.Quiz;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "question")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Question {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String text;

    @Column(columnDefinition = "TEXT")
    private String codeSnippet;

    @Column(length = 20)
    private String codeLanguage;

    @Column(nullable = false)
    private int timeSeconds;

    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_id", nullable = false)
    private Quiz quiz;

    @OneToMany(mappedBy = "question", fetch = FetchType.EAGER, cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("id ASC")
    private List<Answer> answers;

    public Long getId() { return id; }
    public String getText() { return text; }
    public String getCodeSnippet() { return codeSnippet; }
    public String getCodeLanguage() { return codeLanguage; }
    public int getTimeSeconds() { return timeSeconds; }
    @JsonIgnore
    public Quiz getQuiz() { return quiz; }
    public List<Answer> getAnswers() { return answers; }

    public void setId(Long id) { this.id = id; }
    public void setText(String text) { this.text = text; }
    public void setCodeSnippet(String codeSnippet) { this.codeSnippet = codeSnippet; }
    public void setCodeLanguage(String codeLanguage) { this.codeLanguage = codeLanguage; }
    public void setTimeSeconds(int timeSeconds) { this.timeSeconds = timeSeconds; }
    public void setQuiz(Quiz quiz) { this.quiz = quiz; }
    public void setAnswers(List<Answer> answers) { this.answers = answers; }
}
