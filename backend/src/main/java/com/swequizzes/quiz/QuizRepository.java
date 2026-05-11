package com.swequizzes.quiz;

import com.swequizzes.account.Account;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface QuizRepository extends JpaRepository<Quiz, Long> {
    List<Quiz> findByAccountIsNull();
    List<Quiz> findByCategory_SlugAndAccountIsNull(String slug);
    @Query("""
            select q
            from Quiz q
            where q.category.slug = :slug
              and (q.account is null or q.account.id = :accountId)
            order by q.id
            """)
    List<Quiz> findVisibleByCategory(@Param("slug") String slug, @Param("accountId") Long accountId);
    List<Quiz> findByAccount(Account account);
}
