package com.swequizzes.quiz;

import com.swequizzes.account.Account;
import com.swequizzes.answer.Answer;
import com.swequizzes.category.Category;
import com.swequizzes.category.CategoryRepository;
import com.swequizzes.question.Question;
import com.swequizzes.question.QuestionRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Locale;

@Service
public class QuizService {

    private final QuizRepository quizRepository;
    private final CategoryRepository categoryRepository;
    private final QuestionRepository questionRepository;

    public QuizService(
            QuizRepository quizRepository,
            CategoryRepository categoryRepository,
            QuestionRepository questionRepository
    ) {
        this.quizRepository = quizRepository;
        this.categoryRepository = categoryRepository;
        this.questionRepository = questionRepository;
    }

    public List<Quiz> findAll() {
        return quizRepository.findByAccountIsNull();
    }

    public List<Quiz> findByCategory(String slug) {
        return quizRepository.findByCategory_SlugAndAccountIsNull(slug);
    }

    public List<Quiz> findByCategory(String slug, Account account) {
        if (account == null) {
            return findByCategory(slug);
        }
        return quizRepository.findVisibleByCategory(slug, account.getId());
    }

    public Quiz findById(Long id) {
        return quizRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Quiz not found: " + id));
    }

    public List<Quiz> findByAccount(Account account) {
        return quizRepository.findByAccount(account);
    }

    public List<Question> findSystemQuestions(String categorySlug) {
        return questionRepository.findByQuiz_AccountIsNullAndQuiz_Category_Slug(categorySlug);
    }

    @Transactional
    public Quiz create(Account account, CreateQuizRequest request) {
        Quiz quiz = new Quiz();
        quiz.setAccount(account);
        applyRequest(quiz, request);
        return quizRepository.save(quiz);
    }

    @Transactional
    public Quiz update(Quiz quiz, CreateQuizRequest request) {
        applyRequest(quiz, request);
        return quizRepository.save(quiz);
    }

    private void applyRequest(Quiz quiz, CreateQuizRequest request) {
        Category category = categoryRepository.findBySlug(requireText(request.categorySlug(), "Category is required"))
                .orElseThrow(() -> new NoSuchElementException("Category not found: " + request.categorySlug()));
        quiz.setTitle(requireText(request.title(), "Title is required"));
        quiz.setDescription(requireText(request.description(), "Description is required"));
        quiz.setCategory(category);
        quiz.setRandomized(Boolean.TRUE.equals(request.randomized()));
        List<Question> questions = new ArrayList<>();
        if (request.systemQuestionIds() != null && !request.systemQuestionIds().isEmpty()) {
            for (Question systemQuestion : questionRepository.findAllById(request.systemQuestionIds())) {
                if (systemQuestion.getQuiz().getAccount() != null) {
                    throw new IllegalArgumentException("Only system questions can be reused");
                }
                questions.add(copyQuestion(systemQuestion, quiz));
            }
        }
        if (request.questions() != null) {
            for (CreateQuestionRequest questionRequest : request.questions()) {
                questions.add(buildQuestion(questionRequest, quiz));
            }
        }
        if (questions.isEmpty()) {
            throw new IllegalArgumentException("At least one question is required");
        }

        int totalTime = request.timeSeconds() != null ? request.timeSeconds() : questions.stream().mapToInt(Question::getTimeSeconds).sum();
        if (totalTime <= 0) {
            throw new IllegalArgumentException("Quiz time must be positive");
        }
        quiz.setTimeSeconds(totalTime);
        if (quiz.getQuestions() == null) {
            quiz.setQuestions(new ArrayList<>());
        } else {
            quiz.getQuestions().clear();
        }
        quiz.getQuestions().addAll(questions);
    }

    private Question buildQuestion(CreateQuestionRequest request, Quiz quiz) {
        Question question = new Question();
        question.setQuiz(quiz);
        question.setText(requireText(request.text(), "Question text is required"));
        question.setCodeSnippet(blankToNull(request.codeSnippet()));
        question.setCodeLanguage(normalizeLanguage(request.codeLanguage(), question.getCodeSnippet()));
        int timeSeconds = request.timeSeconds() == null ? 30 : request.timeSeconds();
        if (timeSeconds <= 0) {
            throw new IllegalArgumentException("Question time must be positive");
        }
        question.setTimeSeconds(timeSeconds);

        if (request.answers() == null || request.answers().isEmpty()) {
            throw new IllegalArgumentException("Each question must have answers");
        }
        List<Answer> answers = request.answers().stream()
                .map(answerRequest -> buildAnswer(answerRequest, question))
                .toList();
        if (answers.stream().noneMatch(Answer::isCorrect)) {
            throw new IllegalArgumentException("Each question must have at least one correct answer");
        }
        question.setAnswers(answers);
        return question;
    }

    private Answer buildAnswer(CreateAnswerRequest request, Question question) {
        Answer answer = new Answer();
        answer.setQuestion(question);
        answer.setDescription(requireText(request.description(), "Answer description is required"));
        answer.setCodeSnippet(blankToNull(request.codeSnippet()));
        answer.setCodeLanguage(normalizeLanguage(request.codeLanguage(), answer.getCodeSnippet()));
        answer.setCorrect(Boolean.TRUE.equals(request.correct()));
        return answer;
    }

    private Question copyQuestion(Question source, Quiz quiz) {
        Question copy = new Question();
        copy.setQuiz(quiz);
        copy.setText(source.getText());
        copy.setCodeSnippet(source.getCodeSnippet());
        copy.setCodeLanguage(source.getCodeLanguage());
        copy.setTimeSeconds(source.getTimeSeconds());
        List<Answer> answers = source.getAnswers().stream()
                .map(sourceAnswer -> copyAnswer(sourceAnswer, copy))
                .toList();
        copy.setAnswers(answers);
        return copy;
    }

    private Answer copyAnswer(Answer source, Question question) {
        Answer copy = new Answer();
        copy.setQuestion(question);
        copy.setDescription(source.getDescription());
        copy.setCodeSnippet(source.getCodeSnippet());
        copy.setCodeLanguage(source.getCodeLanguage());
        copy.setCorrect(source.isCorrect());
        return copy;
    }

    private String normalizeLanguage(String language, String codeSnippet) {
        String normalized = blankToNull(language);
        if (codeSnippet == null) {
            return null;
        }
        if (normalized == null) {
            throw new IllegalArgumentException("Code language is required when code is present");
        }
        normalized = normalized.toLowerCase(Locale.ROOT);
        if (!normalized.equals("java") && !normalized.equals("typescript")) {
            throw new IllegalArgumentException("Code language must be java or typescript");
        }
        return normalized;
    }

    private String requireText(String value, String message) {
        String normalized = blankToNull(value);
        if (normalized == null) {
            throw new IllegalArgumentException(message);
        }
        return normalized;
    }

    private String blankToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return value.trim();
    }
}
