package com.swequizzes.category;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface CategoryRepository extends JpaRepository<Category, Long> {
    Optional<Category> findBySlug(String slug);

    @Query("""
            select count(q) > 0
            from Quiz q
            where q.category.id = :categoryId
              and q.account is null
            """)
    boolean hasSystemQuiz(@Param("categoryId") Long categoryId);

    @Query("""
            select distinct c
            from Category c
            where c.account is null
              and exists (
                select q.id
                from Quiz q
                where q.category = c
                  and q.account is null
              )
            order by c.name
            """)
    List<Category> findSystemCategories();

    @Query("""
            select distinct c
            from Category c
            where (
              c.account is null
              and exists (
                select q.id
                from Quiz q
                where q.category = c
                  and q.account is null
              )
            )
            or c.account.id = :accountId
            or exists (
              select q.id
              from Quiz q
              where q.category = c
                and q.account.id = :accountId
            )
            order by c.name
            """)
    List<Category> findSystemAndAccountCategories(@Param("accountId") Long accountId);
}
